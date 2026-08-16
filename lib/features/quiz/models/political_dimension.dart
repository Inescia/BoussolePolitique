/// Grandes dimensions politiques couvertes par le quiz.
enum PoliticalDimension {
  economy('Économie', 'economy'),
  taxation('Fiscalité', 'taxation'),
  redistribution('Redistribution', 'redistribution'),
  work('Travail', 'work'),
  socialProtection('Protection sociale', 'social_protection'),
  publicServices('Services publics', 'public_services'),
  enterprise('Entreprise', 'enterprise'),
  property('Propriété', 'property'),
  market('Marché', 'market'),
  civilLiberties('Libertés individuelles', 'civil_liberties'),
  society('Société', 'society'),
  family('Famille', 'family'),
  religionLaicity('Religion et laïcité', 'religion_laicity'),
  immigration('Immigration', 'immigration'),
  integration('Intégration', 'integration'),
  security('Sécurité', 'security'),
  justice('Justice', 'justice'),
  authority('Autorité', 'authority'),
  institutions('Institutions', 'institutions'),
  democracy('Démocratie', 'democracy'),
  decentralization('Décentralisation', 'decentralization'),
  sovereignty('Souveraineté', 'sovereignty'),
  europe('Europe', 'europe'),
  ecology('Écologie', 'ecology'),
  climate('Climat', 'climate'),
  energy('Énergie', 'energy'),
  agriculture('Agriculture', 'agriculture'),
  globalization('Mondialisation', 'globalization'),
  internationalRelations('Relations internationales', 'international'),
  defense('Défense', 'defense'),
  foreignPolicy('Politique étrangère', 'foreign_policy'),
  digital('Numérique', 'digital'),
  culture('Culture', 'culture'),
  education('Éducation', 'education'),
  health('Santé', 'health');

  const PoliticalDimension(this.label, this.id);

  final String label;
  final String id;

  static PoliticalDimension fromId(String id) =>
      PoliticalDimension.values.firstWhere((d) => d.id == id);
}

/// Familles de dimensions pour les visualisations agrégées.
enum DimensionFamily {
  economy('Économie', [
    PoliticalDimension.economy,
    PoliticalDimension.taxation,
    PoliticalDimension.redistribution,
    PoliticalDimension.work,
    PoliticalDimension.socialProtection,
    PoliticalDimension.publicServices,
    PoliticalDimension.enterprise,
    PoliticalDimension.property,
    PoliticalDimension.market,
  ]),
  society('Société', [
    PoliticalDimension.civilLiberties,
    PoliticalDimension.society,
    PoliticalDimension.family,
    PoliticalDimension.religionLaicity,
    PoliticalDimension.immigration,
    PoliticalDimension.integration,
    PoliticalDimension.culture,
    PoliticalDimension.education,
    PoliticalDimension.health,
  ]),
  institutions('Institutions', [
    PoliticalDimension.security,
    PoliticalDimension.justice,
    PoliticalDimension.authority,
    PoliticalDimension.institutions,
    PoliticalDimension.democracy,
    PoliticalDimension.decentralization,
  ]),
  europeSovereignty('Europe & souveraineté', [
    PoliticalDimension.sovereignty,
    PoliticalDimension.europe,
    PoliticalDimension.globalization,
    PoliticalDimension.internationalRelations,
    PoliticalDimension.defense,
    PoliticalDimension.foreignPolicy,
  ]),
  ecology('Écologie', [
    PoliticalDimension.ecology,
    PoliticalDimension.climate,
    PoliticalDimension.energy,
    PoliticalDimension.agriculture,
  ]),
  digital('Numérique', [PoliticalDimension.digital]);

  const DimensionFamily(this.label, this.dimensions);

  final String label;
  final List<PoliticalDimension> dimensions;
}
