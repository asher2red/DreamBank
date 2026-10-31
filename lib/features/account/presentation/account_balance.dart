import 'package:flutter/material.dart';

import '../../../core/utils/currency.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({required this.amount, required this.label, super.key});
  final int amount;
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label ${formatWon(amount)}',
    child: ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final formatted = formatWon(amount);
          var style = Theme.of(context).textTheme.displaySmall!.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: -0.7,
          );
          final scaler = MediaQuery.textScalerOf(context);
          final measure = TextPainter(
            text: TextSpan(text: formatted, style: style),
            textDirection: Directionality.of(context),
            textScaler: scaler,
          )..layout();
          if (scaler.scale(1) <= 1 && measure.width > constraints.maxWidth) {
            style = style.copyWith(
              fontSize:
                  (style.fontSize! * (constraints.maxWidth - 1) / measure.width)
                      .clamp(24.0, 40.0),
            );
          }
          measure.dispose();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              formatted,
              key: const ValueKey('virtual-balance'),
              style: style,
            ),
          );
        },
      ),
    ),
  );
}
