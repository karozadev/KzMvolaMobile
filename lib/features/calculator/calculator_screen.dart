import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/fee_grids.dart';
import '../../domain/models/mode.dart';
import '../../shared/share/share_service.dart';
import '../../shared/widgets/app_credit_footer.dart';
import '../../state/calculator_view_model.dart';
import '../../state/history_notifier.dart';
import 'widgets/amount_field.dart';
import 'widgets/destination_chips.dart';
import 'widgets/direct_result_card.dart';
import 'widgets/mode_selector.dart';
import 'widgets/optimized_result_card.dart';
import 'widgets/result_actions.dart';
import 'widgets/savings_banner.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatefulWidget {
  const _CalculatorView();

  @override
  State<_CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<_CalculatorView> {
  final _shareButtonKey = GlobalKey();
  final _shareService = ShareService();

  Future<void> _handleShare(CalculatorViewModel vm) async {
    final result = vm.result;
    if (result == null) return;
    final renderBox = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final origin = renderBox != null
        ? renderBox.localToGlobal(Offset.zero) & renderBox.size
        : null;
    await _shareService.shareResult(result: result, config: vm.config, origin: origin);
  }

  Future<void> _handleSave(CalculatorViewModel vm) async {
    final result = vm.result;
    if (result == null) return;
    await context.read<HistoryNotifier>().add(
      mode: vm.mode,
      destination: vm.mode == Mode.transfert ? vm.destination : null,
      result: result,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Calcul enregistré dans l\'historique.')));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalculatorViewModel>();
    final config = vm.config;
    final result = vm.result;

    return Scaffold(
      appBar: AppBar(title: const Text('Kahiatra')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Calculateur de frais MVola', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              config.heroSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ModeSelector(value: vm.mode, onChanged: vm.setMode),
            if (vm.mode == Mode.transfert) ...[
              const SizedBox(height: 16),
              DestinationChips(value: vm.destination, onChanged: vm.setDestination),
            ],
            const SizedBox(height: 20),
            AmountField(
              label: config.wording.amountLabel,
              initialRawInput: vm.rawInput,
              isOverLimit: vm.isOverLimit,
              maxAmount: vm.maxAmount,
              onChanged: vm.onAmountChanged,
            ),
            const SizedBox(height: 24),
            if (result == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Saisissez un montant pour voir la meilleure stratégie.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final direct = DirectResultCard(direct: result.direct, wording: config.wording);
                  final optimized = OptimizedResultCard(
                    optimized: result.optimized,
                    wording: config.wording,
                  );
                  if (constraints.maxWidth >= 600) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: direct),
                        const SizedBox(width: 16),
                        Expanded(child: optimized),
                      ],
                    );
                  }
                  return Column(
                    children: [direct, const SizedBox(height: 16), optimized],
                  );
                },
              ),
              if (result.savings > 0) ...[
                const SizedBox(height: 16),
                SavingsBanner(
                  savings: result.savings,
                  directFee: result.direct.fee ?? 0,
                  suffix: config.wording.savingsSuffix,
                ),
              ],
              const SizedBox(height: 20),
              ResultActions(
                shareButtonKey: _shareButtonKey,
                onSave: () => _handleSave(vm),
                onShare: () => _handleShare(vm),
              ),
            ],
            const SizedBox(height: 32),
            Text(
              config.gridCaption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => launchUrl(Uri.parse(officialTariffUrl)),
              child: Text(
                'Voir le tarif officiel MVola',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 24),
            const AppCreditFooter(),
          ],
        ),
      ),
    );
  }
}
