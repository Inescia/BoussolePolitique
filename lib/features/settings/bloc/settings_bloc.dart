import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../quiz/repositories/progress_repository.dart';
import '../../../core/utils/haptics.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required ProgressRepository progressRepository,
    required AppHaptics haptics,
  }) : _progressRepository = progressRepository,
       _haptics = haptics,
       super(
         SettingsState(
           hapticsEnabled: progressRepository.hapticsEnabled,
           onboardingDone: progressRepository.onboardingDone,
         ),
       ) {
    on<HapticsToggled>(_onHapticsToggled);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  final ProgressRepository _progressRepository;
  final AppHaptics _haptics;

  Future<void> _onHapticsToggled(
    HapticsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final value = !state.hapticsEnabled;
    _haptics.enabled = value;
    await _progressRepository.setHapticsEnabled(value);
    emit(state.copyWith(hapticsEnabled: value));
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<SettingsState> emit,
  ) async {
    await _progressRepository.setOnboardingDone(true);
    emit(state.copyWith(onboardingDone: true));
  }
}
