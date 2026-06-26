---
name: freedolia-mvp
description: >
  Orquestrador del pipeline de producte Freedolia: condueix una idea (o una trucada
  de client) de punta a punta fins a un MVP, encadenant freedolia-trucada → estudi →
  prd → spec → dev amb checkpoints humans entre fases. Activa-la quan l'usuari digui
  "vull fer un MVP", "porta'm de la idea al codi", "munta aquest producte", o quan
  vulgui el camí complet en comptes d'una sola baula. No salta passos ni decideix de
  negoci sol: a cada frontera atura's i confirma amb el David.
---

# Freedolia — MVP (orquestrador)

**Objectiu:** portar una idea o una trucada de client fins a un MVP funcionant, **encadenant les skills
del kit** amb disciplina i checkpoints. Aquesta skill **no reimplementa** res: decideix quina baula toca,
hi delega, i gestiona les fronteres. El cervell de cada fase és la skill especialitzada.

## 0. Principis

- **Una baula a la vega, amb checkpoint humà entre fases.** Mai encadenis dues fases sense que el David validi la sortida de la primera. Ell és el decisor (CLAUDE.md).
- **No inventis decisions de negoci.** Si una fase necessita una decisió que no és teva, atura't i pregunta o registra-la com a assumpció (segons la skill de la fase).
- **Cost com a restricció dura** travessa tot el pipeline. Si en qualsevol fase apareix una idea amb cost (IA/Places), marca-la i no la donis per bona sense topall i ok explícit. [[cost-es-la-restriccio-dura]]
- **Entra on calgui.** Si el David ja té PRD, salta a spec. Si ja té spec, salta a dev. No facis fases que ja estan fetes — comprova `_bmad-output/` abans.

## 1. El pipeline

```
            ┌─ (si l'origen és una trucada) ─┐
 IDEA / TRUCADA                              ▼
            └──────────────────────►  FASE 0 · freedolia-trucada   (buida la trucada → punts clau)
                                              │  checkpoint
                                              ▼
                                       FASE 1 · freedolia-estudi    (entén el terreny → mapa + oportunitats)
                                              │  checkpoint
                                              ▼
                                       FASE 2 · freedolia-prd       (aterra → prd.md, features F1..Fn)
                                              │  checkpoint (PRD final)
                                              ▼
                                       FASE 3 · freedolia-spec ×N   (cada feature del MVP → spec ready-for-dev)
                                              │  checkpoint (per spec)
                                              ▼
                                       FASE 4 · freedolia-dev ×N    (implementa → development, typecheck, PR)
                                              │
                                              ▼
                                          MVP en preview  →  el David fa el merge a main
```

## 2. Com conduir cada frontera

- **Origen → Fase 0/1.** Si el material és una trucada/notes → `freedolia-trucada` primer. Si és una idea ja escrita → directe a `freedolia-estudi` (per ancorar-la al projecte real). Si és un projecte nou de client sense codi → estudi lleuger del material i salta a PRD.
- **Fase 1 → 2.** L'estudi dóna context i oportunitats. Confirma amb el David QUINA oportunitat es converteix en producte abans d'obrir `freedolia-prd`.
- **Fase 2 → 3.** Del PRD, el David tria quines features entren al **MVP** (§6 del PRD: Dins). Per a cada una, una spec amb `freedolia-spec`. No speceïs features fora del MVP.
- **Fase 3 → 4.** Només especs `ready-for-dev` passen a `freedolia-dev`. Implementa-les en ordre de dependència, una branca/PR coherent (o per feature, segons mida).
- **Fase 4 → MVP.** Tot a `development`, typecheck net, preview de Vercel. **El merge a `main` el fa el David.**

## 3. Estat i traçabilitat

- Mantingues un fil clar: a cada checkpoint, digues on som al pipeline i què ve després.
- Els artefactes viuen on ja és costum: PRDs a `_bmad-output/planning-artifacts/prd-{slug}/`, specs a `_bmad-output/implementation-artifacts/spec-*.md`. Les specs enllacen el seu PRD via `context:`.
- Si el David para a mig pipeline, ha de poder reprendre: cada skill desa el seu artefacte i el seu estat (frontmatter `status`), així que reprendre = obrir la skill de la fase on s'havia quedat.

## 4. Què NO fa aquesta skill

- No escriu PRDs, specs ni codi directament — **delega** a la skill de la fase. Si et veus redactant una spec aquí, atura't i obre `freedolia-spec`.
- No fa merge a `main`, no desplega edge functions, no executa migracions sense el David (vegeu límits a `freedolia-dev`).
- No accelera saltant-se checkpoints. Un MVP ràpid amb decisions de negoci inventades és pitjor que un de ben aterrat.

## 5. Arrencada

1. Mira què hi ha ja a `_bmad-output/` i pregunta al David: **d'on partim** (idea / trucada / PRD existent / spec existent) i **on volem arribar avui** (tot el MVP o només fins a PRD).
2. Situa'l al pipeline (§1) i digues la primera baula que obriràs.
3. Delega a la skill de la fase. Torna aquí a cada frontera per al checkpoint i la següent decisió.
