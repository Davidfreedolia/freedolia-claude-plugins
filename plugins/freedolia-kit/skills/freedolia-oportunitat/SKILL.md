---
name: freedolia-oportunitat
description: >
  Obre un vertical nou: analitza un sector amb els paràmetres mínims (dolors,
  competència per capes, saturació), troba el forat, en treu el wedge i el nom de
  treball, i acaba amb el prompt per a Lovable que genera l'MVP visual. Activa-la
  quan l'usuari digui "obrim un vertical nou", "analitza aquest sector", "on hi ha
  forat", "munta el prompt de Lovable", o quan porti un sector sense producte
  encara. El pas ABANS de tot: no hi ha repo, ni codi, ni PRD. Sortida: documents
  d'anàlisi + prompt per enganxar. Cost zero (recerca web + escriptura).
---

# Freedolia — obrir un vertical

> **Objectiu:** decidir si un sector val la pena, on exactament ens hi fiquem, i sortir-ne
> amb el prompt que genera l'MVP. **No s'escriu codi ni PRD.** El lliurable és una decisió
> defensable amb números i un prompt per enganxar a Lovable.
>
> Aquest mètode ja s'ha aplicat a **Hotel** (freehospitality), **Clínica** (Clinicull) i
> **Supply Chain** (StockPilot). Segueix-lo: la seva força és que és el mateix cada cop,
> i això fa comparables els verticals entre ells.

## 0. La tesi (no la negociïs sense el David)

Freedolia **no construeix la capa madura**. No fem un ERP, ni un WMS, ni un PMS, ni un
software clínic. Sempre entrem al mateix lloc:

> **la costura entre sistemes + un agent IA que actua.**

Cada sector té les seves capes amb amos. El que està desatès per a la PIME és sempre el
mateix: **unir el que ja té** i **posar-hi previsió/acció automàtica**. Si l'anàlisi et
porta a construir la capa madura, l'anàlisi està malament o el sector no és per a nosaltres.

Guardrail de producte que travessa tots els verticals: **la IA proposa, l'humà aprova.**

## 0.bis D'on surten els verticals

**De la carta de la Isabel**, no d'un brainstorming. És l'anàlisi dels reptes que directius
d'empreses catalanes li van compartir als programes de Generación Digital PYMEs, i d'allà
surten els cinc verticals i, sobretot, **els contactes**. Llegeix-la abans de res:
`freedolia-hub/docs/carta-isabel-verticals.md`.

La troballa que fa que el mateix motor serveixi sectors molt diferents: dels 10 reptes que
ella va homogeneïtzar, **sis són horitzontals** — integració entre sistemes, informació
dispersa, dades en temps real, gestió documental, dashboards i IA aplicada. Aquests sis
**són el producte de Freedolia**. Dels altres quatre, processos manuals i automatització
comercial són casos d'ús concrets, i gestió del canvi i formació són servei, no producte.

Per això no cal reinventar la tesi a cada sector: el que canvia és el vocabulari i els
sistemes que hi ha a cada capa, no el forat.

Quan la carta s'esgoti (o per a un sector que no hi surti), cal una font equivalent: algú
amb accés real a directius del sector. **Sense contactes no s'obre vertical.**

## 1. Els paràmetres mínims

Per valorar un sector només calen cinc coses. Si en falta alguna, ves a buscar-la abans de
concloure res:

1. **Beachhead** — un client real que ja coneixem i que ja té el dolor. Surt de la llista
   de contactes, no d'un mercat teòric. Sense beachhead, el vertical és especulació.
2. **Dolors documentats** — 4-6, cadascun amb font. Premsa del sector, informes, no intuïció.
3. **Mapa de capes amb saturació** — qui mana a cada capa i com de ple està (§2).
4. **Números de ROI del sector** — els que un director d'operacions/gerent entén. Amb font.
5. **On NO anar** — els límits explícits, perquè és on es perden els diners.

## 2. L'eina d'anàlisi: la taula de capes

És el cor del mètode. Descompon el software del sector en capes, i marca la saturació:

| Capa | Què fa | Players | Saturació |
|---|---|---|---|
| Nucli de gestió | … | SAP, Sage, Odoo… | 🔴 Saturat |
| Gestió especialitzada enterprise | … | … (500K-2M$) | 🔴 Car, enterprise |
| Gestió especialitzada PIME | … | … | 🟠 Actiu |
| Previsió / optimització amb IA | … | Poques eines, enterprise | 🟢 forat |
| Integració / visibilitat en temps real | … | Gairebé ningú assequible per a PIME | 🟢 forat |

**El patró es repeteix a tots els sectors:** les capes de gestió estan servides; la
integració i la IA de previsió, no. Els 🟢 són el producte. Si no surt cap 🟢, no hi entrem.

## 3. L'informe sectorial (format literal)

Fitxer: `analisi_sectorial_<sector>.md`. En català, amb fonts al final.

```
# Anàlisi sectorial — MVP "<Nom>" (<Sector>)
{una línia: quin vertical és i d'on surt}

## 1. Per què aquest vertical i d'on surt el beachhead
## 2. Els dolors del sector <X> PIME          ← 4-6, amb font
## 3. La competència: el software del sector, per capes   ← la taula de §2
## 4. On ens fiquem (mateix patró)            ← connecta / unifica / actua
## 5. Els números per al pitch                ← tots del sector, amb font
## 6. El wedge de l'MVP                       ← una frase + nom de treball + pilot ideal
## 7. On NO anar
## 8. Següent pas
## Fonts
```

Complementari opcional: `competencia_execucio_<nom>.md`, quan cal mirar de prop com
executen els competidors directes abans de comprometre's.

**El wedge (§6) és el més important.** Ha de cabre en una frase que un comprador entengui:
*"Visibilidad de stock en tiempo real + agente de previsión, por encima del ERP/WMS que ya
tienes."* Si necessites un paràgraf, encara no tens wedge.

**El nom de treball** segueix el patró existent: TallerMaestro, ClinicUll, StockPilot.
Descriptiu, pronunciable en castellà, i que digui què fa.

## 4. El prompt per a Lovable

Un cop validat el wedge amb el David, es redacta el prompt. Fitxer:
`prompt_lovable_<nom>.md`, amb **el bloc per enganxar en anglès** i unes *notes per a tu*
al final que no s'enganxen.

L'esquelet està fixat per les tres execucions anteriors. Blocs, en aquest ordre:

1. **Obertura** — `Build a polished, MOBILE-FIRST … called "<Nom>" (by Freedolia)`: què és,
   per a qui, i que és front amb **mock data**.
2. **POSITIONING** — tot-en-un per defecte i **obert** a integrar el que ja tinguin.
3. **BUSINESS GUARDRAIL** — *the AI agent PROPOSES; a human APPROVES*, amb els botons
   `Aprobar / Editar / Escalar` a cada acció proposada.
4. **EXPORT & BACKEND — IMPORTANT (read first)** — el bloc que decideix si l'MVP serà
   aterrable o no:
   - export al **nostre** repo de GitHub, codi portable, sense lock-in
   - **que Lovable NO provisioni cap backend seu**
   - **una sola capa de dades** `src/services/` amb els getters enumerats un a un;
     *screens NEVER read mock arrays directly*
   - **model tipat** (`src/types/models.ts`) que mapeja al futur schema
   - **env vars** `VITE_SUPABASE_URL` / `VITE_SUPABASE_ANON_KEY` amb **fallback a mock**
5. **MULTILINGUAL** — 5 idiomes (es per defecte, en·fr·de·ca), `t(key)`, cap string hardcoded.
6. **MOBILE-FIRST & TABLET** — sidebar → bottom tabs, taules → targetes, touch ≥44px.
7. **TECH** — React + Vite + Tailwind, lucide-react, Inter. Mapes amb react-leaflet si en cal.
8. **VISUAL STYLE** — paleta i personalitat **deliberadament diferents dels altres verticals**,
   amb els hex escrits. És el que manté els productes distingibles.
9. **NAVIGATION + les N rutes** — cada ruta amb el seu contingut concret i les dades d'exemple.
10. **Populate with realistic mock data** — noms, SKUs, ciutats, imports reals del país.

⚠️ **El punt 4 és el que et salvarà després.** Els tres MVPs que han estat fàcils d'aterrar
són els que el portaven. I encara així: el prompt demana un model tipat "1:1 amb el futur
schema", però **això no garanteix res** — a StockPilot l'SQL que va acompanyar l'MVP deia
que mapejava 1:1 i li faltaven taules senceres. Verifica-ho sempre a `freedolia-aterratge`.

Opcional però útil: `estructura_mvp_<nom>.html`, un diagrama de l'estructura de rutes i
entitats per validar l'abast amb el David abans de generar res.

## 5. On viuen els artefactes

Tot a Google Drive mentre el producte no té repo. **Quan l'MVP aterri, copia'ls al repo**
(`docs/`) — si no, l'agent que hi treballi després no els podrà llegir mai, perquè el Drive
demana login. Va passar amb StockPilot.

## 6. Casos límit

- **El sector no dona cap 🟢**: digues-ho clar i no forcis un producte. Millor descartar-lo aviat.
- **Sense beachhead**: es pot fer l'anàlisi, però marca-ho com a risc principal a §1. No es
  passa a Lovable sense un client amb qui construir-ho.
- **Números sense font**: no els inventis ni els arrodoneixis a l'alça. El deck comercial els
  reutilitza literalment i han d'aguantar que un client els busqui.

## 7. Següent pas

- El David valida el wedge → **enganxa el prompt a Lovable** i itera l'MVP visual.
- En paral·lel → `freedolia-comercial` (logo, deck de 9 pàgines, guió de 3 min).
- Amb l'MVP generat → `freedolia-aterratge` per baixar-lo al nostre terreny.
