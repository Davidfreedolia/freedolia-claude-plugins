---
name: freedolia-spec
description: >
  Converteix una intenció de producte vaga o un bug en una spec implementable i
  endurida — via preguntes de producte i investigació profunda del codi. NO
  implementa codi: el lliurable és la spec. Activa-la quan l'usuari digui "fes una
  spec", "specea això", "investiga aquest bug", "prepara aquesta feature", o quan
  tingui una feature d'un PRD a punt per detallar. El pas ENTRE freedolia-prd i
  freedolia-dev. Sortida en català a _bmad-output/implementation-artifacts/.
---

# Freedolia — Spec

**Objectiu:** convertir una feature (sovint d'un PRD) o un bug en una spec **Ready for Development** —
via preguntes de producte i **investigació real del codi**. Aquesta skill **no escriu codi de producte**.
El lliurable és la spec.

## 0. Regles d'or (Freedolia)

- **Català**, directe. Cap palla.
- **Grounded, mai endevinat.** Cada fitxer del Code Map s'ha llegit o verificat de debò durant la
  investigació. Si no l'has obert, no el citis. Inferir del nom d'un fitxer és un error.
- **Cost com a restricció dura.** Si la solució toca IA/Places, marca-ho i mantingues els topalls
  existents (M-47, etc.). La spec ha de dir explícitament "cost igual" o justificar i acotar l'augment. [[cost-es-la-restriccio-dura]]
- **Respecta el canònic.** Abans d'espec-iar res sensible (RLS, migracions, edge functions, enviaments),
  llegeix `docs/LESSONS.md`. Aplica les regles de `CLAUDE.md`/`AGENTS.md`: RLS per tenant, mai PII a
  logs/URLs, `(supabase as any)` per taules noves, `Number(x ?? 0)` per bigint, feature flags per tenant.

## 1. Estàndard "Ready for Development"

Una spec ho és quan:

- **Accionable**: cada tasca té un path de fitxer i una acció concreta.
- **Lògica**: tasques ordenades per dependència.
- **Testable**: tots els criteris d'acceptació en Given/When/Then.
- **Completa**: cap placeholder ni TBD.
- **Ancorada**: cada fitxer del Code Map s'ha llegit/verificat — mai endevinat.

## 2. Estàndard d'abast

Una spec apunta a **un sol objectiu d'usuari** dins ~**900–1600 paraules**:

- **Un objectiu**: una feature cohesiva o un bug, encara que toqui diverses capes/fitxers. Multi-objectiu
  = ≥2 lliurables top-level que es poden enviar independentment → separa en specs.
- Els límits són **proposta amb override de l'usuari**, no una porta.

## 3. Estàndard de suficiència de context

La investigació és suficient quan pots respondre TOT això **sense endevinar**:

1. **On** — quins fitxers/mòduls canvien i quin codi del voltant els limita.
2. **Com funciona avui** — el comportament/flux de dades actual a la zona afectada, verificat llegint codi (no inferit del nom).
3. **Per què** (només bugs) — la causa arrel, traçada a codi concret, o les hipòtesis candidates amb evidència de cadascuna.
4. **Què pot petar** — el blast radius: cridadors, consumidors, estat compartit, integracions tocades.
5. **Què necessita el producte** — problema, valor d'usuari, criteri d'èxit i comportament dels casos límit, confirmat pel David.

Si alguna resposta és una endevinalla, la investigació NO és suficient. Torna a iterar.

## 4. Procés

1. **Intenció.** Confirma en 1–2 frases el problema i l'enfocament. Si ve d'un PRD, ancora-hi el `context`. Pregunta el mínim per omplir el que falti del producte.
2. **Investigació.** Usa `Explore`/Grep/Read per traçar el codi real. Para quan compleixis §3.
3. **Redacció.** Munta la spec amb el format de §5. Marca el commit base actual (`git rev-parse HEAD`).
4. **Checkpoint.** Atura't i ensenya la spec al David. El bloc `<frozen-after-approval>` és la seva intenció: només ell el canvia.

## 5. Format de la spec (literal — calcat a les specs existents)

```
---
title: '{Fx — Nom curt}'
type: 'feature'        # feature | bug | chore
created: '{data}'
status: 'draft'        # draft → ready-for-dev → in-progress → in-review → done
baseline_commit: '{git rev-parse HEAD}'
context:
  - '{project-root}/_bmad-output/planning-artifacts/prd-{slug}/prd.md'   # si ve d'un PRD
---

<frozen-after-approval reason="intenció humana — no modificar si el David no la renegocia">

## Intent
**Problem:** {el problema concret, amb el fitxer/línia que ho evidencia}
**Approach:** {l'enfocament — parametritzar/estendre el que hi ha, no reinventar}

## Product Decisions
- {decisió de producte que afecta la implementació}
- **Cost:** {cost igual / ⚠️ amb topall}

## Boundaries & Constraints
**Always:** {invariants — mantenir topalls de cost, RLS per tenant, retrocompatibilitat, no inventar dades…}
**Ask First:** {coses que requereixen consultar el David abans de fer-les}

</frozen-after-approval>

## Code Map
{Fitxers reals que es toquen, cada un amb una línia del que hi passa avui i què canviarà. NOMÉS fitxers llegits.}
- `src/...` — {què fa avui → què canvia}
- `supabase/functions/.../index.ts` — {…}

## Tasks
1. {acció concreta amb path} — {detall}
2. {…ordenades per dependència}

## Acceptance Criteria
- **AC1** — *Given* {context} *When* {acció} *Then* {resultat observable}
- **AC2** — …

## Verificació
- Gate: `npm run typecheck` net.
- {proves manuals concretes a fer en preview}
```

## 6. Casos límit

- **Context insuficient i el David no és aquí per aclarir producte:** registra-ho com a `Ask First` i no inventis la decisió.
- **La feature és en realitat dues:** proposa partir en dues specs; no l'inflis.
- **Bug sense causa clara:** documenta les hipòtesis amb evidència; no n'escullis una sense traça a codi.
- **Següent pas:** quan la spec estigui `ready-for-dev`, proposa `freedolia-dev`. No implementis tu des d'aquí.
