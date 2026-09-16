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
| `freedolia-web` | Buida el web d'un client (qui són, equip, serveis, necessitats) | URL(s) → brief estructurat |
| `freedolia-estudi` | Estudi complet del projecte (codi + docs + negoci) | Repo → mapa + oportunitats |
| `freedolia-prd` | Aterra una idea en un PRD buildable | Idea/notes/trucada → `prd.md` |
| `freedolia-spec` | Converteix una feature o bug en spec implementable | Feature del PRD → `spec-*.md` |
| `freedolia-dev` | Implementa una spec amb revisió adversarial | `spec-*.md` → codi + PR |
| `freedolia-mvp` | Orquestra tot el camí fins a un MVP | Idea/trucada → MVP |
| `freedolia-oportunitat` | Sector → forat de mercat → prompt de Lovable | Sector → prompt + tesi |
| `freedolia-aterratge` | Baixa un MVP de Lovable al nostre terreny (Supabase, RLS, auth) | MVP de Lovable → repo propi |
| `freedolia-comercial` | Logo + deck de 9 + guió de 3 min | Tesi → material de venda |
| `freedolia-correccions` | Tanda de correccions de client → llista verificada → implementació | Llista del client → codi |
| `freedolia-noticia` | El que passa de debò al client → notícia verificada i trilingüe | Fets → article publicable |
| `freedolia-automatismes` | Instal·la els avisos que salten sols | Normes de la casa → hooks |

### Transversals (no són una baula del pipeline)

Van a qualsevol projecte i en qualsevol moment.

| Skill | Què fa | Per què existeix |
|---|---|---|
| `freedolia-claus` | Genera i retira tokens i secrets **sense que el text en clar entri en cap conversa**: es genera a la màquina, l'enllaç va a un fitxer, a la base només hi arriba el hash | Hem hagut de rotar un token dues vegades perquè el valor va acabar en una sortida d'eina |
| `freedolia-tauler` | El tauler viu del projecte: **una sola pàgina publicada**, bilingüe, amb diagrames de caixes i caselles que es desen a la base | Cinc pàgines temàtiques volen dir que ningú sap quina està al dia, i un equip no tècnic no llegeix un `ROADMAP.md` |

### El pipeline

```text
trucada ─┐
web ─────┤
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

### Actualitzar: **dues** ordres, no una

Aquí hi ha un parany que ens ha costat dos mesos de skills invisibles. `marketplace update` refresca
el **catàleg**; el que Claude carrega de veritat és la **còpia instal·lada**, i aquesta es queda a la
versió que hi hagués fins que li ho dius:

```bash
claude plugin marketplace update freedolia   # refresca el catàleg
claude plugin update freedolia-kit@freedolia # actualitza el que es carrega
claude plugin list                            # comprova la versió
```

**El 16/09/2026 el catàleg anava per 0.7.0 i la còpia instal·lada era la 0.3.1 del 22 de juliol**, o
sigui que `freedolia-correccions`, `freedolia-noticia` i `freedolia-automatismes` **no s'havien pogut
invocar mai**. Si una skill no respon, el primer que es mira és `claude plugin list`. I cal
**recarregar la finestra** perquè el canvi s'apliqui.

### On viu, i com es té a més d'un ordinador

- **Font de veritat:** aquest repo, a `github:Davidfreedolia/freedolia-claude-plugins` (**privat**).
- **A la màquina del David** el marketplace apunta al **directori local**
  (`C:\Projects\freedolia-claude-plugins`), a posta: així una edició d'una skill té efecte de
  seguida, sense passar per GitHub.
- **En un ordinador nou, o per a qualsevol altra persona de l'equip**, s'afegeix des de GitHub:

```bash
claude plugin marketplace add Davidfreedolia/freedolia-claude-plugins
claude plugin install freedolia-kit@freedolia
```

- Cal ser **col·laborador del repo** (és privat): sense això, `marketplace add` dona 404.
- **Regla:** una skill no és compartida fins que el commit és a GitHub. Editar-la al directori local
  la fa servir **només aquí**.

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
- **Secrets**: el text en clar **no surt d'on s'ha generat** (`freedolia-claus`). A la base només el hash; retirar és **caducar**, no esborrar; i un secret perdut **es regenera**, no es busca.
- **Un tauler per projecte** (`freedolia-tauler`), **sempre al mateix URL**, i escrit perquè l'entengui l'Imma al mòbil. Els identificadors de les caselles **no canvien mai**: canviar-ne un esborra una casella marcada.
- **Es comprova rellegint** (G3), i també després de publicar: el missatge del publicador no és la comprovació.

> `freedolia-design` (sistema de disseny) NO viu aquí: enllaça a `src/` de freedolia-hub, així que es
> queda al `.claude/skills/` d'aquell repo.
