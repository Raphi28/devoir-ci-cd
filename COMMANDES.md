# Commandes du projet

Liste de toutes les commandes disponibles et de ce qu'elles produisent.

L'application (`package.json`, `src/`, etc.) est isolée dans `projet-react/`, séparée du Dockerfile/`compose.yml`/`Makefile` qui restent à la racine : Docker est un ajout optionnel, pas une dépendance du projet lui-même. Concrètement :
- le raccourci **`make`** s'exécute depuis la racine (là où se trouve ce fichier) ;
- la **commande brute équivalente** (npm, à coller dans un pipeline CI ou si `make` n'est pas installé) s'exécute depuis **`projet-react/`**, puisque c'est là que vit `package.json`.

## En local (sans Docker)

### `make install`

```bash
make install
```
Installe les dépendances exactement telles que fixées dans `package-lock.json` (React, Vite, Vitest, ESLint, etc.).

**Résultat** : un dossier `node_modules/` créé, aucune sortie particulière à part le log de `npm ci`.

**Commande brute (CI)** :
```bash
npm ci
```
`npm ci` plutôt que `npm install` : en CI, on veut une installation reproductible à partir du lockfile, sans jamais le modifier.

### `make dev`

```bash
make dev
```
Démarre le serveur de développement **Vite** directement sur la machine (pas de Docker), avec rechargement à chaud (HMR) : chaque modification d'un fichier `.jsx`/`.css` apparaît dans le navigateur en quelques centaines de millisecondes, sans même actualiser la page.

**Résultat** : affiche l'URL locale (`http://localhost:5173/` par défaut). Le terminal reste occupé (`Ctrl+C` pour arrêter).

**Commande brute** :
```bash
npm run dev
```

⚠️ **Ne pas confondre avec `make up`** : celui-ci construit une image Docker de **production** (le code est compilé une fois pour toutes, puis servi par nginx). Rien n'y est surveillé ni recompilé automatiquement : modifier un fichier et actualiser la page ne changera rien tant que l'image n'a pas été reconstruite (`make up` à nouveau, ce qui relance tout le build). Pour développer au jour le jour, toujours utiliser `make dev`, jamais `make up`.

### `make test`

```bash
make test
```
Lance la suite de tests avec **Vitest**.

**Résultat** :
```
 Test Files  1 passed (1)
      Tests  3 passed (3)
```
Les tests utilisent `jsdom` (fourni par Vitest) pour simuler un navigateur, et **React Testing Library** pour interagir avec les composants comme le ferait un utilisateur (remplir un champ, cliquer sur un bouton).

**Commande brute (CI)** :
```bash
npm test
```

### `make test-coverage`

```bash
make test-coverage
```
Lance les tests avec un rapport de couverture (provider `v8`).

**Résultat** :
```
Statements   : 100% ( 15/15 )
Branches     : 100% ( 7/7 )
```
Un dossier `coverage/` est généré (rapport HTML consultable, format texte affiché dans le terminal).

**Commande brute (CI)** :
```bash
npm run test:coverage
```

### `make lint`

```bash
make lint
```
Analyse le code avec **ESLint** (règles React, variables inutilisées, imports incorrects ; config dans `eslint.config.js`).

**Résultat** : aucune sortie si tout est propre (code de sortie 0). Sinon, ESLint liste les fichiers et lignes concernés (code de sortie non nul).

**Commande brute (CI)** :
```bash
npm run lint
```

### `make build`

```bash
make build
```
Compile l'application pour la production avec Vite.

**Résultat** :
```
dist/index.html                   0.47 kB
dist/assets/index-xxxxxxxx.css    2.66 kB
dist/assets/index-xxxxxxxx.js   194.90 kB
✓ built in 240ms
```
Un dossier `dist/` est créé : c'est ce dossier, et uniquement lui, qui doit être déployé.

**Commande brute (CI)** :
```bash
npm run build
```

## Avec Docker

### `make up`

```bash
make up
```
Construit l'image (build Node puis étape nginx) et démarre le conteneur `web`.

**Résultat** : un conteneur `projet-react-web-1` en cours d'exécution. L'application est accessible sur http://localhost:5003.

**Commande brute (CI)** :
```bash
docker compose up -d --build
```

### `make logs`

```bash
make logs
```
Affiche les logs du conteneur en continu (accès nginx).

**Commande brute** :
```bash
docker compose logs -f
```

### `make down`

```bash
make down
```
Arrête et supprime le conteneur `web`.

**Commande brute (CI)** :
```bash
docker compose down
```

### `make docker-build`

```bash
make docker-build
```
Reconstruit l'image sans démarrer de conteneur.

**Commande brute (CI)** :
```bash
docker compose build
```

## Nettoyage

### `make clean`

```bash
make clean
```
Supprime `node_modules/`, `dist/` et `coverage/`.

**Résultat** : dossier du projet remis à l'état "juste après un clone git".

**Commande brute** :
```bash
rm -rf node_modules dist coverage
```

## Utiliser l'application en ligne de commande (`curl`)

Il n'y a pas d'API JSON ici : l'application est une page HTML unique une fois compilée. Le port dépend de comment elle tourne : **5003** via `make up` (Docker), ou **5173** via `make dev` (serveur de développement Vite).

```bash
curl http://localhost:5003/
```
**Résultat** : le code HTML de la page (avec `<title>Camille Dubois, Portfolio</title>`), les fichiers CSS/JS étant chargés séparément par le navigateur.

## Utiliser l'interface (navigateur)

Ouvrir http://localhost:5003/ :

- Section **A propos** : présentation
- Section **Projets** : boutons de filtre (Tous / Web / Mobile / Design) qui réduisent la liste affichée
- Section **Contact** : formulaire nom/email/message. Une adresse email invalide affiche "Veuillez saisir une adresse email valide." ; un envoi valide affiche "Message envoyé, merci ! Je reviens vers vous rapidement."
