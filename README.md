# Portfolio interactif, React

Petit portfolio développé avec **React** (Vite) : une page à sections (à propos, projets, contact), avec un projet interactif testé automatiquement. Elle expose :

- Une section **A propos** avec une courte présentation
- Une section **Projets** avec un filtre par catégorie (Tous, Web, Mobile, Design)
- Une section **Contact** avec un formulaire (nom, email, message) qui valide l'adresse email côté client et affiche un message d'erreur ou de confirmation

Il n'y a ni backend ni base de données : l'application est entièrement statique une fois compilée, il n'y a donc qu'un seul service Docker (le serveur qui sert les fichiers compilés).

**Docker est optionnel** : l'application (`projet-react/`) est un projet Vite autonome, utilisable avec les seules commandes `npm`, sans jamais toucher à Docker. Le Dockerfile/`compose.yml`/`Makefile` vivent à la racine, en dehors du dossier de l'application, et ne servent qu'à qui veut la faire tourner en conteneur.

**Pour développer au quotidien, ne pas utiliser Docker** : `make up` construit une image de production (nginx sert des fichiers figés, sans rechargement automatique). Pour voir chaque modification instantanément (HMR), lancer `make dev`, qui démarre le serveur de développement Vite directement sur la machine.

## Structure du projet

```
sujet_etudiant/
├── projet-react/              # l'application, autonome (rien de Docker ici)
│   ├── src/
│   │   ├── components/
│   │   │   ├── Header.jsx
│   │   │   ├── About.jsx
│   │   │   ├── Projects.jsx
│   │   │   ├── Contact.jsx
│   │   │   ├── ContactForm.jsx
│   │   │   └── ContactForm.test.jsx   # tests Vitest + React Testing Library
│   │   ├── data/
│   │   │   └── projects.js
│   │   ├── App.jsx
│   │   ├── main.jsx
│   │   ├── setupTests.js
│   │   ├── index.css
│   │   └── App.css
│   ├── index.html
│   ├── vite.config.js          # config Vite + config des tests (bloc `test`)
│   ├── eslint.config.js        # config ESLint
│   ├── package.json
│   └── .dockerignore           # doit rester ici : c'est la racine du contexte de build
├── Dockerfile                   # construit projet-react/ (contexte pointé depuis compose.yml)
├── compose.yml
├── Makefile                     # délègue chaque commande npm dans projet-react/
├── COMMANDES.md                 # détail de chaque commande + résultat attendu
└── README.md
```

## Commandes

Chaque commande existe sous deux formes : le raccourci `make` (pratique en local) et la commande brute équivalente (à utiliser telle quelle dans un pipeline CI, ou si `make` n'est pas disponible). Détail complet et résultat attendu de chacune : voir **[COMMANDES.md](COMMANDES.md)**.

| Action                                   | `make`               | Commande brute (CI)                 |
| ---------------------------------------- | -------------------- | ----------------------------------- |
| Installer les dépendances                | `make install`       | `npm ci`                            |
| Développer avec rechargement instantané  | `make dev`           | `npm run dev`                       |
| Lancer les tests                         | `make test`          | `npm test`                          |
| Lancer les tests avec couverture         | `make test-coverage` | `npm run test:coverage`             |
| Linter le code (ESLint)                  | `make lint`          | `npm run lint`                      |
| Construire le build de production        | `make build`         | `npm run build`                     |
| Construire l'image Docker                | `make docker-build`  | `docker compose build`              |
| Démarrer le conteneur                    | `make up`            | `docker compose up -d --build`      |
| Voir les logs                            | `make logs`          | `docker compose logs -f`            |
| Arrêter le conteneur                     | `make down`          | `docker compose down`               |
| Nettoyer (node_modules, build, coverage) | `make clean`         | `rm -rf node_modules dist coverage` |



Voir [COMMANDES.md](COMMANDES.md) pour le détail.
