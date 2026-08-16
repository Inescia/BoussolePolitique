import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../core/widgets/page_header.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 88),
          children: [
            const PageHeader(
              title: 'Réglages',
              subtitle: 'Préférences, informations et données locales.',
              showBack: false,
            ),
            const SizedBox(height: 16),
            SoftCard(
              onTap: () => context.push('/onboarding?replay=1'),
              semanticLabel: 'Revoir l’intro',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _SettingsIcon(
                  icon: Icons.swipe_rounded,
                  color: AppColors.electricBlue,
                ),
                title: Text('Revoir l’intro'),
                subtitle: Text('Gestes de swipe et principes de l’app.'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: 12),
            SoftCard(
              onTap: () => context.push('/privacy'),
              semanticLabel: 'Vie privée',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _SettingsIcon(
                  icon: Icons.lock_outline_rounded,
                  color: AppColors.coral,
                ),
                title: Text('Vie privée'),
                subtitle: Text('Ce qui est stocké sur ton téléphone.'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: 12),
            SoftCard(
              onTap: () => context.push('/about'),
              semanticLabel: 'À propos',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _SettingsIcon(
                  icon: Icons.info_outline_rounded,
                  color: AppColors.deepBlue,
                ),
                title: Text('À propos'),
                subtitle: Text('Le projet et comment le profil est calculé.'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: 12),
            SoftCard(
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const _SettingsIcon(
                      icon: Icons.vibration_rounded,
                      color: AppColors.success,
                    ),
                    title: const Text('Retours haptiques'),
                    subtitle: const Text(
                      'Vibrations légères au swipe et à la validation.',
                    ),
                    value: state.hapticsEnabled,
                    onChanged: (_) => context.read<SettingsBloc>().add(
                      const HapticsToggled(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}
