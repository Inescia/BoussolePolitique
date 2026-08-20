import 'package:boussole_politique/features/quiz/models/question.dart';

/// Cartes supplémentaires : thèmes peu couverts, debates publics documentés.
///
/// Le champ [Question.source] cite un **repère institutionnel** (le débat existe
/// dans la vie publique), pas une « preuve » de l’affirmation.
List<Question> extraQuestions() => const [
  Question(
    id: 'q059',
    text: 'Les minima sociaux devraient être revalorisés.',
    category: 'redistribution',
    tags: ['minima', 'solidarite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.7),
      QuestionImpact(currentId: 'social_democratie', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 1.1),
      QuestionImpact(currentId: 'communisme', weight: 1.3),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.5),
      QuestionImpact(currentId: 'conservatisme', weight: -0.9),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.6),
    ],
    source: 'Vie publique · Protection sociale',
    explanation:
        'RSA, ASPA et autres minima : le débat porte sur leur niveau, '
        'pas encore sur la façon de les financer.',
  ),
  Question(
    id: 'q060',
    text:
        'L’État devrait davantage encadrer les prix de biens essentiels, '
        'comme l’énergie ou le logement.',
    category: 'market',
    tags: ['prix', 'regulation'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.5),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.4),
      QuestionImpact(currentId: 'social_democratie', weight: 1.0),
      QuestionImpact(currentId: 'souverainisme', weight: 0.6),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.8),
      QuestionImpact(currentId: 'liberalisme', weight: -1.4),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.9),
    ],
    source: 'Vie publique · Régulation des marchés',
    explanation:
        'Oppose régulation des prix et confiance dans le marché pour '
        'l’accès aux biens essentiels.',
  ),
  Question(
    id: 'q061',
    text:
        'Une aide à mourir devrait être possible, sous conditions médicales '
        'strictes.',
    category: 'civil_liberties',
    tags: ['fin_de_vie', 'libertes'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.6),
      QuestionImpact(currentId: 'progressisme', weight: 1.5),
      QuestionImpact(currentId: 'radicalisme', weight: 1.1),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.7),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -1.6),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.7),
      QuestionImpact(currentId: 'conservatisme', weight: -1.0),
    ],
    source: 'Vie publique · Fin de vie',
    explanation:
        'Le débat public oppose autonomie de la personne, éthique médicale '
        'et rôle du législateur.',
  ),
  Question(
    id: 'q062',
    text:
        'Un service national, civil ou militaire, devrait être obligatoire '
        'pour les jeunes.',
    category: 'authority',
    tags: ['service', 'jeunesse'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'gaullisme', weight: 1.6),
      QuestionImpact(currentId: 'republicanisme', weight: 1.3),
      QuestionImpact(currentId: 'nationalisme', weight: 1.2),
      QuestionImpact(currentId: 'conservatisme', weight: 1.0),
      QuestionImpact(currentId: 'souverainisme', weight: 0.8),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.7),
      QuestionImpact(currentId: 'anarchisme', weight: -1.8),
      QuestionImpact(currentId: 'liberalisme_politique', weight: -0.8),
    ],
    source: 'Vie publique · Service national',
    explanation:
        'Interroge le lien entre la Nation, l’autorité et les devoirs '
        'citoyens des jeunes.',
  ),
  Question(
    id: 'q063',
    text:
        'L’encadrement des loyers est un bon levier pour rendre le logement '
        'plus accessible.',
    category: 'property',
    tags: ['logement', 'loyers'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.5),
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.2),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.7),
      QuestionImpact(currentId: 'liberalisme', weight: -1.3),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.8),
    ],
    source: 'Vie publique · Politique du logement',
    explanation:
        'Met en tension le droit au logement et la liberté de fixer les '
        'prix du marché locatif.',
  ),
  Question(
    id: 'q064',
    text: 'La France devrait relocaliser davantage d’industries.',
    category: 'globalization',
    tags: ['industrie', 'souverainete'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'souverainisme', weight: 1.7),
      QuestionImpact(currentId: 'gaullisme', weight: 1.4),
      QuestionImpact(currentId: 'nationalisme', weight: 1.2),
      QuestionImpact(currentId: 'socialisme', weight: 0.8),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.6),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.6),
      QuestionImpact(currentId: 'liberalisme', weight: -1.2),
    ],
    source: 'Vie publique · Politique industrielle',
    explanation:
        'Souveraineté productive versus gains du commerce international '
        'et des chaînes mondiales.',
  ),
  Question(
    id: 'q065',
    text:
        'L’université publique devrait rester gratuite pour les étudiants, '
        'y compris en master.',
    category: 'education',
    tags: ['universite', 'gratuité'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.5),
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'social_democratie', weight: 1.1),
      QuestionImpact(currentId: 'republicanisme', weight: 0.8),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.2),
      QuestionImpact(currentId: 'conservatisme', weight: -0.6),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.4),
    ],
    source: 'Vie publique · Enseignement supérieur',
    explanation:
        'Le financement des études oppose égalité d’accès et logique de '
        'contribution individuelle.',
  ),
  Question(
    id: 'q066',
    text:
        'Les dépassements d’honoraires médicaux devraient être fortement '
        'limités.',
    category: 'health',
    tags: ['sante', 'acces'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'social_democratie', weight: 1.6),
      QuestionImpact(currentId: 'socialisme', weight: 1.5),
      QuestionImpact(currentId: 'progressisme', weight: 1.2),
      QuestionImpact(currentId: 'communisme', weight: 1.1),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.4),
      QuestionImpact(currentId: 'liberalisme', weight: -1.0),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.5),
    ],
    source: 'Vie publique · Assurance maladie',
    explanation:
        'Concerne l’égalité d’accès aux soins face à la liberté tarifaire '
        'des praticiens.',
  ),
  Question(
    id: 'q067',
    text:
        'Les régions devraient piloter davantage de politiques aujourd’hui '
        'décidées à Paris.',
    category: 'decentralization',
    tags: ['regions', 'etat'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.1),
      QuestionImpact(currentId: 'democratie_chretienne', weight: 1.0),
      QuestionImpact(currentId: 'anarchisme', weight: 1.0),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.6),
      QuestionImpact(currentId: 'gaullisme', weight: -1.2),
      QuestionImpact(currentId: 'republicanisme', weight: -0.7),
      QuestionImpact(currentId: 'nationalisme', weight: -0.5),
    ],
    source: 'Vie publique · Décentralisation',
    explanation:
        'Le partage des compétences entre l’État et les collectivités est '
        'un clivage institutionnel classique.',
  ),
  Question(
    id: 'q068',
    text: 'Le budget de la défense devrait augmenter.',
    category: 'defense',
    tags: ['armee', 'budget'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'gaullisme', weight: 1.6),
      QuestionImpact(currentId: 'conservatisme', weight: 1.3),
      QuestionImpact(currentId: 'nationalisme', weight: 1.4),
      QuestionImpact(currentId: 'souverainisme', weight: 1.2),
      QuestionImpact(currentId: 'republicanisme', weight: 0.7),
      QuestionImpact(currentId: 'ecologie_politique', weight: -0.8),
      QuestionImpact(currentId: 'anticapitalisme', weight: -1.0),
      QuestionImpact(currentId: 'anarchisme', weight: -1.3),
    ],
    source: 'Vie publique · Défense nationale',
    explanation:
        'Effort de défense et souveraineté militaire : faut-il y consacrer '
        'davantage de moyens ?',
  ),
  Question(
    id: 'q069',
    text: 'La France devrait augmenter son aide publique au développement.',
    category: 'international',
    tags: ['aide', 'solidarite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.5),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.3),
      QuestionImpact(currentId: 'social_democratie', weight: 1.1),
      QuestionImpact(currentId: 'democratie_chretienne', weight: 0.9),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.3),
      QuestionImpact(currentId: 'nationalisme', weight: -1.4),
      QuestionImpact(currentId: 'souverainisme', weight: -0.8),
    ],
    source: 'Vie publique · Aide au développement',
    explanation:
        'Oppose solidarité internationale et priorité donnée aux dépenses '
        'nationales.',
  ),
  Question(
    id: 'q070',
    text:
        'L’État doit continuer à soutenir fortement la création culturelle '
        'par des subventions.',
    category: 'culture',
    tags: ['culture', 'subventions'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'social_democratie', weight: 1.1),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.8),
      QuestionImpact(currentId: 'republicanisme', weight: 0.7),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.3),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.5),
      QuestionImpact(currentId: 'conservatisme', weight: -0.4),
    ],
    source: 'Vie publique · Politique culturelle',
    explanation:
        'L’« exception culturelle » française oppose soutien public et '
        'logique de marché.',
  ),
  Question(
    id: 'q071',
    text:
        'La justice pénale devrait privilégier la réinsertion plutôt que '
        'l’allongement des peines.',
    category: 'justice',
    tags: ['peines', 'reinsertion'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.5),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.1),
      QuestionImpact(currentId: 'socialisme', weight: 1.0),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 0.8),
      QuestionImpact(currentId: 'conservatisme', weight: -1.4),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.6),
      QuestionImpact(currentId: 'gaullisme', weight: -0.8),
    ],
    source: 'Vie publique · Politique pénale',
    explanation:
        'Deux approches classiques : dissuasion par la sanction, ou '
        'prévention de la récidive par la réinsertion.',
  ),
  Question(
    id: 'q072',
    text:
        'S’intégrer en France, c’est d’abord adopter les normes culturelles '
        'majoritaires.',
    category: 'integration',
    tags: ['assimilation', 'identite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.5),
      QuestionImpact(currentId: 'national_conservatisme', weight: 1.6),
      QuestionImpact(currentId: 'conservatisme_social', weight: 1.3),
      QuestionImpact(currentId: 'gaullisme', weight: 1.0),
      QuestionImpact(currentId: 'nationalisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: -1.4),
      QuestionImpact(currentId: 'ecologie_politique', weight: -1.1),
      QuestionImpact(currentId: 'liberalisme_politique', weight: -0.8),
    ],
    source: 'Vie publique · Intégration et laïcité',
    explanation:
        'Distingue un modèle d’assimilation républicaine d’approches plus '
        'pluralistes du vivre-ensemble.',
  ),
  Question(
    id: 'q073',
    text:
        'La France devrait refuser les accords commerciaux qui fragilisent '
        'ses agriculteurs.',
    category: 'agriculture',
    tags: ['souverainete', 'alimentation'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'souverainisme', weight: 1.7),
      QuestionImpact(currentId: 'gaullisme', weight: 1.2),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
      QuestionImpact(currentId: 'nationalisme', weight: 1.1),
      QuestionImpact(currentId: 'conservatisme', weight: 0.7),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.5),
      QuestionImpact(currentId: 'liberalisme', weight: -1.1),
    ],
    source: 'Vie publique · Politique agricole',
    explanation:
        'Protection des filières agricoles versus ouverture des marchés '
        'par les traités commerciaux.',
  ),
  Question(
    id: 'q074',
    text: 'L’âge légal de départ à la retraite devrait être abaissé.',
    category: 'social_protection',
    tags: ['retraites'],
    difficulty: QuestionDifficulty.intro,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.6),
      QuestionImpact(currentId: 'communisme', weight: 1.7),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 0.9),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.6),
      QuestionImpact(currentId: 'conservatisme', weight: -1.2),
      QuestionImpact(currentId: 'gaullisme', weight: -0.7),
    ],
    source: 'Vie publique · Réforme des retraites',
    explanation:
        'Le calendrier des retraites oppose droits sociaux, équilibre '
        'démographique et finances publiques.',
  ),
  Question(
    id: 'q075',
    text:
        'Le président de la République a trop de pouvoirs : il faudrait '
        'les réduire.',
    category: 'institutions',
    tags: ['president', 've_republique'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.2),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.1),
      QuestionImpact(currentId: 'radicalisme', weight: 1.3),
      QuestionImpact(currentId: 'socialisme', weight: 0.8),
      QuestionImpact(currentId: 'anarchisme', weight: 1.0),
      QuestionImpact(currentId: 'gaullisme', weight: -1.8),
      QuestionImpact(currentId: 'conservatisme', weight: -1.0),
      QuestionImpact(currentId: 'republicanisme', weight: -0.5),
    ],
    source: 'Vie publique · Institutions de la Ve République',
    explanation:
        'Débat classique sur le présidentialisme français et le rôle du '
        'Parlement.',
  ),
  Question(
    id: 'q076',
    text:
        'La dette publique n’est pas un problème tant qu’elle finance '
        'l’investissement utile.',
    category: 'economy',
    tags: ['dette', 'investissement'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 1.2),
      QuestionImpact(currentId: 'social_democratie', weight: 1.0),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.8),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.8),
      QuestionImpact(currentId: 'conservatisme', weight: -1.4),
      QuestionImpact(currentId: 'gaullisme', weight: -0.6),
    ],
    source: 'Vie publique · Finances publiques',
    explanation:
        'Oppose relance par l’investissement public et orthodoxie '
        'budgétaire.',
  ),
  Question(
    id: 'q077',
    text:
        'La France doit d’abord décider seule de sa politique étrangère, '
        'y compris vis-à-vis de ses alliés.',
    category: 'foreign_policy',
    tags: ['diplomatie', 'autonomie'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'gaullisme', weight: 1.8),
      QuestionImpact(currentId: 'souverainisme', weight: 1.7),
      QuestionImpact(currentId: 'nationalisme', weight: 1.3),
      QuestionImpact(currentId: 'anticapitalisme', weight: 0.6),
      QuestionImpact(currentId: 'liberalisme', weight: -1.1),
      QuestionImpact(currentId: 'progressisme', weight: -0.7),
      QuestionImpact(currentId: 'liberalisme_politique', weight: -0.8),
    ],
    source: 'Vie publique · Politique étrangère',
    explanation:
        'Autonomie stratégique française versus ancrage dans les alliances.',
  ),
  Question(
    id: 'q078',
    text: 'Les héritages importants devraient être davantage taxés.',
    category: 'taxation',
    tags: ['heritage', 'fiscalite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.7),
      QuestionImpact(currentId: 'progressisme', weight: 1.4),
      QuestionImpact(currentId: 'social_democratie', weight: 1.2),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.3),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.7),
      QuestionImpact(currentId: 'conservatisme', weight: -1.5),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.8),
    ],
    source: 'Vie publique · Fiscalité du patrimoine',
    explanation:
        'Le débat sur les droits de succession oppose égalité des chances '
        'et transmission familiale.',
  ),
  Question(
    id: 'q079',
    text:
        'Les grandes entreprises du numérique devraient être plus '
        'strictement régulées en France et en Europe.',
    category: 'digital',
    tags: ['gafa', 'regulation'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.1),
      QuestionImpact(currentId: 'souverainisme', weight: 1.0),
      QuestionImpact(currentId: 'social_democratie', weight: 1.0),
      QuestionImpact(currentId: 'gaullisme', weight: 0.7),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.4),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.7),
    ],
    source: 'CNIL / Commission européenne · Régulation du numérique',
    explanation:
        'Concerne le pouvoir des plateformes, les données personnelles et '
        'la concurrence.',
  ),
  Question(
    id: 'q080',
    text:
        'Nucléaire et renouvelables doivent coexister longtemps pour '
        'décarboner l’électricité.',
    category: 'energy',
    tags: ['mix', 'decarbonation'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'gaullisme', weight: 1.3),
      QuestionImpact(currentId: 'republicanisme', weight: 0.9),
      QuestionImpact(currentId: 'liberalisme', weight: 0.6),
      QuestionImpact(currentId: 'souverainisme', weight: 0.8),
      QuestionImpact(currentId: 'ecologie_politique', weight: -1.0),
      QuestionImpact(currentId: 'progressisme', weight: -0.3),
      QuestionImpact(currentId: 'anticapitalisme', weight: -0.4),
    ],
    source: 'ADEME / Vie publique · Mix énergétique',
    explanation:
        'Le mix électrique français oppose sortie du nucléaire et maintien '
        'd’une énergie bas carbone pilotable.',
  ),
  Question(
    id: 'q081',
    text:
        'Les occupations illégales de logements devraient être évacuées '
        'plus rapidement.',
    category: 'property',
    tags: ['logement', 'propriete'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'conservatisme', weight: 1.5),
      QuestionImpact(currentId: 'liberalisme_economique', weight: 1.3),
      QuestionImpact(currentId: 'national_conservatisme', weight: 1.2),
      QuestionImpact(currentId: 'gaullisme', weight: 0.8),
      QuestionImpact(currentId: 'libertarianisme', weight: 1.1),
      QuestionImpact(currentId: 'anticapitalisme', weight: -1.6),
      QuestionImpact(currentId: 'anarchisme', weight: -1.5),
      QuestionImpact(currentId: 'socialisme', weight: -1.1),
    ],
    source: 'Vie publique · Droit au logement / propriété',
    explanation:
        'Met en tension le droit de propriété et le droit au logement en '
        'période de crise.',
  ),
  Question(
    id: 'q082',
    text:
        'Le droit du sol doit rester un principe fort de la nationalité '
        'française.',
    category: 'immigration',
    tags: ['nationalite', 'droit_du_sol'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'radicalisme', weight: 1.1),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.0),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.7),
      QuestionImpact(currentId: 'nationalisme', weight: -1.8),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.1),
    ],
    source: 'Vie publique · Nationalité',
    explanation:
        'Le droit du sol et le droit du sang structurent le débat sur '
        'l’accès à la nationalité.',
  ),
  Question(
    id: 'q083',
    text:
        'Les entreprises françaises ont trop de contraintes sociales et '
        'environnementales.',
    category: 'enterprise',
    tags: ['normes', 'competitivite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_economique', weight: 1.8),
      QuestionImpact(currentId: 'liberalisme', weight: 1.4),
      QuestionImpact(currentId: 'conservatisme', weight: 1.0),
      QuestionImpact(currentId: 'libertarianisme', weight: 1.6),
      QuestionImpact(currentId: 'ecologie_politique', weight: -1.7),
      QuestionImpact(currentId: 'socialisme', weight: -1.4),
      QuestionImpact(currentId: 'progressisme', weight: -1.2),
    ],
    source: 'Vie publique · Droit des entreprises',
    explanation:
        'Arbitre entre compétitivité, protection des salariés et normes '
        'environnementales.',
  ),
  Question(
    id: 'q084',
    text: 'La semaine de quatre jours devrait devenir la norme.',
    category: 'work',
    tags: ['temps_de_travail'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.6),
      QuestionImpact(currentId: 'communisme', weight: 1.5),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.2),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 1.0),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.7),
      QuestionImpact(currentId: 'conservatisme', weight: -1.2),
    ],
    source: 'Vie publique · Durée du travail',
    explanation:
        'Quatre jours travaillés : organisation du travail, emploi et '
        'temps libre, au-delà de la durée légale actuelle.',
  ),
  Question(
    id: 'q085',
    text: 'La France devrait quitter le commandement intégré de l’OTAN.',
    category: 'defense',
    tags: ['otan', 'alliances'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'souverainisme', weight: 1.8),
      QuestionImpact(currentId: 'gaullisme', weight: 1.4),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.2),
      QuestionImpact(currentId: 'communisme', weight: 1.3),
      QuestionImpact(currentId: 'nationalisme', weight: 1.0),
      QuestionImpact(currentId: 'liberalisme', weight: -1.4),
      QuestionImpact(currentId: 'progressisme', weight: -0.8),
      QuestionImpact(currentId: 'conservatisme', weight: -0.9),
    ],
    source: 'Vie publique · OTAN et défense',
    explanation:
        'Autonomie militaire française versus ancrage dans l’Alliance '
        'atlantique.',
  ),
  Question(
    id: 'q086',
    text:
        'Les statistiques ethniques devraient rester interdites dans les '
        'fichiers publics.',
    category: 'society',
    tags: ['statistiques', 'republique'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.7),
      QuestionImpact(currentId: 'radicalisme', weight: 1.2),
      QuestionImpact(currentId: 'gaullisme', weight: 0.8),
      QuestionImpact(currentId: 'progressisme', weight: -0.9),
      QuestionImpact(currentId: 'ecologie_politique', weight: -0.7),
      QuestionImpact(currentId: 'liberalisme_politique', weight: -0.4),
    ],
    source: 'CNIL / Vie publique · Statistiques et discrimination',
    explanation:
        'Le modèle républicain d’indistinction s’oppose à des outils de '
        'mesure des discriminations.',
  ),
  Question(
    id: 'q087',
    text:
        'Le droit à l’interruption volontaire de grossesse ne doit pas '
        'être remis en cause.',
    category: 'society',
    tags: ['ivg', 'droits'],
    difficulty: QuestionDifficulty.intro,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.8),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.5),
      QuestionImpact(currentId: 'radicalisme', weight: 1.4),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.2),
      QuestionImpact(currentId: 'socialisme', weight: 1.0),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.6),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -1.3),
    ],
    source: 'Vie publique · Droits des femmes',
    explanation:
        'L’IVG est un droit inscrit dans le débat public français, encore '
        'discuté sur son étendue.',
  ),
  Question(
    id: 'q088',
    text:
        'Les retraites par répartition doivent rester le pilier du '
        'système, plutôt que la capitalisation.',
    category: 'social_protection',
    tags: ['retraites', 'repartition'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'social_democratie', weight: 1.7),
      QuestionImpact(currentId: 'socialisme', weight: 1.6),
      QuestionImpact(currentId: 'communisme', weight: 1.4),
      QuestionImpact(currentId: 'gaullisme', weight: 0.6),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.6),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.7),
      QuestionImpact(currentId: 'liberalisme', weight: -1.1),
    ],
    source: 'Vie publique · Systèmes de retraite',
    explanation:
        'Répartition solidaire versus épargne individuelle : deux modèles '
        'de protection vieillesse.',
  ),
  Question(
    id: 'q089',
    text:
        'Un impôt européen commun serait acceptable pour financer des '
        'politiques partagées.',
    category: 'europe',
    tags: ['ue', 'fiscalite'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.1),
      QuestionImpact(currentId: 'social_democratie', weight: 1.0),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.9),
      QuestionImpact(currentId: 'souverainisme', weight: -2.0),
      QuestionImpact(currentId: 'nationalisme', weight: -1.8),
      QuestionImpact(currentId: 'gaullisme', weight: -1.4),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.6),
    ],
    source: 'Vie publique · Budget de l’Union européenne',
    explanation:
        'Une ressource fiscale propre à l’UE touche au cœur du partage de '
        'souveraineté.',
  ),
  Question(
    id: 'q090',
    text:
        'La police devrait être davantage contrôlée par des autorités '
        'indépendantes.',
    category: 'security',
    tags: ['police', 'controle'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'progressisme', weight: 1.5),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.3),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.2),
      QuestionImpact(currentId: 'anarchisme', weight: 1.1),
      QuestionImpact(currentId: 'radicalisme', weight: 1.0),
      QuestionImpact(currentId: 'conservatisme', weight: -1.3),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.4),
      QuestionImpact(currentId: 'gaullisme', weight: -0.9),
    ],
    source: 'Défenseur des droits / Vie publique · Police',
    explanation:
        'L’équilibre entre efficacité policière et contrôle démocratique '
        'des forces de l’ordre.',
  ),
  Question(
    id: 'q091',
    text:
        'Les nouvelles techniques agricoles, y compris certains OGM, '
        'devraient être davantage autorisées si elles réduisent les pesticides.',
    category: 'agriculture',
    tags: ['ogm', 'innovation'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_economique', weight: 1.3),
      QuestionImpact(currentId: 'liberalisme', weight: 1.1),
      QuestionImpact(currentId: 'progressisme', weight: 0.4),
      QuestionImpact(currentId: 'ecologie_politique', weight: -1.6),
      QuestionImpact(currentId: 'anticapitalisme', weight: -1.2),
      QuestionImpact(currentId: 'conservatisme_social', weight: -0.5),
    ],
    source: 'Vie publique · Biotechnologies agricoles',
    explanation:
        'Innovation agronomique versus principe de précaution et modèle '
        'agricole.',
  ),
  Question(
    id: 'q092',
    text:
        'Le secret des correspondances numériques doit primer sur les '
        'besoins d’enquête, sauf exception très encadrée.',
    category: 'civil_liberties',
    tags: ['vie_privee', 'numerique'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.7),
      QuestionImpact(currentId: 'libertarianisme', weight: 1.8),
      QuestionImpact(currentId: 'anarchisme', weight: 1.4),
      QuestionImpact(currentId: 'progressisme', weight: 1.0),
      QuestionImpact(currentId: 'conservatisme', weight: -1.2),
      QuestionImpact(currentId: 'gaullisme', weight: -1.0),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.3),
    ],
    source: 'CNIL · Libertés numériques',
    explanation:
        'Vie privée, chiffrement et pouvoirs d’enquête : un clivage '
        'libertés / sécurité.',
  ),
  Question(
    id: 'q093',
    text:
        'L’État devrait pouvoir nationaliser des entreprises stratégiques '
        'en difficulté.',
    category: 'economy',
    tags: ['nationalisation', 'strategie'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'socialisme', weight: 1.7),
      QuestionImpact(currentId: 'communisme', weight: 1.8),
      QuestionImpact(currentId: 'gaullisme', weight: 1.1),
      QuestionImpact(currentId: 'souverainisme', weight: 1.0),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.5),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.9),
      QuestionImpact(currentId: 'libertarianisme', weight: -2.0),
      QuestionImpact(currentId: 'liberalisme', weight: -1.4),
    ],
    source: 'Vie publique · Entreprises publiques',
    explanation:
        'Rôle de l’État actionnaire face au marché dans les secteurs '
        'jugés stratégiques.',
  ),
  Question(
    id: 'q094',
    text:
        'Les maires devraient avoir plus de pouvoir sur l’urbanisme et le '
        'logement social.',
    category: 'decentralization',
    tags: ['maires', 'urbanisme'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'conservatisme', weight: 0.8),
      QuestionImpact(currentId: 'democratie_chretienne', weight: 1.0),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 0.7),
      QuestionImpact(currentId: 'gaullisme', weight: -0.6),
      QuestionImpact(currentId: 'republicanisme', weight: -0.4),
      QuestionImpact(currentId: 'progressisme', weight: 0.3),
    ],
    source: 'Vie publique · Urbanisme et communes',
    explanation:
        'Autonomie des maires versus règles nationales d’urbanisme et de '
        'mixité.',
  ),
  Question(
    id: 'q095',
    text:
        'La France devrait accueillir davantage de personnes fuyant les '
        'dérèglements climatiques.',
    category: 'immigration',
    tags: ['climat', 'asile'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.8),
      QuestionImpact(currentId: 'progressisme', weight: 1.4),
      QuestionImpact(currentId: 'social_democratie', weight: 0.8),
      QuestionImpact(currentId: 'democratie_chretienne', weight: 0.6),
      QuestionImpact(currentId: 'national_conservatisme', weight: -1.7),
      QuestionImpact(currentId: 'nationalisme', weight: -1.8),
      QuestionImpact(currentId: 'souverainisme', weight: -1.2),
    ],
    source: 'Vie publique · Migrations et climat',
    explanation:
        'Le statut des « réfugiés climatiques » n’est pas stabilisé ; le '
        'débat porte sur l’accueil et le droit d’asile.',
  ),
  Question(
    id: 'q096',
    text:
        'L’école privée sous contrat devrait être moins financée par '
        'l’argent public.',
    category: 'education',
    tags: ['ecole', 'laicite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.3),
      QuestionImpact(currentId: 'radicalisme', weight: 1.5),
      QuestionImpact(currentId: 'socialisme', weight: 1.1),
      QuestionImpact(currentId: 'progressisme', weight: 0.7),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -1.8),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.5),
      QuestionImpact(currentId: 'liberalisme', weight: -0.8),
    ],
    source: 'Vie publique · École publique et privée',
    explanation:
        'Le financement public de l’enseignement privé sous contrat est un '
        'clivage scolaire ancien.',
  ),
  Question(
    id: 'q097',
    text: 'Le cannabis devrait être légalisé et régulé par l’État.',
    category: 'civil_liberties',
    tags: ['cannabis', 'libertes'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_politique', weight: 1.6),
      QuestionImpact(currentId: 'libertarianisme', weight: 1.7),
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
      QuestionImpact(currentId: 'anarchisme', weight: 1.1),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.6),
      QuestionImpact(currentId: 'conservatisme', weight: -1.4),
      QuestionImpact(currentId: 'gaullisme', weight: -0.9),
    ],
    source: 'Vie publique · Politique des drogues',
    explanation:
        'Légalisation régulée versus prohibition : santé publique, libertés '
        'et ordre public.',
  ),
  Question(
    id: 'q098',
    text:
        'Les partenariats public-privé sont en général plus efficaces que '
        'la gestion 100 % publique.',
    category: 'public_services',
    tags: ['ppp', 'gestion'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'liberalisme_economique', weight: 1.7),
      QuestionImpact(currentId: 'liberalisme', weight: 1.4),
      QuestionImpact(currentId: 'conservatisme', weight: 0.9),
      QuestionImpact(currentId: 'socialisme', weight: -1.5),
      QuestionImpact(currentId: 'communisme', weight: -1.7),
      QuestionImpact(currentId: 'anticapitalisme', weight: -1.6),
      QuestionImpact(currentId: 'social_democratie', weight: -0.6),
    ],
    source: 'Vie publique · Commande publique',
    explanation:
        'Mode de gestion des services publics : délégation au privé ou '
        'maîtrise publique.',
  ),
  Question(
    id: 'q099',
    text: 'Le vote blanc devrait être reconnu comme un suffrage exprimé.',
    category: 'democracy',
    tags: ['vote', 'blanc'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'radicalisme', weight: 1.3),
      QuestionImpact(currentId: 'progressisme', weight: 0.9),
      QuestionImpact(currentId: 'souverainisme', weight: 0.8),
      QuestionImpact(currentId: 'anarchisme', weight: 0.7),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.6),
      QuestionImpact(currentId: 'conservatisme', weight: -0.5),
      QuestionImpact(currentId: 'gaullisme', weight: -0.4),
    ],
    source: 'Vie publique · Mode de scrutin',
    explanation:
        'Reconnaître le vote blanc changerait le calcul des majorités et '
        'le message envoyé aux élus.',
  ),
  Question(
    id: 'q100',
    text:
        'L’hôpital public doit rester un lieu strictement laïque, y '
        'compris dans l’accompagnement des patients.',
    category: 'religion_laicity',
    tags: ['hopital', 'laicite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.8),
      QuestionImpact(currentId: 'radicalisme', weight: 1.5),
      QuestionImpact(currentId: 'gaullisme', weight: 0.9),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 0.4),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -1.2),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.0),
    ],
    source: 'Vie publique · Laïcité dans les services publics',
    explanation:
        'Application de la laïcité dans le soin : neutralité du service et '
        'liberté de conscience des patients.',
  ),
  Question(
    id: 'q101',
    text:
        'Le port de signes religieux ostensibles devrait rester interdit '
        'au collège et au lycée publics.',
    category: 'religion_laicity',
    tags: ['laicite', 'ecole'],
    difficulty: QuestionDifficulty.intro,
    impacts: [
      QuestionImpact(currentId: 'republicanisme', weight: 1.7),
      QuestionImpact(currentId: 'radicalisme', weight: 1.8),
      QuestionImpact(currentId: 'gaullisme', weight: 0.8),
      QuestionImpact(currentId: 'liberalisme_politique', weight: -0.6),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -1.2),
      QuestionImpact(currentId: 'conservatisme_social', weight: -1.0),
      QuestionImpact(currentId: 'progressisme', weight: -0.4),
    ],
    source: 'Vie publique · Laïcité à l’école',
    explanation:
        'La loi de 2004 sur les signes religieux à l’école publique reste '
        'un clivage sur la laïcité scolaire.',
  ),
  Question(
    id: 'q102',
    text: 'L’école devrait noter davantage au mérite.',
    category: 'education',
    tags: ['ecole', 'merite'],
    difficulty: QuestionDifficulty.intro,
    impacts: [
      QuestionImpact(currentId: 'liberalisme', weight: 1.4),
      QuestionImpact(currentId: 'republicanisme', weight: 1.2),
      QuestionImpact(currentId: 'conservatisme', weight: 1.1),
      QuestionImpact(currentId: 'gaullisme', weight: 0.8),
      QuestionImpact(currentId: 'progressisme', weight: -1.2),
      QuestionImpact(currentId: 'ecologie_politique', weight: -0.8),
      QuestionImpact(currentId: 'anarchisme', weight: -1.0),
    ],
    source: 'Vie publique · Évaluation scolaire',
    explanation:
        'Notes, classements et mérite scolaire versus d’autres façons '
        'd’évaluer pour limiter la compétition entre élèves.',
  ),
  Question(
    id: 'q103',
    text:
        'Les médias d’information devraient être davantage protégés de '
        'la concentration économique.',
    category: 'culture',
    tags: ['medias', 'concentration'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'radicalisme', weight: 1.5),
      QuestionImpact(currentId: 'progressisme', weight: 1.3),
      QuestionImpact(currentId: 'anarchisme', weight: 1.2),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
      QuestionImpact(currentId: 'socialisme', weight: 0.9),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.5),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.4),
    ],
    source: 'Vie publique · Pluralisme des médias',
    explanation:
        'Indépendance de l’information versus propriété des groupes '
        'privés et des plateformes.',
  ),
  Question(
    id: 'q104',
    text:
        'La solidarité passe d’abord par la famille et les associations, '
        'avant l’État.',
    category: 'social_protection',
    tags: ['solidarite', 'subsidiarite'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'democratie_chretienne', weight: 1.9),
      QuestionImpact(currentId: 'conservatisme_social', weight: 1.5),
      QuestionImpact(currentId: 'conservatisme', weight: 1.1),
      QuestionImpact(currentId: 'libertarianisme', weight: 0.9),
      QuestionImpact(currentId: 'socialisme', weight: -1.5),
      QuestionImpact(currentId: 'communisme', weight: -1.6),
      QuestionImpact(currentId: 'social_democratie', weight: -1.1),
    ],
    source: 'Vie publique · Protection sociale',
    explanation:
        'Principe de subsidiarité : l’aide de proximité d’abord, l’État '
        'ensuite — un marqueur démocrate-chrétien.',
  ),
  Question(
    id: 'q105',
    text:
        'Beaucoup d’organisations (école, entreprise, quartier) pourraient '
        'fonctionner sans chef hiérarchique.',
    category: 'authority',
    tags: ['hierarchie', 'autogestion'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'anarchisme', weight: 2.0),
      QuestionImpact(currentId: 'anticapitalisme', weight: 1.3),
      QuestionImpact(currentId: 'radicalisme', weight: 0.8),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.6),
      QuestionImpact(currentId: 'gaullisme', weight: -1.5),
      QuestionImpact(currentId: 'conservatisme', weight: -1.4),
      QuestionImpact(currentId: 'republicanisme', weight: -1.0),
    ],
    source: 'Vie publique · Autogestion et démocratie',
    explanation:
        'Autogestion versus autorité : qui décide dans les collectifs, '
        'et faut-il un chef ?',
  ),
  Question(
    id: 'q106',
    text: 'Le dimanche doit rester un jour largement chômé.',
    category: 'family',
    tags: ['dimanche', 'famille'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'democratie_chretienne', weight: 1.8),
      QuestionImpact(currentId: 'conservatisme_social', weight: 1.6),
      QuestionImpact(currentId: 'conservatisme', weight: 1.0),
      QuestionImpact(currentId: 'socialisme', weight: 0.5),
      QuestionImpact(currentId: 'liberalisme_economique', weight: -1.6),
      QuestionImpact(currentId: 'libertarianisme', weight: -1.5),
      QuestionImpact(currentId: 'liberalisme', weight: -1.1),
    ],
    source: 'Vie publique · Travail du dimanche',
    explanation:
        'Repos dominical, vie familiale et commerces : un débat ancien '
        'sur le temps collectif.',
  ),
  Question(
    id: 'q107',
    text: 'Le Sénat devrait être profondément réformé, voire supprimé.',
    category: 'institutions',
    tags: ['senat', 'institutions'],
    difficulty: QuestionDifficulty.advanced,
    impacts: [
      QuestionImpact(currentId: 'radicalisme', weight: 1.7),
      QuestionImpact(currentId: 'progressisme', weight: 1.1),
      QuestionImpact(currentId: 'anarchisme', weight: 1.0),
      QuestionImpact(currentId: 'ecologie_politique', weight: 0.7),
      QuestionImpact(currentId: 'conservatisme', weight: -1.3),
      QuestionImpact(currentId: 'gaullisme', weight: -1.2),
      QuestionImpact(currentId: 'democratie_chretienne', weight: -0.6),
    ],
    source: 'Vie publique · Sénat',
    explanation:
        'Le Sénat, chambre des territoires, est régulièrement accusé '
        'd’être un frein ou un contre-pouvoir utile.',
  ),
  Question(
    id: 'q108',
    text:
        'Les communes devraient pouvoir expérimenter des services gérés '
        'par les habitants, sans tutelle de l’État.',
    category: 'decentralization',
    tags: ['communes', 'autogestion'],
    difficulty: QuestionDifficulty.standard,
    impacts: [
      QuestionImpact(currentId: 'anarchisme', weight: 1.7),
      QuestionImpact(currentId: 'democratie_chretienne', weight: 1.2),
      QuestionImpact(currentId: 'ecologie_politique', weight: 1.0),
      QuestionImpact(currentId: 'liberalisme_politique', weight: 0.8),
      QuestionImpact(currentId: 'gaullisme', weight: -1.3),
      QuestionImpact(currentId: 'republicanisme', weight: -0.9),
      QuestionImpact(currentId: 'nationalisme', weight: -0.6),
    ],
    source: 'Vie publique · Décentralisation',
    explanation:
        'Services de proximité gérés localement versus règles nationales '
        'et tutelle de l’État.',
  ),
];
