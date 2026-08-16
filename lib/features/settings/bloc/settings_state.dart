part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    required this.hapticsEnabled,
    required this.onboardingDone,
  });

  final bool hapticsEnabled;
  final bool onboardingDone;

  SettingsState copyWith({bool? hapticsEnabled, bool? onboardingDone}) {
    return SettingsState(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }

  @override
  List<Object?> get props => [hapticsEnabled, onboardingDone];
}
