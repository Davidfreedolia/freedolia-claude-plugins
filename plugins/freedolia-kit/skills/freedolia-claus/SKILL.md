---
name: freedolia-claus
description: >
  Genera i retira secrets d'un projecte —tokens d'enllac privat, contrasenyes de
  servei, claus d'API— sense que el text en clar entri mai en una conversa. Activa-la
  quan calgui "un enllac per a X", "un token de demo", "l'usuari de Y", rotar una
  clau filtrada, o retirar un acces. Tambe quan l'usuari digui que ha perdut un
  token: la resposta gairebe sempre es regenerar-lo, no buscar-lo.
---

# Freedolia — Claus

**Objectiu:** que un agent pugui **preparar** un secret nou de punta a punta —generar-lo, deixar-lo
a mà de la persona, desar-ne només la petjada a la base i comprovar-ho— **sense veure'l ni un
moment**. No és una precaució teòrica: a Freehospitality hem hagut de rotar un token dues vegades
perquè el valor va acabar en una sortida d'eina.

## 0. La regla que explica tota la resta

> **El text en clar no surt d'on s'ha generat.**

D'aquí surt tot el procediment. Si el secret es genera a la màquina de la persona i només en surt
el **hash**, aleshores: la conversa no és un lloc on hi hagi secrets, el registre de la sessió no
n'és cap còpia, i **no hi ha res a rotar si el registre es comparteix**.

Tres corol·laris que valen per a qualsevol projecte:

- **Un enllaç privat és una contrasenya.** Un `/e/<token>` que obre les dades d'un client no és una
  URL: és una credencial. No es comparteix, no s'enganxa a un xat d'equip, no va a cap pàgina
  publicada, i **cada persona té el seu**.
- **Rotar és l'única manera de desfer una fuita.** No hi ha «ja l'he esborrat del xat».
- **A la base només hi ha el hash**, i per tant **un secret perdut no es recupera: es regenera.**
  Quan algú diu «he perdut el token», la resposta no és buscar-lo: és fer-ne un de nou i caducar el
  vell.

## 1. El procediment, en cinc passos

1. **L'script genera** el secret a la màquina de la persona, en calcula el hash, i **imprimeix
   només el hash** (dins l'`insert`/`update` que toqui). Si porta l'opció de fitxer, **escriu
   l'enllaç o el valor en un fitxer** i no l'imprimeix.
2. **L'agent llegeix el hash** de la sortida i **escriu a la base** (via MCP, Management API o el
   que hi hagi). Mai el valor.
3. **L'agent comprova rellegint** (G3): quantes files vives hi ha, de quina entitat, i quan
   caduquen. Un `success: true` no és una comprovació.
4. **La persona obre el fitxer**, passa el valor al gestor de contrasenyes **i esborra el fitxer**.
5. **L'agent ho diu pla**: on és el fitxer, què ha de fer la persona, i **què no ha pogut
   comprovar** (§4).

El fitxer va **fora del repo** i fora de qualsevol carpeta sincronitzada si es pot triar. A Windows,
l'escriptori serveix i es veu, que és justament el que volem: que molesti fins que s'esborri.

## 2. La forma de l'script (reutilitzable)

Qualsevol projecte nou hauria de tenir un `scripts/enllac-*.ps1` (o `.sh`) amb aquesta forma. El de
Freehospitality és el model:

- `param(...)` amb el que identifica l'entitat (habitació, client, usuari), els **dies de validesa**
  i **`-Fitxer <ruta>`**.
- Generar amb el generador criptogràfic del sistema, **no amb `Random`**: 24 bytes en hexadecimal
  (48 caràcters) va bé.
- Hash **sha256 en hexadecimal minúscula**. Si la base fa `encode(digest(x,'sha256'),'hex')`, és el
  mateix format — i això **es comprova un cop**, no s'assumeix (§4).
- Imprimir l'SQL **sencer i en tres trossos comentats**: (1) caducar el que hi hagi viu, (2)
  inserir el nou, (3) la consulta de comprovació.
- Amb `-Fitxer`: escriure el valor allà, **no imprimir-lo**, i dir-ho a la sortida.
- Sense `-Fitxer`: imprimir-lo, perquè una persona sola al seu terminal té dret a fer-ho.

Un agent **pot cridar l'script amb `-Fitxer`**. Sense l'opció, **no el crida**: demana a la persona
que el corri ella.

## 3. Retirar, no esborrar

- Es **caduca** (`expires_at = now()`), **no s'esborra la fila**. Així queda constància de quan va
  caure aquell accés, i una auditoria pot dir «aquest enllaç va deixar de valer el dia X».
- Caducar el que hi hagi viu **abans** d'inserir el nou, en la mateixa tanda. Si no, queden dos
  accessos vius i ningú sap quin té qui.
- Si la regla del producte és **un accés viu per entitat**, que ho digui la base (índex únic o
  condició), **no la intenció de ningú**.

## 4. Comprovar de veritat, i dir què no s'ha comprovat

**El parany en què hem caigut:** demanar l'enllaç per HTTP i veure un `200`. En una aplicació d'una
sola pàgina **el servidor torna la mateixa pàgina per a qualsevol token** i la validació la fa el
navegador després. El `200` del token bo i el del token inventat són **idèntics, byte a byte** — ho
hem mesurat. Un control negatiu que dona el mateix resultat que el cas bo **no és un control**.

El que sí que es pot comprovar sense veure el secret:

- **Que les dues implementacions del hash coincideixen**, sobre un valor conegut: calcula
  `sha256("prova")` a la màquina i a la base i compara. Si quadren, la fila correspon al valor.
- **Que hi ha exactament una fila viva**, de l'entitat correcta, amb la caducitat esperada.
- **Que el fitxer existeix i té la mida que toca** (llargada del prefix + llargada del token).

El que **no** es pot comprovar sense la persona: que l'enllaç obri. **Es diu, no s'insinua**: «la
comprovació de veritat és que l'obris tu una vegada».

## 5. Què no fa mai un agent

- **No imprimeix ni repeteix un secret**, ni «per confirmar», ni escurçat, ni amb els caràcters del
  mig tapats.
- **No busca un fitxer de secrets amb un patró de text.** Va passar: un patró que excloïa `sk_` i
  `eyJ` **no excloïa un hexadecimal de 48 caràcters**, i el token va sortir a la sortida de l'eina.
  Per saber què hi ha en un fitxer de secrets, es llegeix **l'inventari sense valors**
  (`docs/CLAUS.md`), no el fitxer.
- **No crea comptes ni s'autoritza a si mateix**, i **no escriu contrasenyes en cap formulari**.
- **No demana a la persona que li enganxi un secret** a la conversa. Si el necessita per a un pas,
  el pas el fa la persona.
- **No dona per rotada una clau** perquè s'hagi apuntat al full de pendents. Rotar és una acció amb
  data i comprovació pels dos costats: **el nou obre i el vell no**.

## 6. Casos límit

- **«He perdut el token»** → §0: es regenera. I abans de regenerar, **mira si l'`insert` es va
  executar mai**: a Freehospitality no hi havia cap fila per a aquella entitat, o sigui que aquell
  enllaç **no havia funcionat mai** i ningú se n'havia adonat. Comprovar-ho és una consulta.
- **L'script no té `-Fitxer`** → afegeix-la (és una opció, no una reescriptura), comiteja-la, i
  aleshores crida'l. És el que fa que el pas següent el pugui fer l'agent.
- **Cal el secret per provar un camí de punta a punta** → el camí el prova la persona, o es prova
  **la peça de sota** (la funció de la base amb un valor de prova) en lloc del camí sencer.
- **La sortida de l'script s'ha d'ensenyar a l'usuari** → ensenya-li **el hash i l'SQL**, que no
  són secrets, i **la ruta del fitxer**. Res més.
- **La persona demana que li digui el token** perquè no troba el fitxer → digues on és i com
  obrir-lo. Si el fitxer s'ha perdut, **es regenera**: no hi ha manera de recuperar-lo, i és per
  disseny.
