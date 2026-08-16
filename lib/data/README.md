# Contenu statique — guide contributeur

Les questions du quiz et les fiches des courants politiques sont **codées en dur** dans ce dossier. Il n’y a pas de base de données ni d’API en V1.

## Fichiers

| Fichier | Contenu |
|---------|---------|
| `questions/questions_data.dart` | Affirmations du quiz (~58) |
| `political_currents/currents_data.dart` | Fiches des courants (~20) |
| `sources/shared_sources.dart` | Sources éducatives réutilisables |

## Ajouter une question

1. Ouvrir `questions/questions_data.dart`.
2. Ajouter un objet `Question` à la fin de la liste `loadQuestions()` :

```dart
Question(
  id: 'q059',
  text: 'Ton affirmation neutre…',
  category: 'economy',
  tags: const ['tag1'],
  difficulty: QuestionDifficulty.intro,
  impacts: const [
    QuestionImpact(currentId: 'socialisme', weight: 1.5),
    QuestionImpact(currentId: 'liberalisme_economique', weight: -1.2),
  ],
  explanation: 'Une phrase pédagogique optionnelle.',
),
```

### Règles éditoriales

- Formulation **neutre**, sans jugement de valeur explicite.
- Chaque question touche **plusieurs courants** (poids positifs et négatifs).
- Poids entre **−2.0 et +2.0** — jamais affichés à l’utilisateur.
- Varier les `category` pour une bonne couverture dimensionnelle.

## Ajouter ou modifier un courant

1. Ouvrir `political_currents/currents_data.dart`.
2. Respecter le modèle `PoliticalCurrent` :
   - `id` : slug snake_case (référencé dans les `QuestionImpact`)
   - `name`, `shortDescription`, `longDescription`
   - `family` : clé de regroupement (voir `familyLabels` dans `explore_page.dart`)
   - `color`, `keyIdeas`, `limits`, `examplesInFrance`, `sources`

## Vérifier après modification

```bash
dart analyze
flutter test
```
