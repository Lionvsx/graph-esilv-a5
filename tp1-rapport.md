# Rapport: Mining Bi-partite Graphs

## Introduction

Ce rapport présente les résultats obtenus lors de l'analyse des graphes bi-partites avec l'outil Neo4j. Le but principal est d'étudier la similarité et la prédiction de liens entre les utilisateurs et les lieux touristiques.

---

## 1. Similarity

1.1 **Jaccard Similarity entre les deux utilisateurs français ayant laissé le plus de commentaires :**

```plaintext
// Insérer ici les requêtes Neo4j utilisées pour calculer la similarité Jaccard.
```

- **Explication** : Cette requête permet de mesurer la similarité Jaccard entre deux utilisateurs sur les lieux touristiques qu'ils ont évalués.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot)

---

1.2 **Euclidean et Cosine Similarities :**

```plaintext
// Insérer ici les requêtes pour les similarités Euclidienne et cosinus.
```

- **Explication** : Ces deux métriques sont utilisées pour comparer la distance entre deux utilisateurs sur la base des notes attribuées aux lieux touristiques.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot)

---

1.3 **Comparaison des résultats Jaccard et Euclidean :**

Les résultats montrent des différences significatives entre ces mesures. La similarité Jaccard se concentre uniquement sur les lieux en commun, tandis que les similarités Euclidienne et cosinus tiennent compte des valeurs de notes, ce qui explique les écarts observés.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot)

---

## 2. Link Prediction

2.1 **Nombre de voisins communs entre les utilisateurs français ayant le plus commenté :**

```plaintext
// Requête pour calculer le nombre de voisins communs.
```

- **Explication** : Cette mesure permet de prédire si deux utilisateurs seront connectés dans le futur, basé sur leurs voisins communs.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot)

---

2.2 **Utilisation de l'Attachement Préférentiel, de l'Allocation de Ressources, et d'Adamic-Adar pour la prédiction de liens :**

```plaintext
// Requêtes pour l'attachement préférentiel, allocation de ressources, Adamic-Adar.
```

- **Explication** : Ces algorithmes permettent de prédire de nouveaux liens potentiels entre les utilisateurs. Adamic-Adar favorise les liens avec des voisins communs rares, ce qui pourrait indiquer des recommandations plus précises.

**Schéma explicatif des algorithmes** :
- ![Schéma explicatif](path_to_schema)

---

## Conclusion

Les résultats obtenus montrent des différences importantes dans les métriques de similarité et les techniques de prédiction de liens. La similarité Jaccard est pertinente pour les comparaisons globales, tandis que les méthodes d'Euclidean et cosinus permettent une approche plus fine basée sur les notes. Les prédictions de liens basées sur Adamic-Adar semblent être les plus efficaces pour les utilisateurs ayant des voisins communs rares.

