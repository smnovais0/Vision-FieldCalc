import 'package:flutter/material.dart';

import 'l10n/app_text.dart';
import 'solver_workspace.dart';
import 'vision_theme.dart';

class AdvancedSolverPage extends StatelessWidget {
  final String menu;
  const AdvancedSolverPage({super.key, this.menu = 'Limites e cálculo'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisionTheme.canvas,
      appBar: AppBar(title: Text(AppScope.of(context).text.advancedTitle)),
      body: Padding(
        padding: const EdgeInsets.all(VisionTheme.space20),
        child: SolverWorkspace(menu: menu),
      ),
    );
  }
}
