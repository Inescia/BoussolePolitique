part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class HapticsToggled extends SettingsEvent {
  const HapticsToggled();
}

final class OnboardingCompleted extends SettingsEvent {
  const OnboardingCompleted();
}
