---
name: freedolia-tauler
description: >
  Fa i mante el tauler viu d'un projecte: UNA pagina publicada, bilingue, amb
  diagrames i caselles que es desen a la base, escrita perque l'entengui un equip
  que no es tecnic. Activa-la quan l'usuari digui "fes un tauler", "un artefacte
  amb tot", "on som", "explica-ho a l'equip", "afegeix diagrames", "menys tecnic",
  o quan calgui actualitzar el tauler d'un projecte que ja en te.
---

# Freedolia — Tauler

**Objectiu:** que cada projecte tingui **una sola pàgina** que serveixi per a tot —ensenyar-lo a
l'equip, decidir, i marcar què s'ha fet— i que **no calgui ser tècnic per entendre-la**. El model és
el de Freehospitality; aquesta skill és el patró perquè el següent projecte hi arribi directe.

## 0. Un sol artefacte, i sempre el mateix URL

- **Un per projecte.** Cinc pàgines temàtiques publicades és el que teníem abans, i el resultat és
  que ningú sap quina està al dia. Les velles **queden com a històric i es diu que no es mantenen**.
- **Es republica al mateix URL.** Mai un artefacte nou per a una versió nova: l'enllaç que l'equip
  té guardat ha de seguir valent. En una sessió nova, es passa l'URL com a `url` (i es llegeix
  abans de publicar).
- **La icona no canvia mai.** L'equip reconeix l'artefacte per l'emoji.

## 1. Les pestanyes, en aquest ordre

L'ordre és una decisió: **primer el que entén tothom**, després el detall.

1. **On som** — la frase del producte, sis fets amb número, què ja funciona, **què es reprèn per
   aquí** (llista numerada de feines obertes, amb els ⚠️ a la vista) i les dates de reclamació.
2. **Com funciona** — els diagrames (§4). És la pestanya que es passa a algú de fora de l'equip
   tècnic, i la que ha de fer que no calgui explicar res de paraula.
3. **Tauler** — la llista detallada, fita per fita, amb les caselles. **És la més tècnica a posta**,
   i la capçalera ho diu i remet a «Com funciona».
4. **Decisions** — les obertes, les que tenen data primer, i **plantejades com a pregunta** amb la
   recomanació a sobre de la taula. Cadascuna diu **qui l'ha de prendre i quan**.
5. **El terreny** — els límits del domini (què es pot fer i què no, i per què), la taula de
   proveïdors **amb l'estat i no el desig**, i el que no es promet mai.
6. **Regles** — les dues o tres garanties del sistema, el que no es negocia, i **com sabrem que va
   mal** (cada línia, un error que ha passat de debò).

Si un projecte no té §5, es treu la pestanya. No s'omple per simetria.

## 2. Les caselles: l'estat viu a la base, i els identificadors no canvien mai

- Es fa amb la capacitat de base de dades de l'artefacte (`claude.use("db")`), col·lecció `tasks`,
  un document per casella amb `{done, by, at}`.
- **Cada casella té un `id` curt i estable** (`m3-5`, `f-6`, `is-1`). **Canviar un `id` esborra una
  casella marcada.** Quan es reescriu el text d'una tasca, **l'`id` es manté**.
- **Dos `id` iguals fan dues coses dolentes**: el percentatge compta la tasca dues vegades i només
  una de les dues caselles es pot marcar. Cal l'avís al codi (`console.warn` i ignorar el repetit) —
  ens ha passat.
- **Reemplaça l'estat sencer a cada actualització**: una tasca sense fila és una tasca oberta. No
  fusionar.
- **Optimista i confirmat**: es pinta de seguida i la subscripció confirma. Si el desat falla, **es
  desfà i es diu a la pantalla**; una casella que sembla marcada i no s'ha desat és pitjor que no
  poder-la marcar.
- **Sense base, tot bloquejat i amb avís.** Mai caselles clicables que no desen.
- **«Qui ets» es queda al navegador**, i la pantalla diu que **és una declaració, no una
  comprovació**.

## 3. Idiomes

- **Selector a la capçalera**, sempre visible, i el català primer. Es recorda al navegador
  (`localStorage`, dins de `try/catch`).
- **Cap text al marge del diccionari.** Tot el contingut viu en estructures `{ca, es}` i la pàgina
  **es torna a pintar sencera** en canviar d'idioma — inclosos els botons de les pestanyes, que és
  el que se'ns va oblidar la primera vegada.
- **`document.documentElement.lang` segueix l'idioma.** No és cosmètic: el lector de pantalla **tria
  la veu** per aquest atribut.
- **El castellà del Fernando és de Mèxic:** «celular», «computadora», «estacionamiento»; **mai**
  «vale», «coger» ni «vosotros». Quan el correu o la pàgina va a tot l'equip alhora, es tria el
  castellà neutre i s'evita el `vosotros`/`ustedes` reformulant.

## 4. Els diagrames: caixes i fletxes, no imatges

**Res d'imatges, res de Mermaid, res de SVG a mà.** Els diagrames es fan amb HTML i CSS —caixes,
graelles i una fletxa `▸` entre passos— per tres raons concretes: **es tradueixen** (són text del
diccionari), **es veuen en un mòbil** (les caixes s'apilen), i **funcionen als dos temes** (els
colors surten dels tokens).

Els quatre que han funcionat, i què fa cada un:

- **El camí del client, pas per pas**, amb **un indicador d'estat per pas** (§6). És el que
  substitueix mitja hora d'explicació.
- **Amb qui parlem i amb qui no** — nosaltres al mig, i al voltant els sistemes de tercers, cada un
  amb què li demanem i **en quin estat està**. És el diagrama que desarma la por a canviar de
  proveïdors.
- **El cas lleig** — el camí que es parteix en dos, amb la sortida bona i la dolenta **de colors
  diferents**. Aquest és el diagrama que ens distingeix: ensenya què fem **quan una cosa falla**.
- **El calendari amb les portes** — les fites en fila, i **les que són porta destacades**. Amb una
  frase que digui què és una porta: *una data amb una condició; si no es compleix, no es passa al
  següent.*

A sota, **un glossari de vuit paraules** com a màxim, amb les que no es poden evitar.

Regla de cascada apresa a cops: **no reutilitzis un nom de classe que ja té sentit en un altre
lloc**. Una classe `gate` per a una fila del calendari va heretar el `max-width` i el color de la
`gate` dels paràgrafs de fita, i el fons es tallava a mig ample. Si una classe nova xoca, es canvia
el nom.

## 5. Llenguatge planer

El filtre és **una persona comercial llegint-ho al mòbil**. Fora d'aquestes paraules, sempre:

| No | Sí |
|---|---|
| façana, backend, migració, desplegament | *el programa*, *el servidor*, *un canvi a la base*, *publicar* |
| RLS, política, guarda, endpoint | *una norma de seguretat*, *un control*, *el servidor* |
| MRZ | *la banda del document* |
| commodity, middleware | *això ja ho fa qualsevol*, *un intermediari* |
| PMS | *el programa de reserves de l'hotel* |
| credencial | *la clau* o *el codi*, segons el cas |
| 200 OK, `success: true` | *el proveïdor diu «d'acord»* |

I dues frases que val la pena tenir a la pàgina, perquè conviden a queixar-se:

- «**Si una cosa d'aquí no s'entén, és culpa del dibuix, no de qui el mira** — digues-ho i es refà.»
- «**Una paraula que ningú entén amaga una decisió que ningú pot discutir.**»

## 6. L'estat a la vista, no el desig

Tres indicadors i prou: **ja va** (verd) · **a mig fer** (àmbar) · **falta** (àmbar). A cada pas del
camí, a cada sistema de tercers i a cada proveïdor.

- **Simulat no és fet**, i es diu així a la pantalla.
- **Un proveïdor que ningú ha provat no és una opció: és una promesa.** Si ningú n'ha obert el
  compte, l'estat ho diu amb un ⚠️, encara que tot el pla hi descansi. **Sobretot si tot el pla hi
  descansa.**

## 7. Què no va mai en una pàgina publicada

Una pàgina publicada és **una URL: privada fins que es comparteix, i a un clic de qualsevol**. Per
tant, mai:

- **Cap secret ni cap enllaç privat** (freedolia-claus §0).
- **Cap número que no estiguem segurs**: preus de proveïdor sense confirmar, percentatges d'IVA
  sense la gestoria, percentatges d'encert mesurats sobre dades que hem fabricat nosaltres. Si no
  està confirmat, **hi va amb ⚠️ o no hi va**.
- **Cap dada real d'una persona**, i si el projecte encara no en té, **la pàgina ho diu**.
- **Cap promesa de suport que no puguem complir.** Si som una persona, ho diu.

Abans de passar l'enllaç a un client (i no a l'equip), **es repassa la pàgina amb aquesta llista a
la mà** i es diu a l'usuari què hi ha dins que encara no és per ensenyar a fora.

## 8. Com es comprova abans de publicar

Amb un navegador de debò, no a ull. És mitja dotzena d'ordres i ha enxampat cinc defectes:

1. **Compta el que ha de sortir**: caselles, pestanyes, files de cada taula, passos de cada
   diagrama. Si surten menys, alguna dada no s'ha pintat.
2. **Recorre les pestanyes** i comprova que **cap fa desbordar la pàgina de costat**
   (`scrollWidth === clientWidth`) **a 375-390 px**.
3. **Canvia d'idioma** i torna a llegir un títol de cada pestanya — inclosos **els botons de les
   pestanyes**.
4. **Tema fosc** i tema clar, els dos.
5. **Cap error ni avís a la consola.**
6. **Amb una base simulada**: marca una casella, comprova que apareix qui i quan, i desmarca-la.
7. **Després de publicar, torna a llegir la pàgina publicada** i busca-hi els marcadors nous. G3
   val també per a publicar: el missatge del publicador no és la comprovació.

## 9. Identitat visual (la mateixa per a tots els projectes)

Perquè dos taulers de Freedolia s'assemblin:

- **Tipografia:** `Instrument Serif` per a títols i números, `Instrument Sans` per a la resta
  (Google Fonts, amb pila de reserva).
- **Colors com a tokens a `:root`**, redefinits per al fosc **dues vegades**: sota
  `@media (prefers-color-scheme: dark)` protegit amb `:root:not([data-theme="light"])`, i sota
  `:root[data-theme="dark"]`. Base: fons `#EFEDE7`, superfície `#FAF9F5`, tinta `#1A1D1A`, verd
  `#1F4437`, àmbar `#9A6B1E`, vermell `#93321F`, or `#8F7335`.
- **`body` sempre amb fons explícit** del token. Un fons transparent agafa el del client.
- **Cantons gairebé rectes** (2 px), línies fines, cap ombra. Els números grans en serif.
- Tot **en un sol fitxer**, CSS i JS inclosos, i **sense res de fora** excepte les tipografies.

## 10. Casos límit

- **El tauler d'un projecte que ja existeix** → llegeix-lo abans de tocar-lo, **inventaria'n els
  `id`** i conserva'ls tots. Si una tasca ha desaparegut del pla, **es deixa la casella** amb el
  text nou o es diu explícitament que es retira.
- **L'usuari demana «menys tècnic»** → no és només treure paraules: sovint vol dir **afegir una
  pestanya de dibuixos** i deixar la tècnica marcada com a tècnica. Les dues coses van juntes.
- **L'usuari demana diagrames i el projecte no té el camí clar** → aleshores el diagrama és el
  treball, no l'adorn: dibuixar-lo destapa què no sabem. Es fa i es porta a la conversa.
- **La pàgina creix massa** → es retallen els assajos de les tasques a una o dues frases i **el
  detall es deixa al repo**. Un tauler és per fullejar.
- **No hi ha capacitat de base de dades** → es publica igual, amb les caselles bloquejades i
  l'avís, i es diu a l'usuari què li falta per poder-les marcar.
