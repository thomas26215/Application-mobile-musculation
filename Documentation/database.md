# Documentation Technique : Base de Données d'Exercices et de Séances

## Table des matières

1. [Introduction](#introduction)
2. [Structure de la Base de Données](#structure-de-la-base-de-données)
3. [Types d'Exercices](#types-dexercices)
4. [Exemples d'Insertion](#exemples-dinsertion)
5. [Requêtes Courantes](#requêtes-courantes)
6. [Considérations de Performance](#considérations-de-performance)
7. [Évolutivité et Maintenance](#évolutivité-et-maintenance)

## Introduction

Cette documentation détaille la structure et l'utilisation de notre base de données pour la gestion des exercices et des séances d'entraînement. Elle est conçue pour être flexible, permettant de stocker divers types d'exercices tout en maintenant une structure cohérente.

## Structure de la Base de Données

### Aperçu des Tables

- `users`: Informations sur les utilisateurs
- `exercises`: Catalogue d'exercices crées par les utilisateurs
-  `tags`: Étiquettes pour classer les exercices
- `exercise_tags`: Association entre exercices et étiquettes
- `sessions`: Représentes les séances d'entraînements crées par les utilisateurs
- `session_exercises`: Représete les exercices présents dans une séance, leur ordre, paramètre, type d'exercice ...
- `exercise_ratings`: Évaluations des exercices
- `exercise_comments`: Commentaires sur les exercices
- `exercise_stats`: Statistiques d'utilisation des exercices

### Schéma Détaillé

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exercises (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type ENUM('strength', 'endurance') NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE exercise_tags (
    exercise_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (exercise_id, tag_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE session_exercises (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    exercise_id INTEGER NOT NULL,
    order_in_session INTEGER NOT NULL,
    sets INTEGER,
    reps INTEGER,
    duration INTEGER,
    rest_time INTEGER,
    weight DECIMAL(5,2),
    exercise_type ENUM('standard', 'dropSet', 'pyramid', 'timeUnderTension', 'superSet', 'giantSet', 'restPause', 'cluster') NOT NULL,
    custom_data JSON,
    FOREIGN KEY (session_id) REFERENCES sessions(id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(id)
);

CREATE TABLE exercise_ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    rating INTEGER CHECK(rating >= 1 AND rating <= 5),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE(exercise_id, user_id)
);

CREATE TABLE exercise_comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE exercise_stats (
    exercise_id INTEGER PRIMARY KEY,
    views INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    last_interaction DATETIME,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id)
);
```

### Représentation graphique

```mermaid
erDiagram

users {
    INTEGER id PK
    VARCHAR username
    VARCHAR email
    VARCHAR password_hash
    DATETIME created_at
}

exercises {
    INTEGER id PK
    INTEGER user_id FK
    VARCHAR name
    TEXT description
    VARCHAR type
    BOOLEAN is_public
    DATETIME created_at
}

tags {
    INTEGER id PK
    VARCHAR name
}

exercise_tags {
    INTEGER exercise_id PK, FK
    INTEGER tag_id PK, FK
}

sessions {
    INTEGER id PK
    INTEGER user_id FK
    VARCHAR name
    TEXT description
    DATETIME created_at
}

session_exercises {
    INTEGER id PK
    INTEGER session_id FK
    INTEGER exercise_id FK
    INTEGER order_in_session
    INTEGER sets
    INTEGER reps
    INTEGER duration
    INTEGER rest_time
    DECIMAL weight
    ENUM exercise_type
    JSON custom_data
}

exercise_ratings {
    INTEGER id PK
    INTEGER exercise_id FK
    INTEGER user_id FK
    INTEGER rating
    DATETIME created_at
}

exercise_comments {
    INTEGER id PK
    INTEGER exercise_id FK
    INTEGER user_id FK
    TEXT comment
    DATETIME created_at
}

exercise_stats {
    INTEGER exercise_id PK, FK
    INTEGER views
    INTEGER likes
    DATETIME last_interaction
}

users ||--o{ exercises : "crée"
users ||--o{ sessions : "crée"
exercises ||--o{ exercise_tags : "a"
tags ||--o{ exercise_tags : "a"
exercises ||--o{ session_exercises : "utilisé dans"
sessions ||--o{ session_exercises : "contient"
exercises ||--o{ exercise_ratings : "noté par"
users ||--o{ exercise_ratings : "note"
exercises ||--o{ exercise_comments : "commenté par"
users ||--o{ exercise_comments : "commente"
exercises ||--|| exercise_stats : "a"
```

## Types d'Exercices

Notre système supporte plusieurs types d'exercices, chacun avec ses spécificités :

1. **Standard**: Exercices classiques avec séries et répétitions fixes
2. **Drop Set**: Séries avec diminution progressive du poids
3. **Pyramid**: Augmentation puis diminution du poids/répétitions
4. **Time Under Tension (TUT)**: Focus sur le temps sous tension musculaire
5. **Super Set**: Deux exercices enchaînés sans repos
6. **Giant Set**: Série de plusieurs exercices sans repos
7. **Rest Pause**: Courtes pauses entre les répétitions
8. **Cluster**: Groupes de répétitions avec pauses courtes

## Exemples d'Insertion

Voici l’ensemble des exemples d’insertion adaptés à la vie réelle, avec des commentaires détaillés pour chaque cas. Ces exemples montrent comment insérer différents types d’exercices dans une séance, en tenant compte des besoins pratiques courants (par exemple, plusieurs séries de drop sets, gestion des paramètres avancés, etc.)[1].

---

## Exercice Standard

```sql
-- Création d'un exercice de squat classique
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Squat', 'Squat standard avec barre', 'strength', true);

-- Ajout de cet exercice à une séance avec 3 séries de 10 répétitions à 100 kg
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, reps, weight, exercise_type
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Squat'),
  1,
  3,
  10,
  100,
  'standard'
);
```
**Commentaire :**  
Cet exemple correspond à un exercice classique de musculation. L’utilisateur effectue 3 séries de 10 répétitions de squat à 100 kg. Ce format est le plus courant pour structurer un exercice « de base » avec séries et répétitions fixes.

---

## Drop Set (plusieurs séries)

```sql
-- Création d'un exercice de curl biceps en drop set
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Curl biceps drop set', 'Curl biceps avec plusieurs séries drop set', 'strength', true);

-- Ajout de l'exercice à la séance avec 3 séries de drop set
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, exercise_type, custom_data
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Curl biceps drop set'),
  2,
  3, -- 3 séries de drop set
  'dropSet',
  JSON_OBJECT(
    'drops', JSON_ARRAY(
      JSON_OBJECT('weight', 20, 'reps', 8),
      JSON_OBJECT('weight', 15, 'reps', 8),
      JSON_OBJECT('weight', 10, 'reps', 8)
    ),
    'rest_between_sets', 90 -- 90 secondes de repos entre chaque série complète de drop set
  )
);
```
**Commentaire :**  
L’utilisateur effectue ici 3 séries de drop set. Chaque série consiste à faire 8 répétitions à 20 kg, puis sans repos baisser à 15 kg pour 8 reps, puis à 10 kg pour 8 reps. Après chaque série complète de drop set, il prend 90 secondes de repos. Ce format est très utilisé en musculation pour augmenter l’intensité d’un exercice sur plusieurs séries.

---

## Pyramid

```sql
-- Création d'un exercice pyramidal
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Développé militaire pyramidal', 'Développé militaire avec augmentation puis diminution du poids', 'strength', true);

-- Ajout à la séance avec structure pyramidale
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, exercise_type, custom_data
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Développé militaire pyramidal'),
  3,
  'pyramid',
  JSON_OBJECT(
    'sets', JSON_ARRAY(
      JSON_OBJECT('weight', 40, 'reps', 12),
      JSON_OBJECT('weight', 50, 'reps', 10),
      JSON_OBJECT('weight', 60, 'reps', 8),
      JSON_OBJECT('weight', 50, 'reps', 10),
      JSON_OBJECT('weight', 40, 'reps', 12)
    )
  )
);
```
**Commentaire :**  
L’exercice suit ici une progression pyramidale : on commence léger (40 kg, 12 reps), on monte en charge (jusqu’à 60 kg, 8 reps), puis on redescend. Cela permet de travailler avec différentes intensités et volumes sur un même exercice, ce qui est courant pour le développement de la force et de la masse musculaire.

---

## Time Under Tension (TUT)

```sql
-- Création d'un exercice d'endurance basé sur le temps sous tension
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Planche TUT', 'Planche avec temps sous tension', 'endurance', true);

-- Ajout à la séance avec 3 séries de 60 secondes, tempo contrôlé
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, exercise_type, custom_data
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Planche TUT'),
  4,
  3,
  'timeUnderTension',
  JSON_OBJECT(
    'duration', 60,
    'tempo', '2-1-2-1'
  )
);
```
**Commentaire :**  
L’utilisateur effectue 3 séries de planche, chaque série durant 60 secondes, avec un tempo spécifique (par exemple, 2 secondes montée, 1 seconde maintien, 2 secondes descente, 1 seconde pause). Ce format est adapté aux exercices où le temps sous tension est plus important que le nombre de répétitions.

---

## Super Set

```sql
-- Création de deux exercices pour un super set
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES 
  (1, 'Développé couché', 'Développé couché avec barre', 'strength', true),
  (1, 'Rowing barre', 'Rowing avec barre', 'strength', true);

-- Ajout à la séance, les deux exercices sont enchaînés sans repos
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, reps, weight, exercise_type, custom_data
)
VALUES 
  (1, (SELECT id FROM exercises WHERE name = 'Développé couché'), 5, 3, 10, 80, 'superSet', JSON_OBJECT('super_set_order', 1)),
  (1, (SELECT id FROM exercises WHERE name = 'Rowing barre'), 5, 3, 10, 70, 'superSet', JSON_OBJECT('super_set_order', 2));
```
**Commentaire :**  
Ici, l’utilisateur enchaîne deux exercices (développé couché puis rowing barre) sans repos entre eux, pour 3 séries de 10 répétitions chacun. L’ordre d’exécution dans le super set est précisé dans le champ `custom_data`. Ce format permet d’augmenter l’intensité et de gagner du temps.

---

## Giant Set

```sql
-- Création de quatre exercices pour un giant set
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES 
  (1, 'Squat', 'Squat avec barre', 'strength', true),
  (1, 'Fentes', 'Fentes alternées', 'strength', true),
  (1, 'Extensions jambes', 'Extensions des jambes à la machine', 'strength', true),
  (1, 'Mollets debout', 'Élévations des mollets debout', 'strength', true);

-- Ajout à la séance, tous les exercices sont réalisés à la suite sans repos
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, reps, exercise_type, custom_data
)
VALUES 
  (1, (SELECT id FROM exercises WHERE name = 'Squat'), 6, 3, 10, 'giantSet', JSON_OBJECT('giant_set_order', 1)),
  (1, (SELECT id FROM exercises WHERE name = 'Fentes'), 6, 3, 10, 'giantSet', JSON_OBJECT('giant_set_order', 2)),
  (1, (SELECT id FROM exercises WHERE name = 'Extensions jambes'), 6, 3, 12, 'giantSet', JSON_OBJECT('giant_set_order', 3)),
  (1, (SELECT id FROM exercises WHERE name = 'Mollets debout'), 6, 3, 15, 'giantSet', JSON_OBJECT('giant_set_order', 4));
```
**Commentaire :**  
L’utilisateur réalise ici un circuit de 4 exercices (giant set), enchaînés sans repos, pour 3 tours. Chaque exercice a son ordre dans le circuit, précisé dans `custom_data`. Ce type de structure est utilisé pour maximiser le volume et l’intensité sur un groupe musculaire.

---

## Rest Pause

```sql
-- Création d'un exercice rest-pause
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Tractions rest-pause', 'Tractions avec méthode rest-pause', 'strength', true);

-- Ajout à la séance avec paramètres spécifiques rest-pause
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, exercise_type, custom_data
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Tractions rest-pause'),
  7,
  'restPause',
  JSON_OBJECT(
    'initial_reps', 8,
    'rest_time', 15,
    'subsequent_sets', JSON_ARRAY(5, 3, 2)
  )
);
```
**Commentaire :**  
L’utilisateur commence par faire 8 tractions, prend 15 secondes de repos, puis fait 5 reps, reprend 15 secondes, puis 3 reps, etc. Ce format permet d’aller au-delà de l’échec musculaire sur un exercice donné, en fractionnant l’effort avec de très courtes pauses.

---

## Cluster

```sql
-- Création d'un exercice cluster
INSERT INTO exercises (user_id, name, description, type, is_public)
VALUES (1, 'Développé couché cluster', 'Développé couché avec méthode cluster', 'strength', true);

-- Ajout à la séance avec structure cluster
INSERT INTO session_exercises (
  session_id, exercise_id, order_in_session, sets, exercise_type, custom_data
)
VALUES (
  1,
  (SELECT id FROM exercises WHERE name = 'Développé couché cluster'),
  8,
  5,
  'cluster',
  JSON_OBJECT(
    'reps_per_cluster', 2,
    'clusters_per_set', 4,
    'rest_between_clusters', 10,
    'weight', 90
  )
);
```
**Commentaire :**  
L’utilisateur effectue 5 séries, chaque série étant découpée en 4 mini-blocs (clusters) de 2 répétitions, avec 10 secondes de repos entre chaque cluster, à 90 kg. Cette méthode permet de soulever plus lourd ou de faire plus de volume que sur des séries classiques.


## Requêtes Courantes

### Récupérer tous les exercices d'une séance

```sql
SELECT e.name, se.sets, se.reps, se.weight, se.exercise_type, se.custom_data
FROM session_exercises se
JOIN exercises e ON se.exercise_id = e.id
WHERE se.session_id = ?
ORDER BY se.order_in_session;
```

### Obtenir les exercices les plus populaires

```sql
SELECT e.name, es.views, es.likes
FROM exercises e
JOIN exercise_stats es ON e.id = es.exercise_id
ORDER BY es.views DESC, es.likes DESC
LIMIT 10;
```

### Calculer la moyenne des notes pour un exercice

```sql
SELECT e.name, AVG(er.rating) as average_rating
FROM exercises e
LEFT JOIN exercise_ratings er ON e.id = er.exercise_id
WHERE e.id = ?
GROUP BY e.id;
```

## Considérations de Performance

- Indexez les colonnes fréquemment utilisées dans les clauses WHERE et JOIN
- Utilisez des requêtes préparées pour améliorer la sécurité et les performances
- Considérez l'utilisation de vues matérialisées pour les requêtes complexes fréquemment exécutées
- Optimisez les requêtes impliquant des jointures multiples ou des sous-requêtes

## Évolutivité et Maintenance

- La colonne `custom_data` (JSON) permet d'ajouter facilement de nouveaux attributs sans modifier le schéma
- Envisagez l'utilisation de partitionnement pour les tables qui grossissent rapidement (comme `session_exercises`)
- Mettez en place des sauvegardes régulières et testez les procédures de restauration
- Surveillez régulièrement les performances des requêtes et optimisez si nécessaire
- Maintenez une documentation à jour pour faciliter l'évolution du schéma

Cette documentation technique fournit une vue d'ensemble complète de la structure de la base de données, des types d'exercices supportés, des exemples d'insertion pour chaque type, ainsi que des considérations importantes pour la performance et la maintenance du système.
