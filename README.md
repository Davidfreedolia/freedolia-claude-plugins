# freedolia-claude-plugins

Marketplace de plugins interns de **Freedolia** per a Claude Code.

## Plugins

### `freedolia-kit`

Pipeline de producte complet, del primer contacte amb el client fins al codi en producció. Català per
defecte, pensat per al stack de freedolia-hub (TanStack Start + Supabase + Vercel) i amb el **cost com a
restricció dura** baixat a totes les skills. Autònom: cap dependència de BMAD ni de cap resolver extern.

| Skill | Què fa | Entrada → Sortida |
|---|---|---|
| `freedolia-trucada` | Buida una trucada/reunió de client i en treu els punts clau | Text transcrit → resum estructurat |
| `freedolia-estudi` | Estudi complet del projecte (codi + docs + negoci) | Repo → mapa + oportunitats |
| `freedolia-prd` | Aterra una idea en un PRD buildable | Idea/notes/trucada → `prd.md` |
| `freedolia-spec` | Converteix una feature o bug en spec implementable | Feature del PRD → `spec-*.md` |
| `freedolia-dev` | Implementa una spec amb revisió adversarial | `spec-*.md` → codi + PR |
| `freedolia-mvp` | Orquestra tot el camí fins a un MVP | Idea/trucada → MVP |

### El pipeline

```text
trucada ─┐
         ├─→ estudi ─→ prd ─→ spec (×N features) ─→ dev ─→ PR
idea ────┘
                    └──────────  freedolia-mvp ho encadena tot  ──────────┘
```

Cada baula és una skill independent: pots entrar al pipeline on vulguis (només una spec, només un PRD)
o deixar que `freedolia-mvp` t'ho condueixi de punta a punta.

## Instal·lació

> ⚠️ El comandament de **xat** `/plugin` NO existeix a l'extensió de VSCode. Però el **CLI `claude plugin`**
> sí funciona des de qualsevol terminal (i del Bash de l'agent). Aquesta és la via bona: instal·la el
> plugin de veritat i **surt al panell de plugins**.

```bash
# 1. (opcional) validar el manifest
claude plugin validate "C:\Projects\freedolia-claude-plugins"

# 2. registrar el marketplace local (scope user = global a tot projecte)
claude plugin marketplace add "C:\Projects\freedolia-claude-plugins"

# 3. instal·lar el plugin
claude plugin install freedolia-kit@freedolia

# verificar
claude plugin list
claude plugin details freedolia-kit@freedolia
```

Cal **recarregar la finestra** de l'extensió perquè el plugin aparegui al panell. Les skills queden
namespaced: `freedolia-kit:freedolia-trucada`, `freedolia-kit:freedolia-prd`, etc.

**Actualitzar** després d'editar les skills del repo: `claude plugin marketplace update freedolia`
(la font és aquest directori; no cal re-copiar res).

> Quan pugis el repo a GitHub pots canviar la font a `github:Davidfreedolia/freedolia-claude-plugins`
> (`claude plugin marketplace remove freedolia` i tornar-lo a afegir amb el repo) per tenir-ho igual a
> totes les màquines.

### Alternativa: skills-directory plugin (sense marketplace)

També es pot deixar tot el `plugins/freedolia-kit/` dins `~/.claude/skills/freedolia-kit/` (amb el seu
`.claude-plugin/plugin.json`): es carrega sol com a `freedolia-kit@skills-dir` i també surt al panell.
Útil si no vols mantenir un marketplace. `claude plugin init <nom>` scaffoldeja aquest format.

## Convencions del kit

- **Català per defecte** (i18n ES/EN/FR quan calgui). Comentaris en català permesos.
- **Cost com a restricció dura**: cap skill proposa res que augmenti el cost d'IA/Places. Menys crides, mai pujar topalls.
- **Artefactes** a `_bmad-output/planning-artifacts/` (PRDs) i `_bmad-output/implementation-artifacts/` (specs), igual que ja fa freedolia-hub.
- **Gate abans de commit**: `npm run typecheck` (mai `npm run build` dins del workspace IA).
- **Git**: feina a `development`, mai push directe a `main`. Missatges `M-NN: descripció`.

> `freedolia-design` (sistema de disseny) NO viu aquí: enllaça a `src/` de freedolia-hub, així que es
> queda al `.claude/skills/` d'aquell repo.
