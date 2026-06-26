---
name: freedolia-estudi
description: >
  Estudi complet d'un projecte Freedolia abans de definir producte o escriure codi.
  Investiga el codi, la documentació canònica (CLAUDE.md, AGENTS.md, WORKFLOW.md,
  SAAS-MODEL.md, docs/LESSONS.md, docs/SKILLS.md) i els artefactes existents
  (_bmad-output) i en treu un MAPA del projecte + oportunitats/riscos. Activa-la
  quan l'usuari demani "estudia el projecte", "audita això", "què tenim?", "per on
  ataquem", o abans d'un PRD/spec quan el context del codi no és clar. Sortida:
  un informe estructurat en català, no codi. Cost zero (només llegeix el repo).
---

# Freedolia — estudi complet del projecte

> **Objectiu:** entendre el terreny abans de construir-hi res. Aquesta skill **no
> escriu codi ni PRDs** — produeix un mapa fidel del projecte que alimenta
> `freedolia-prd` i `freedolia-spec`. La regla de ferro: **res inventat**. Cada
> afirmació surt d'un fitxer que has llegit de debò, no del nom d'un fitxer.

## 0. Regles d'or

- **Català, directe** (CLAUDE.md). Conclusions, no descripcions llargues. El David vol el mapa, no un tour.
- **Grounded sempre.** Si dius "X funciona així", és perquè ho has llegit. Si no ho has verificat, marca-ho `[a confirmar]`.
- **Cost com a restricció dura.** Quan proposis oportunitats, prioritza les de **cost zero** sobre la infra pròpia (Supabase + edge functions + Vercel + free tiers). Marca qualsevol idea que toqui IA/Places amb `⚠️ cost`. [[cost-es-la-restriccio-dura]]
- **No toquis res.** És lectura pura: cap edició, cap git, cap deploy.

## 1. Llegir el canònic primer (per ordre)

Carrega el que existeixi, en aquest ordre, perquè és la veritat del projecte:

1. `CLAUDE.md` — instruccions i regles d'or del projecte.
2. `AGENTS.md` — patterns tècnics (RLS, edge functions, gotchas).
3. `WORKFLOW.md` — procés git + Vercel.
4. `SAAS-MODEL.md` — model de negoci (preus, plans, conversió).
5. `docs/LESSONS.md` — **errors reals a no repetir**. Llegeix-ho sempre abans de proposar res sensible.
6. `docs/SKILLS.md` — runbooks i capacitats.
7. `_bmad-output/planning-artifacts/*` i `_bmad-output/implementation-artifacts/*` — PRDs i specs ja fets (no els repeteixis).
8. `docs/*` — informes puntuals (context, no canònic).

Si algun no existeix, salta'l sense bloquejar. Si NO és un projecte Freedolia (no hi ha CLAUDE.md
amb aquestes seccions), digues-ho i adapta: llegeix README, package.json i l'estructura per inferir convencions.

## 2. Investigar el codi (mòdul a mòdul, no fitxer a fitxer)

L'objectiu és un **mapa**, no un inventari. Per a cada àrea rellevant, respon: què fa, on viu, com es connecta.

- **Estructura**: `src/routes/` (TanStack file-based), `src/components/admin/`, `src/hooks/` (un per taula), `supabase/functions/` (40+ edge functions), `supabase/migrations/`.
- **Patrons reals**: com es fan les queries (RLS + tenant), els casts `(supabase as any)`, la coerció `Number(x ?? 0)` de bigint, els feature flags per tenant (M-7), els pipelines de comunicació (email/WhatsApp entrant/sortint).
- **Pistes d'estat**: mira `git log --oneline` recent i la numeració `M-NN` per saber on s'està treballant ara.
- Usa subagents (`Explore`) per a escombrades amples si el codi és gran: et tornen la conclusió, no els bolcats.

Para quan puguis respondre, **sense endevinar**: on viu cada cosa, com funciona avui, què depèn de què, i on són els forats.

## 3. Sortida — l'informe (format literal)

Torna exactament aquesta estructura en català. Concís. Si un bloc no aplica, `—`.

```
# Estudi — {nom del projecte} · {data}

## 1. Què és (3 línies)
{què serveix, a qui, stack}

## 2. Mapa del sistema
- **Webs/landings:** {…}
- **Panel admin:** {mòduls reals: CRM, projectes, comptabilitat, blog, outreach, comunicacions…}
- **Backend:** {Supabase project, edge functions clau, cron}
- **Comunicacions:** {pipelines email/WhatsApp entrant i sortint}

## 3. Convencions que un agent ha de respectar
- {regla viva extreta de CLAUDE.md/AGENTS.md/LESSONS.md, amb el perquè}
- …

## 4. Estat actual
- En curs ara: {pel que diu el git log / M-NN recents}
- PRDs/specs ja existents: {llista — NO els refacis}

## 5. Oportunitats i riscos (prioritzat)
| # | Oportunitat / risc | Impacte | Esforç | Cost | Nota |
|---|---|---|---|---|---|
| 1 | {…} | alt/mitjà/baix | S/M/L | 0 / ⚠️ | {per què} |

## 6. Recomanació
{1–3 frases: per on atacaria primer i per què. Si toca, "→ següent pas: freedolia-prd sobre X".}
```

## 4. Casos límit

- **Repo enorme:** no llegeixis tot. Mostreja per mòdul i digues explícitament què NO has mirat (mai facis veure que ho cobreixes tot — això és un error de LESSONS).
- **Contradiccions docs vs codi:** el codi mana sobre el doc; marca la discrepància a §3 com a risc.
- **Et demanen "audita la UI/disseny":** això és terreny de `freedolia-design` (al projecte). Reenvia-hi.
- **Següent pas natural:** quan l'estudi revela una feature/producte a construir → proposa `freedolia-prd`. Quan revela un bug/feature concret amb context ja clar → `freedolia-spec`. No saltis tu sol: proposa.
