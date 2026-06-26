---
name: freedolia-dev
description: >
  Implementa una spec ready-for-dev (de freedolia-spec o compatible) produint codi
  net que segueix l'arquitectura i convencions de freedolia-hub, endurit per un
  bucle de revisió adversarial. També resol canvis trivials de zero blast-radius
  directament (one-shot). Activa-la quan l'usuari digui "implementa aquesta spec",
  "dev this", "fes aquest canvi", o porti un fix petit. El pas DESPRÉS de freedolia-spec.
---

# Freedolia — Dev

**Objectiu:** convertir una spec aprovada en codi endurit i revisable. El pensament dur (descobriment,
investigació, pla) ja va passar a `freedolia-spec` — aquí s'executa amb disciplina i es revisa
adversarialment.

## 0. Divisió de feina

- `freedolia-prd` defineix el producte · `freedolia-spec` investiga i produeix la spec · `freedolia-dev` la implementa.
- Aquesta skill **no fa descobriment de producte ni planificació profunda**. Si la intenció no té spec i
  no és trivialment segura → enruta a `freedolia-spec`, no improvisis un pla.
- Estats de spec (contracte compartit): `draft` → `ready-for-dev` → `in-progress` → `in-review` → `done`.
- Contingut dins `<frozen-after-approval>` és **read-only**: només el David el canvia.

## 1. Regles dures de freedolia-hub (NO negociables — de CLAUDE.md i LESSONS)

- **Git:** treballa a `development` (`git checkout development && git pull`). **Mai push directe a `main`** —
  el David fa el merge. Missatges `M-NN: descripció curta` (numeració incremental; mira `git log --oneline`).
- **Gate abans de commit:** `npm run typecheck` net. **Mai `npm run build`** dins del workspace IA (lent, inútil; ja ho fa Vercel). `npm run lint` NO és gate (~29k errors CRLF preexistents, L-16).
- **Mai esborrar fitxers sense `git status` abans** (hi ha hagut commits que han borrat 311 fitxers per error).
- **RLS obligatòria** a tota taula llegible per un client. Cap query amb anon key sense filtre per tenant.
- **Mai PII a logs ni URLs.** Mai exposar `service_role_key` al client. Mai canviar tokens d'auth via JS.
- **SaaS de veritat:** cap parche cablejat per a un tenant; tot via `tenants.feature_flags`.
- **Validacions Zod** a tots els forms públics.
- **Tipus:** taules noves → cast `(supabase as any)`. **bigint** de Postgres arriba com a string → `Number(x ?? 0)` abans de comparar. Vistes noves → `WITH (security_invoker=on)`.

## 2. Què NO pots fer tu (límits operatius)

- **Desplegar edge functions:** NO pots. Les desplega el David (o una regla a `settings.local.json`). Prepara el codi de la function i digues-li el `supabase functions deploy <name>` que ha de córrer. [[edge-function-deploy-blocked]]
- **SQL a producció:** es pot fer amb el PAT del David via Management API (User-Agent navegador; `db push` no és segur). No assumeixis que pots; confirma-ho. [[supabase-sql-via-management-api]]
- **Mai** executar trades/transferències/ordres financeres en producció.
- **Mai** pujar secrets ni autoritzar-te a tu mateix.

## 3. Procés

### 3a. Ruta
- **Canvi trivial, zero blast-radius** (typo, copy, constant, un estil): fes-ho one-shot, amb typecheck, i presenta. No cal spec.
- **Tota la resta:** ha de tenir una spec `ready-for-dev`. Si no en té → `freedolia-spec`.

### 3b. Implementar
- Posa la spec a `in-progress`. Treballa a `development`.
- Segueix el Code Map i les Tasks de la spec en ordre de dependència.
- **Escriu codi que es llegeixi com el del voltant:** imita el component/hook veí (naming, idioma dels comentaris, patrons). Abans de fer un `<div>` a mà, mira `src/components/ui/`.
- Respecta les Boundaries de la spec. Si has de fer res de la llista "Ask First" → atura't i pregunta.

### 3c. Revisió adversarial (el que separa "funciona" de "endurit")
Abans de presentar, revisa el teu propi diff **intentant trencar-lo**. Comprova, com a mínim:
- **Correcció:** compleix cada AC (Given/When/Then)? Casos límit i estats buits/error?
- **Blast radius:** has trencat cap cridador/consumidor del que tocaves?
- **Regles dures §1:** RLS, PII, tenant, bigint, Zod, casts — totes respectades?
- **Cost:** cap crida nova a IA/Places? Topalls intactes?
- **Gate:** `npm run typecheck` net.

Si trobes un forat, arregla'l i torna a revisar. Per canvis grans o de risc (auth, migracions, diners,
enviaments), pots delegar la revisió a un subagent adversarial (`ce-adversarial-reviewer` / `ce-correctness-reviewer`).

### 3d. Presentar
- Posa la spec a `in-review`. Resumeix: què has canviat, quins ACs cobreix, què queda per verificar en preview, i qualsevol pas manual (deploy d'edge function, SQL) que ha de fer el David.
- Commit a `development` amb `M-NN: …`. **Push només si el David ho demana**; mai a `main`.

## 4. Casos límit

- **La spec resulta incompleta a mig fer:** atura't, torna a `freedolia-spec` per tancar el forat. No improvisis producte.
- **typecheck peta per coses preexistents alienes al teu canvi:** aïlla-ho, digues-ho, no ho amaguis.
- **Et demanen desplegar/migrar:** prepara-ho i passa la comanda al David (§2). No facis veure que ho has desplegat tu (reporta fidel).
- **Acabat i verificat:** digues-ho pla, amb la sortida del typecheck. Si una prova falla, ensenya-la.
