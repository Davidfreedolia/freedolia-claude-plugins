---
name: freedolia-automatismes
description: >
  Instal·la (o repassa) els automatismes de Freedolia en un projecte: avisos que
  salten sols perquè les normes de la casa no depenguin de si algú se'n recorda.
  Ara mateix: recordar el repàs de FAQ/xatbot/manual/SEO quan s'ha tocat la cara
  visible del web, i recordar que les migracions s'apliquen A MÀ quan se n'escriu
  una. Activa-la quan l'usuari digui "activa els automatismes", "posa els hooks",
  "que això sigui automàtic", "instal·la-ho a tots els projectes", o en obrir un
  projecte nostre que encara no els tingui. Cost zero i no toca cap codi del
  producte: només escriu a `.claude/`.
---

# Freedolia — automatismes del projecte

## Per què

Les normes de la casa es perden. No per mala fe: es canvia el producte i el text
que l'explica es queda enrere, perquè viu en un altre fitxer i ningú no hi pensa.

El 06/08/2026, a cursosdecatala.cat, vam trobar que **ni la FAQ ni el xatbot
deien res dels enviaments** —just el dia que n'havíem canviat el preu i els
països— i que el manual de l'administració no coneixia mitja pantalla nova. La
resposta del David va ser la bona: *«això tindria que ser automàtic cada cop que
fem canvis en una sessió»*.

Un automatisme aquí no és un robot que arregla res. És **un avís que salta sol al
moment just**, i que calla quan no toca.

## Què s'instal·la

| Automatisme | Quan salta | Què diu |
|---|---|---|
| **repàs de continguts** | en acabar una resposta, si s'ha tocat la cara visible | mira si cal actualitzar FAQ, xatbot, manual i SEO, en els tres idiomes |
| **migracions a mà** | en escriure un fitxer a `supabase/migrations/` | s'apliquen per l'SQL Editor, MAI amb `db push` |

Tots dos:

- **callen** si no hi ha motiu (provat en un projecte net),
- **no bloquegen mai res**: només diuen,
- i el del repàs **avisa un sol cop cada 3 hores**, per no ser pesat.

Es poden ajustar amb variables d'entorn: `FREEDOLIA_HOOK_MINUTS` (per defecte
180) i `FREEDOLIA_HOOK_FINESTRA` (per defecte `8 hours ago`).

## Com fer-ho

### 1 · Mira què hi ha

Llegeix `.claude/settings.json` de l'arrel del projecte (**l'arrel de la sessió
de Claude**, no la del repo si estan en carpetes diferents).

- Si no existeix, el crearàs.
- Si existeix, **fusiona**: no substitueixis mai `hooks` sencer ni cap altra
  clau. Si ja hi ha un hook `Stop` o un `PostToolUse` sobre `Write|Edit`,
  ensenya'l i pregunta si es manté, es canvia o conviuen.

### 2 · Copia els guions

De `references/` d'aquest kit a `<arrel>/.claude/hooks/`:

```
hook-repas-continguts.sh   →  .claude/hooks/repas-continguts.sh
hook-migracions-a-ma.sh    →  .claude/hooks/migracions-a-ma.sh
```

Fes-los executables (`chmod +x`).

### 3 · Escriu la configuració

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/repas-continguts.sh\"",
            "timeout": 15,
            "statusMessage": "Mirant si cal repassar continguts…"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/migracions-a-ma.sh\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### 4 · Prova-ho abans de dir que està fet

**No et fiïs que el guió és correcte perquè l'has copiat.** A la primera
instal·lació ja va fallar: el projecte tenia dos repos de git (una còpia vella a
l'arrel i el bo a dins) i el guió mirava el que no tocava, o sigui que callava
havent-hi feina. Ara els mira tots, però prova-ho igualment:

```bash
# Ha de dir alguna cosa si s'ha treballat, i callar si no.
echo '{}' | bash .claude/hooks/repas-continguts.sh

# Ha d'avisar amb una migració...
echo '{"tool_name":"Write","tool_input":{"file_path":"x/supabase/migrations/0001_x.sql"}}' \
  | bash .claude/hooks/migracions-a-ma.sh

# ...i callar amb qualsevol altra cosa.
echo '{"tool_name":"Write","tool_input":{"file_path":"src/routes/x.tsx"}}' \
  | bash .claude/hooks/migracions-a-ma.sh
```

I comprova que el que surt és **JSON vàlid** (`python -c "import sys,json;
json.load(sys.stdin)"`). Un hook que escup text mal format no es veu: falla en
silenci.

Comprova també que el `settings.json` ha quedat ben format. **Un `settings.json`
trencat desactiva TOTES les opcions d'aquell fitxer**, no només el hook.

### 5 · Digues-ho clar

Explica què s'ha instal·lat i **què no cal fer**: normalment el programa agafa la
configuració sol. Si la carpeta `.claude/` no existia quan es va obrir la sessió,
pot caldre obrir `/hooks` un cop —o reiniciar— perquè es rellegeixi. Diguem-ho
com una possibilitat, no com un deure: la primera vegada vam dir al David que
havia d'obrir `/hooks` i el hook ja funcionava sol.

## Límits

- Això **no substitueix el repàs**: recorda fer-lo, no el fa.
- No mira el CONTINGUT dels fitxers, només quins s'han tocat. Pot avisar quan no
  calia. És a posta: val més que avisi de més que de menys.
- Si un projecte no té cap de les carpetes de la cara visible
  (`src/routes`, `src/content`, `app/`…), el hook no s'engega mai. No passa res.

## Afegir-ne un de nou

Un automatisme entra aquí quan es compleixen les tres coses:

1. És una **norma de la casa** que ja hem incomplert almenys un cop.
2. Es pot detectar **sense llegir el contingut** dels fitxers.
3. **Avisar és suficient**: si calgués bloquejar, és que la norma hauria de ser
   codi, no un avís.
