---
name: freedolia-aterratge
description: >
  Baixa un MVP generat a Lovable al terreny Freedolia: el repatria a C:\Projects, li
  posa Supabase propi amb schema dedicat i RLS, cablega la capa de serveis, hi afegeix
  auth, el desacobla de Lovable i el deixa desplegable a Vercel. Activa-la quan l'usuari
  digui "baixem l'MVP de Lovable", "portem això al nostre terreny", "cablega Supabase",
  "treu Lovable d'aquí", o quan porti un MVP visual 100% mock que ha de passar a
  producte. El pas ENTRE el prompt de Lovable i freedolia-spec/dev. Sortida: codi
  funcionant amb dades reals, no un informe.
---

# Freedolia — aterratge d'un MVP de Lovable

> **Objectiu:** convertir una demo maca però buida en un producte amb dades reals,
> sense tocar les pantalles ni el disseny. Lovable ha fet la cara; aquí li posem el cos.
>
> Aquest camí ja s'ha recorregut a **Clinicull** (`clinicflow-ai`, specs F1–F4) i a
> **StockPilot**. Les receptes d'aquí surten d'aquestes dues execucions reals, amb els
> ensopecs inclosos. No improvisis un camí nou: si en trobes un de millor, actualitza
> aquesta skill.

## 0. Regles d'or

- **Català, directe.** El David decideix; tu proposes i executes.
- **Cost zero.** Infra pròpia: Supabase existent + Vercel free tier. Res d'IA/Places nou sense topall i ok explícit. [[cost-es-la-restriccio-dura]]
- **El gate és el preview de Vercel, no el typecheck.** Un `vite.config.ts` trencat el `tsc` **no** el veu. Cap merge a `main` amb la preview vermella.
- **El fallback a mock no es trenca mai.** Sense env vars, l'app ha de seguir servint `src/data/mock.ts`. És la xarxa de seguretat de la demo comercial.
- **Mai `service_role` al front.** Només l'anon key. Comprova que no surt al bundle.
- **Additiu sempre.** El projecte Supabase és compartit: cap `drop`, cap canvi que toqui schemas d'altres productes.
- **Un producte = un repo de GitHub + un projecte de Vercel. Sempre.** El que es comparteix és el projecte Supabase (amb schema dedicat), res més. `freedolia-hub` és un producte com qualsevol altre, **no un calaix comú**: no hi deixis mai documents, estudis ni material d'un altre producte. Si un document no té repo on anar, va al kit (`references/`), no al repo del veí.

## 1. Abans de començar

Necessites tres coses. Si en falta una, para i demana-la:

1. **El repo de GitHub** que Lovable sincronitza. **Clona'l, no facis servir el zip.** El zip no porta història i els finals de línia et deixaran tot el repo marcat com a modificat. Si ja tens el zip desempaquetat, mou-hi el `.git` del clone i fes `git config core.autocrlf false` + `git add -u` per refrescar l'índex sense tocar cap fitxer.
2. **Un projecte Supabase.** Es reutilitza `n8n-freedolia`; el producte va en un **schema dedicat** (`clinica`, `stockpilot`, …), mai a `public`. Així migrar-lo demà a un projecte propi és un dump d'un sol schema.
3. **Els tipus de l'MVP** (`src/types/models.ts`) i la capa de serveis (`src/services/index.ts`). Si les pantalles llegeixen el mock directament, arregla-ho primer: tot ha de passar pels serveis.

El projecte va a `C:\Projects\<nom>`. [[projects-live-in-c-projects]]

## 2. Qui mana: l'SQL o els tipus?

La decisió que bloqueja tota la resta. Els dos casos reals van resoldre's diferent i tots dos són correctes:

- **Mana l'SQL** quan ja te'l dona el generador, o quan la dada ha de sobreviure a migracions serioses. Els serveis fan JOIN/agregació i **mapegen** al shape que la UI espera, amb un `src/lib/mappers.ts` per traduir enums i camps derivats. *(Clinicull: enums SQL en castellà → claus angleses d'UI.)*
- **Manen els tipus** quan l'MVP ja funciona i l'SQL encara no existeix de veritat. Es genera l'schema a partir de `src/types/models.ts` i el mapping queda en un rename mecànic snake_case ↔ camelCase. *(StockPilot.)*

**No et refiïs d'un SQL que digui "mapeja 1:1 amb els tipus".** A StockPilot ho deia al capçal i era fals: faltaven taules senceres (línies de comanda), els enums estaven en un altre idioma i els agregats tenien una forma diferent. **Verifica-ho camp a camp abans de decidir.**

## 3. Schema, RLS i seed

Migracions **versionades i separades** — mai barrejar estructura i dades:

- `supabase/migrations/0001_<schema>_schema.sql` — `create schema if not exists`, enums, taules, RLS, funció de tenant. Idempotent, re-executable.
- `supabase/migrations/0002_<schema>_seed_<nom>.sql` — el seed, una sola vegada, protegit per un `if exists (...) then return`.

Regles que valen per a tots els productes:

- **Enums dins del schema del producte** (`create type stockpilot.stock_status …`), no a `public`: noms com `order_status` o `language` xoquen entre productes.
- **Multi-tenant per membres**: taula `<x>_members` + funció `security definer` que retorna els ids del tenant de `auth.uid()`, i una policy `for all to authenticated` amb `using` **i** `with check` a cada taula. El `with check` és el que deixa preparades les escriptures futures.
- **Paraules reservades**: `window` no es pot fer servir com a columna, i `order` xoca amb el paràmetre `?order=` de PostgREST. Renombra (`time_window`, `stop_order`) i documenta el rename al capçal del fitxer.
- **El seed replica `src/data/mock.ts`** fila per fila. Així, en canviar de mock a backend, la UI ha de quedar idèntica: qualsevol diferència visible és un bug del cablejat.

## 4. Exposar el schema a l'API ⚠️

**El pas que sempre triga més del que sembla.** A `n8n-freedolia` ni el dashboard (*Data API → Exposed schemas*) ni `PATCH /v1/projects/{ref}/postgrest` tenen cap efecte: escriuen en un lloc que PostgREST no llegeix. Reiniciar el projecte tampoc serveix.

La llista real viu al rol `authenticator` de la base de dades:

```sql
-- 1) mira què hi ha ara i NO en treguis cap (hi viuen altres productes)
select rolconfig from pg_roles where rolname = 'authenticator';

-- 2) afegeix el teu, conservant la resta
alter role authenticator set pgrst.db_schemas = 'public, graphql_public, clinica, <nou>';

-- 3) les dues notificacions: config i schema
notify pgrst, 'reload config';
notify pgrst, 'reload schema';   -- sense aquesta: PGRST205 "not found in schema cache"
```

I els permisos:

```sql
grant usage on schema <nou> to authenticated, service_role;
grant select, insert, update, delete on all tables in schema <nou> to authenticated;
alter default privileges in schema <nou> grant select, insert, update, delete on tables to authenticated;
```

`anon` no rep res: l'app viu darrere del login.

**Com comprovar la llista de veritat**, sense fiar-te de cap panell: fes una petició amb un `Accept-Profile` inventat i llegeix l'error.

```
GET /rest/v1/<taula>   Accept-Profile: __probe__
→ PGRST106 "Only the following schemas are exposed: …"   ← aquesta és la llista real
```

## 5. Client i capa de serveis

```ts
// src/lib/supabase.ts
export const supabase = hasBackend
  ? createClient(url, anonKey, {
      db: { schema: "<nou>" },
      auth: { persistSession: isBrowser, autoRefreshToken: isBrowser, detectSessionInUrl: isBrowser },
    })
  : null;
```

- **La sessió, només al navegador.** Aquest mòdul també s'importa durant l'SSR; sense el guard, peta buscant `localStorage`.
- **No anotis el client amb `SupabaseClient`**: el tipus per defecte assumeix schema `public` i rebutja el teu. Deixa que TypeScript l'inferisca.
- **Signatures intactes.** Les pantalles no es toquen: cada getter manté nom, arguments i tipus de retorn, i només canvia per dins.
- **`Number(x ?? 0)`** per a tot el que vingui de `numeric`/`bigint`: Postgres els pot enviar com a string.
- **Fills per embedding** (`select("…, order_items(product_id,qty)")`) i **ordena'ls a JS**. L'API d'ordenació de taules incrustades ha canviat de nom entre versions de `supabase-js`; ordenar a mà no depèn de la versió.
- **Els errors es llancen**, amb el nom de la taula al missatge. Retornar una llista buida quan hi ha un error de permisos et fa perdre hores buscant on són les dades.

## 6. Auth

Gate al `__root.tsx` que embolcalla l'shell. Login email/password amb `signInWithPassword`, i sortir de sessió visible.

**El parany d'hidratació:** una sessió només es resol al navegador. Fes que l'estat `ready` comenci en `false` **tant al servidor com al client**, i que tots dos pintin el mateix splash; el client ja decidirà després. Així no cal `ClientOnly` i l'shell segueix servint-se per SSR.

Usuaris pilot: [[pilot-demo-users]]. **Comprova sempre si ja existeixen** — en un Supabase compartit el compte del David sol venir d'un producte anterior; en aquest cas afegeix-hi només la fila de membresia i no li toquis la contrasenya.

## 7. Desacoblar Lovable

Es fa **al final**, quan l'app ja funciona amb dades reals. Té un ordre:

1. `src/routes/__root.tsx` — treu l'import de `reportLovableError`; substitueix per `console.error`.
2. Esborra `src/lib/lovable-error-reporting.ts` i `.lovable/`.
3. `AGENTS.md` — treu el bloc `<!-- LOVABLE:BEGIN … END -->`. Amb això deixen de valer les regles de no reescriure història.
4. `bunfig.toml` — treu les entrades `@lovable.dev` de `minimumReleaseAgeExcludes`.
5. `vite.config.ts` — reconstrueix-lo amb els plugins estàndard, que és el que el wrapper composava:

```ts
import { defineConfig } from "vite";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import viteReact from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import tsConfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  server: { port: 8080 },
  plugins: [tsConfigPaths(), tailwindcss(), tanstackStart({ server: { entry: "server" } }), viteReact()],
});
```

6. `package.json` — fora `@lovable.dev/vite-tanstack-config`, i reinstal·la.

**Conserva `server.entry: 'server'`**: redirigeix l'SSR a `src/server.ts`, que és el nostre wrapper d'errors i no depèn de Lovable. **Nitro sense preset**: auto-detecta la plataforma i a Vercel genera sortida Vercel. (Si encara NO has tret el wrapper i has de desplegar a Vercel, el preset de Lovable accepta `nitro: { preset: "vercel" }`.)

La desconnexió del sync **Lovable ↔ GitHub** la fa el David al dashboard de Lovable. No és al repo.

## 8. Desplegament

- Les credencials són `VITE_*`: **s'incrusten al bundle en temps de build**, no es llegeixen en execució. Posa-les al projecte de Vercel **abans** del primer build, o el desplegament sortirà en mode mock — sense login i amb dades falses, semblant que funciona. És el fallament més enganyós del procés.
- `.gitignore` ha d'excloure `.vercel` i `.output`.
- L'anon key al bundle és correcte: qui protegeix és l'RLS, no la clau.

## 9. Verificació (no et saltis cap punt)

| Prova | Com |
|---|---|
| Schema exposat | `Accept-Profile: __probe__` → la llista real, i que els altres productes hi segueixin |
| RLS tanca | com a `anon` contra una taula del schema → **401 permission denied** |
| RLS obre | login d'un membre → files reals; simula un `auth.uid()` sense membresia → **0 files** |
| Els embeds | crida cada consulta amb fills i compta'ls contra el seed |
| Compilació | `tsc --noEmit` i `eslint` **només dels fitxers tocats** (aquests repos no solen ser prettier-nets de sèrie: no reformategis el que no has escrit) |
| SSR | arrenca dev i fes una petició HTTP: ha de tornar 200, pintar l'splash i **no filtrar ni dades ni menú** sense sessió |
| Gate final | push → **preview de Vercel Ready** + login + dues pantalles. Només llavors, `main` |

## 10. Errors reals a no repetir

- Fiar-se d'un panell de configuració en comptes de comprovar el runtime (§4). Va costar un reinici de projecte inútil.
- Fer un `PATCH` que **substitueix** una llista compartida sense llegir-la abans: per poc deixa un altre producte sense API.
- Donar per bo un SQL que diu que mapeja 1:1 amb els tipus (§2).
- Fer servir el zip en comptes del clone i acabar amb 91 fitxers "modificats" que només són finals de línia.
- Reformatar tot el repo perquè el linter es queixa de fitxers que no has tocat.

## 11. Següent pas

Amb l'MVP aterrat, les dades són **de només lectura**: els botons d'aprovar/editar/escalar segueixen sent decoratius. Aquest és el primer bloc de feina real i ja no necessita canvis d'esquema, perquè l'RLS porta `with check` des del principi.

→ obre `freedolia-spec` sobre les escriptures, feature a feature.
