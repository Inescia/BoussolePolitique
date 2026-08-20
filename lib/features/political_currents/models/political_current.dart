import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContentSource extends Equatable {
  const ContentSource({
    required this.title,
    required this.organization,
    this.url,
    this.accessedAt,
    this.publishedAt,
  });

  final String title;
  final String organization;
  final String? url;
  final DateTime? accessedAt;
  final DateTime? publishedAt;

  factory ContentSource.fromJson(Map<String, dynamic> json) => ContentSource(
    title: json['title'] as String,
    organization: json['organization'] as String,
    url: json['url'] as String?,
    accessedAt: json['accessedAt'] != null
        ? DateTime.parse(json['accessedAt'] as String)
        : null,
    publishedAt: json['publishedAt'] != null
        ? DateTime.parse(json['publishedAt'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'organization': organization,
    'url': url,
    'accessedAt': accessedAt?.toIso8601String(),
    'publishedAt': publishedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    title,
    organization,
    url,
    accessedAt,
    publishedAt,
  ];
}

class FranceExample extends Equatable {
  const FranceExample({
    required this.label,
    required this.context,
    this.period,
  });

  final String label;
  final String context;
  final String? period;

  factory FranceExample.fromJson(Map<String, dynamic> json) => FranceExample(
    label: json['label'] as String,
    context: json['context'] as String,
    period: json['period'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'context': context,
    'period': period,
  };

  @override
  List<Object?> get props => [label, context, period];
}

class PoliticalCurrent extends Equatable {
  const PoliticalCurrent({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.historicalOrigins,
    required this.economicPosition,
    required this.socialPosition,
    required this.institutionalPosition,
    required this.ecologicalPosition,
    required this.europeanPosition,
    required this.civilLibertiesPosition,
    required this.internalNuances,
    required this.relatedCurrents,
    required this.opposedCurrents,
    required this.examplesInFrance,
    required this.lastUpdated,
    required this.sources,
    required this.colorValue,
    required this.hemicycleAngle,
    this.family = 'other',
  });

  final String id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String historicalOrigins;
  final String economicPosition;
  final String socialPosition;
  final String institutionalPosition;
  final String ecologicalPosition;
  final String europeanPosition;
  final String civilLibertiesPosition;
  final String internalNuances;
  final List<String> relatedCurrents;
  final List<String> opposedCurrents;
  final List<FranceExample> examplesInFrance;
  final DateTime lastUpdated;
  final List<ContentSource> sources;
  final int colorValue;

  /// Position angulaire dans l'hémicycle (−1 gauche … +1 droite), métaphore pédagogique.
  final double hemicycleAngle;
  final String family;

  Color get color => Color(colorValue);

  factory PoliticalCurrent.fromJson(
    Map<String, dynamic> json,
  ) => PoliticalCurrent(
    id: json['id'] as String,
    name: json['name'] as String,
    shortDescription: json['shortDescription'] as String,
    longDescription: json['longDescription'] as String,
    historicalOrigins: json['historicalOrigins'] as String,
    economicPosition: json['economicPosition'] as String,
    socialPosition: json['socialPosition'] as String,
    institutionalPosition: json['institutionalPosition'] as String,
    ecologicalPosition: json['ecologicalPosition'] as String,
    europeanPosition: json['europeanPosition'] as String,
    civilLibertiesPosition: json['civilLibertiesPosition'] as String,
    internalNuances: json['internalNuances'] as String,
    relatedCurrents: (json['relatedCurrents'] as List<dynamic>).cast<String>(),
    opposedCurrents: (json['opposedCurrents'] as List<dynamic>).cast<String>(),
    examplesInFrance: (json['examplesInFrance'] as List<dynamic>)
        .map((e) => FranceExample.fromJson(e as Map<String, dynamic>))
        .toList(),
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    sources: (json['sources'] as List<dynamic>)
        .map((e) => ContentSource.fromJson(e as Map<String, dynamic>))
        .toList(),
    colorValue: json['colorValue'] as int,
    hemicycleAngle: (json['hemicycleAngle'] as num).toDouble(),
    family: json['family'] as String? ?? 'other',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'shortDescription': shortDescription,
    'longDescription': longDescription,
    'historicalOrigins': historicalOrigins,
    'economicPosition': economicPosition,
    'socialPosition': socialPosition,
    'institutionalPosition': institutionalPosition,
    'ecologicalPosition': ecologicalPosition,
    'europeanPosition': europeanPosition,
    'civilLibertiesPosition': civilLibertiesPosition,
    'internalNuances': internalNuances,
    'relatedCurrents': relatedCurrents,
    'opposedCurrents': opposedCurrents,
    'examplesInFrance': examplesInFrance.map((e) => e.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'sources': sources.map((e) => e.toJson()).toList(),
    'colorValue': colorValue,
    'hemicycleAngle': hemicycleAngle,
    'family': family,
  };

  @override
  List<Object?> get props => [id, name, lastUpdated];
}
