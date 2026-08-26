---
name: freedolia-correccions
description: >
  Converteix una tanda de correccions d'un client —captures de WhatsApp, notes de
  veu buidades, un correu amb vint retocs— en una LLISTA VERIFICABLE que el David
  valida abans que es toqui res, i només després l'implementa i la desplega.
  Activa-la quan arribin correccions de la clienta ("aplica correccions", "la Sara
  ens ha passat aquests canvis", "arregla això" amb captures), especialment si en
  són més de dues o si venen en imatges. Evita el pitjor error d'aquesta feina:
  entendre malament una correcció i escampar-la per tot el web.
---

# Freedolia — Correccions de client

**Objectiu:** que cap correcció s'implementi abans que estigui **entesa i validada**, i que un cop
validada s'apliqui **a tot arreu on toca**, no només allà on la clienta ho va veure.

## 0. Regles d'or

- **Català**, directe.
- **Primer llistar, després tocar.** El lliurable del primer torn és una llista, no un commit.
  Encara que la correcció sembli òbvia.
- **La clienta veu una pàgina; el text viu a deu llocs.** Tota correcció validada s'aplica al web
  (CA/ES/EN), i també a `seo.ts`, `llms.txt`, el xatbot, la FAQ, els correus i el manual de l'admin
  si el text hi surt. Un `grep` de la forma antiga abans de commitar.
- **Grounded, mai endevinat.** Cada línia de la llista porta fitxer i línia reals, localitzats amb
  `grep`. Si no has trobat el text, la fila diu "NO TROBAT" i pregunta on és; no te l'inventis.
- **El que no s'entén, es pregunta.** Una captura retallada no és una instrucció completa.
- **Ella mana en la llengua.** Si demana una forma que no és la normativa, s'aplica igualment i es
  diu en una línia. És filòloga i és casa seva.

## 1. Procés

### Pas 1 — Buidar

Recorre les captures/el text i extreu **una fila per correcció**, sense fusionar-ne dues ni partir-ne
una. Numera-les: els números són el que farà servir el David per validar ("l'1, el 3 i el 5 sí; el 4 no").

### Pas 2 — Localitzar

Per a cada fila, `grep` al codi fins a trobar **on viu aquell text**. Compta **quantes vegades** hi
surt i en quants idiomes. Aquest recompte sovint és la informació més valuosa de tota la llista:
«la Sara ho ha vist a un lloc, però hi és a set».

### Pas 3 — La taula de validació

Presenta-la així, i **atura't**:

| # | Ella diu | Ho entenc com | On és | Idiomes | Dubte |
|---|---|---|---|---|---|
| 1 | «incloure interrogant» | `Com funciona` → `Com funciona?` | dictionaries.ts:562, 724 | CA/ES/EN | — |

- **Ella diu**: literal, tal com ho ha escrit. No el parafrasegis.
- **Ho entenc com**: el canvi concret, amb l'abans i el després.
- **Dubte**: si n'hi ha, la pregunta exacta. Si la correcció xoca amb una decisió tècnica presa
  (SEO, una norma del projecte), digue-ho aquí amb el cost de cada opció.

Marca amb ⚠️ les que no es poden aplicar sense resposta, i separa a part el que **no és una
correcció de text**: bugs, peticions de contingut nou, decisions de negoci.

### Pas 4 — Implementar (només després del vistiplau)

Les validades, totes de cop:

1. Aplica-les als tres idiomes i a totes les superfícies.
2. `grep` de la forma antiga: ha de tornar buit.
3. Gate: `npx tsc --noEmit` + `npm run build`. Si toques edge functions, `deno check`.
4. Si el canvi es veu, prova'l **servint la pàgina** i mirant-ne el HTML, no el codi font.
5. Commit i push segons la norma del projecte.
6. Si el text viu en una edge function, **desplega-la**: `main` no és producció. [[desplegar-edge-functions]]

### Pas 5 — Tornar-ho a explicar

Un resum curt per al David amb: què s'ha aplicat, **on més s'ha propagat** que ella no havia vist,
què queda pendent de resposta i què li ha de dir ell a la clienta.

## 2. Estàndard de qualitat

La tanda està ben feta quan:

- Cada correcció validada té el seu `grep` en buit.
- Cap correcció s'ha aplicat "a mitges" (un idioma sí i dos no; el web sí i el xatbot no).
- Les dubtoses segueixen obertes i preguntades, no resoltes per intuïció.
- El que no era text (bugs, contingut nou) no s'ha colat com si ho fos.

## 3. Trampes conegudes

- **La paraula que és clau de cerca.** Si demana treure una paraula que és a un `<title>` per SEO
  («online»), no la treguis en silenci: pregunta, amb el cost.
- **El text que també és a un correu.** Els correus viuen a edge functions i no surten amb el
  desplegament del web.
- **La captura que ja està arreglada.** De vegades la clienta mira una pàgina antiga o una versió
  desplegada endarrerida. Comprova la data del text al codi abans de "corregir" el que ja és correcte.
- **La forma que surt a set llocs.** Mai suposis que només hi és on ella ho ha vist.
