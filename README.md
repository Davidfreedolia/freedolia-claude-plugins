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

### Opció A — skills d'àmbit usuari (funciona a l'extensió VSCode) ✅ recomanada aquí

El comandament `/plugin` NO existeix a l'extensió de VSCode. La via fiable és copiar les skills a
`~/.claude/skills/` (igual que està instal·lat gstack). Es llisten globalment a tot projecte.

```bash
# instal·lar / re-sincronitzar després d'editar el repo
SRC="$HOME/../../c/Projects/freedolia-claude-plugins/plugins/freedolia-kit/skills"   # ajusta la ruta
for s in freedolia-trucada freedolia-estudi freedolia-prd freedolia-spec freedolia-dev freedolia-mvp; do
  rm -rf "$HOME/.claude/skills/$s" && cp -r "$SRC/$s" "$HOME/.claude/skills/$s"
done
```

> Com que és una còpia, cada cop que editis una skill al repo cal tornar a executar el bloc per
> sincronitzar. (Alternativa sense drift: una *junction* de Windows per carpeta.)

### Opció B — plugin de veritat (només a la CLI `claude` d'un terminal)

En un terminal normal (no l'extensió), el comandament `/plugin` sí funciona:

```text
/plugin marketplace add C:\Projects\freedolia-claude-plugins
/plugin install freedolia-kit@freedolia
```

Després de pujar aquest repo a GitHub pots canviar la font del marketplace a
`github:Davidfreedolia/freedolia-claude-plugins` perquè sigui igual a totes les màquines.

## Convencions del kit

- **Català per defecte** (i18n ES/EN/FR quan calgui). Comentaris en català permesos.
- **Cost com a restricció dura**: cap skill proposa res que augmenti el cost d'IA/Places. Menys crides, mai pujar topalls.
- **Artefactes** a `_bmad-output/planning-artifacts/` (PRDs) i `_bmad-output/implementation-artifacts/` (specs), igual que ja fa freedolia-hub.
- **Gate abans de commit**: `npm run typecheck` (mai `npm run build` dins del workspace IA).
- **Git**: feina a `development`, mai push directe a `main`. Missatges `M-NN: descripció`.

> `freedolia-design` (sistema de disseny) NO viu aquí: enllaça a `src/` de freedolia-hub, així que es
> queda al `.claude/skills/` d'aquell repo.
