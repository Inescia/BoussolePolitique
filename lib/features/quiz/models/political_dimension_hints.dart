import 'political_dimension.dart';

/// Textes de contexte affichés sur les cartes, par dimension.
extension PoliticalDimensionHints on PoliticalDimension {
  String get contextHint => switch (this) {
    PoliticalDimension.economy =>
      'Cette carte porte sur le rôle de l’État et l’organisation de l’économie.',
    PoliticalDimension.taxation =>
      'Cette carte interroge le niveau et la répartition des impôts.',
    PoliticalDimension.redistribution =>
      'Cette carte porte sur les inégalités et la redistribution.',
    PoliticalDimension.work =>
      'Cette carte concerne le travail, l’emploi et les droits sociaux.',
    PoliticalDimension.socialProtection =>
      'Cette carte porte sur la protection sociale et la solidarité.',
    PoliticalDimension.publicServices =>
      'Cette carte touche au rôle et au financement des services publics.',
    PoliticalDimension.enterprise =>
      'Cette carte interroge la place de l’entreprise et de l’initiative privée.',
    PoliticalDimension.property =>
      'Cette carte porte sur la propriété et son encadrement.',
    PoliticalDimension.market =>
      'Cette carte interroge la confiance accordée au marché.',
    PoliticalDimension.civilLiberties =>
      'Cette carte porte sur les libertés individuelles.',
    PoliticalDimension.society =>
      'Cette carte concerne les normes sociales et le vivre-ensemble.',
    PoliticalDimension.family =>
      'Cette carte interroge le rôle de la famille dans la société.',
    PoliticalDimension.religionLaicity =>
      'Cette carte porte sur la laïcité et la place du religieux.',
    PoliticalDimension.immigration =>
      'Cette carte concerne l’accueil et les politiques migratoires.',
    PoliticalDimension.integration =>
      'Cette carte porte sur l’intégration et la cohésion sociale.',
    PoliticalDimension.security =>
      'Cette carte interroge l’équilibre entre sécurité et libertés.',
    PoliticalDimension.justice =>
      'Cette carte porte sur la justice et la réponse pénale.',
    PoliticalDimension.authority =>
      'Cette carte concerne l’autorité, l’ordre et la discipline.',
    PoliticalDimension.institutions =>
      'Cette carte porte sur les institutions et leur fonctionnement.',
    PoliticalDimension.democracy =>
      'Cette carte interroge la participation et le fonctionnement démocratique.',
    PoliticalDimension.decentralization =>
      'Cette carte concerne les territoires et la décentralisation.',
    PoliticalDimension.sovereignty =>
      'Cette carte porte sur la souveraineté nationale et les choix collectifs.',
    PoliticalDimension.europe =>
      'Cette carte interroge la construction européenne et ses compétences.',
    PoliticalDimension.ecology =>
      'Cette carte porte sur l’environnement et les priorités écologiques.',
    PoliticalDimension.climate =>
      'Cette carte concerne le climat et la transition.',
    PoliticalDimension.energy =>
      'Cette carte porte sur les choix énergétiques.',
    PoliticalDimension.agriculture =>
      'Cette carte concerne l’agriculture, l’alimentation et les campagnes.',
    PoliticalDimension.globalization =>
      'Cette carte interroge la mondialisation et ses contreparties.',
    PoliticalDimension.internationalRelations =>
      'Cette carte porte sur la place de la France dans le monde.',
    PoliticalDimension.defense =>
      'Cette carte concerne la défense et la sécurité collective.',
    PoliticalDimension.foreignPolicy =>
      'Cette carte porte sur la diplomatie et la politique étrangère.',
    PoliticalDimension.digital =>
      'Cette carte interroge le numérique, ses libertés et ses régulations.',
    PoliticalDimension.culture =>
      'Cette carte porte sur la culture et son accès.',
    PoliticalDimension.education =>
      'Cette carte concerne l’école, la formation et l’égalité des chances.',
    PoliticalDimension.health =>
      'Cette carte porte sur la santé et l’accès aux soins.',
  };
}
