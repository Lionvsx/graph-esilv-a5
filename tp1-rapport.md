# Rapport: Mining Bi-partite Graphs

## Introduction

Ce rapport présente les résultats obtenus lors de l'analyse des graphes bi-partites avec l'outil Neo4j. Le but principal est d'étudier la similarité et la prédiction de liens entre les utilisateurs et les lieux touristiques.

---

## 2.1 Similarity

### 2.1.1 Les deux utilisateurs français ayant laissé le plus de commentaires

```cypher
// Requête pour trouver les deux utilisateurs français avec le plus de commentaires
```

**Explication** : Cette requête identifie les deux utilisateurs français les plus actifs en termes de nombre total de commentaires.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot_2.1.1)

---

### 2.1.2 Similarité de Jaccard entre les zones distinctes

```cypher
// Requête pour calculer la similarité de Jaccard entre les zones distinctes des deux utilisateurs
```

**Explication** : Cette requête calcule la similarité de Jaccard entre les zones distinctes visitées par les deux utilisateurs français les plus actifs.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot_2.1.2)

---

### 2.1.3 Similarité pour les deux utilisateurs français ayant visité le plus de zones distinctes

```cypher
// Requête pour trouver et calculer la similarité pour les deux utilisateurs avec le plus de zones distinctes
```

**Explication** : Cette requête identifie les deux utilisateurs français ayant visité le plus de zones distinctes et calcule leur similarité.

**Capture d'écran des résultats** :
- ![Capture d'écran](path_to_screenshot_2.1.3)

---

### 2.1.4 Explication des différences

Les différences observées entre les résultats des sections 2.1.2 et 2.1.3 peuvent s'expliquer par...

---

### 2.1.5 Chevauchement (Overlap) et comparaison avec Jaccard

```cypher
// Requête pour calculer le chevauchement
```

**Explication** : Le chevauchement diffère de la similarité de Jaccard en ce que...

---

### 2.1.6 Similarités Euclidienne et Cosinus basées sur le nombre de commentaires (NB)

```cypher
// Requêtes pour les similarités Euclidienne et Cosinus basées sur NB
```

**Explication** : Ces mesures diffèrent des précédentes car...

---

### 2.1.7 Similarités basées sur les notes

```cypher
// Requêtes pour les similarités basées sur les notes
```

**Explication** : L'utilisation des notes plutôt que du nombre de commentaires change les résultats car...

---

### 2.1.8 Similarités pour les zones en commun uniquement

```cypher
// Requêtes pour les similarités sur les zones communes
```

**Explication** : En se concentrant uniquement sur les zones communes, nous observons que...

---

### 2.1.9 Similarités moyennes pour les utilisateurs espagnols

```cypher
// Requête pour calculer les similarités moyennes pour les Espagnols
```

**Explication** : Cette analyse se concentre sur les utilisateurs espagnols ayant visité au moins 5 lieux par zone.

---

### 2.1.10 Comparaison avec les utilisateurs britanniques, américains et italiens

```cypher
// Requêtes pour les similarités des autres nationalités
```

**Explication** : Les différences observées entre ces nationalités peuvent s'expliquer par...

---

## 2.2 Link Prediction

### 2.2.1 Nombre de voisins communs entre les deux Français les plus actifs

```cypher
// Requête pour calculer le nombre de voisins communs
```

**Explication** : Cette mesure est importante pour la prédiction de liens car...

---

### 2.2.2 Prédiction de liens avec différentes méthodes

```cypher
// Requêtes pour les différentes méthodes de prédiction de liens
```

**Explication** : Chaque méthode (voisins totaux, attachement préférentiel, allocation de ressources, Adamic-Adar) a ses particularités...

---

### 2.2.3 Explication des différences entre les méthodes

Les différences observées entre ces méthodes de prédiction de liens s'expliquent par...

---

### 2.2.4 Top 10 des voisins partagés entre les 10 meilleurs commentateurs espagnols

```cypher
// Requête pour le top 10 des voisins partagés
```

**Explication** : Cette analyse nous permet de comprendre...

---

### 2.2.5 Discussion des résultats basée sur les voisins communs

En examinant les voisins communs, nous pouvons conclure que...

---

## Conclusion

Ce rapport a exploré diverses mesures de similarité et méthodes de prédiction de liens dans le contexte d'un graphe biparti d'utilisateurs et de lieux touristiques. Les principales conclusions sont...
