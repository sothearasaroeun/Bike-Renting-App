import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/passes/pass.dart';
import '../../states/pass_state.dart';
import '../../theme/theme.dart';
import 'payment_success_screen.dart';
import 'view_model/pass_view_model.dart';
import 'widgets/active_pass_card.dart';
import 'widgets/pass_type_card.dart';

enum PassTypeSelection { single, period, none }

class PassScreen extends StatefulWidget {
  final PassTypeSelection preselectedType;

  const PassScreen({super.key, this.preselectedType = PassTypeSelection.none});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  PassType? _purchasingType;

  bool get _isStandalone => widget.preselectedType == PassTypeSelection.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PassViewModel>().loadActivePass();
    });
  }

  Future<void> _onSelect(BuildContext context, PassType type) async {
    setState(() => _purchasingType = type);

    final vm = context.read<PassViewModel>();
    await vm.purchase(type);

    if (!mounted) return;

    final state = vm.state;
    if (state is PassPurchaseSuccess) {
      final label = vm.labelFor(type);
      final features = vm.featuresFor(type);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            pass: state.pass,
            label: label,
            features: features,
          ),
        ),
      );

      if (!mounted) return;

      if (_isStandalone) {
        if (type != PassType.singleTicket) {
          context.read<PassViewModel>().loadActivePass();
        }
      } else {
        Navigator.of(context).pop();
      }
    } else if (state is PassError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }

    if (mounted) setState(() => _purchasingType = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isStandalone
          ? null
          : AppBar(
              title: const Text('Choose Your Pass'),
              leading: const BackButton(),
            ),
      backgroundColor: AppColors.background,
      body: Consumer<PassViewModel>(
        builder: (context, vm, _) {
          if (vm.state is PassLoading || vm.state is PassInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_isStandalone &&
              vm.state is PassLoaded &&
              (vm.state as PassLoaded).activePass != null) {
            final pass = (vm.state as PassLoaded).activePass!;
            return _buildWithActivePass(context, vm, pass);
          }

          return _buildPassPicker(context, vm);
        },
      ),
    );
  }

  Widget _buildWithActivePass(
    BuildContext context,
    PassViewModel vm,
    Pass pass,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Pass', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(
                  'Your currently active pass',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          ActivePassCard(
            pass: pass,
            label: vm.labelFor(pass.type),
            features: vm.featuresFor(pass.type),
          ),
        ],
      ),
    );
  }

  Widget _buildPassPicker(BuildContext context, PassViewModel vm) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Your Pass', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(
                  'Select the plan that works best for you',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          _buildPassCards(context, vm),
        ],
      ),
    );
  }

  Widget _buildPassCards(BuildContext context, PassViewModel vm) {
    final types = widget.preselectedType == PassTypeSelection.single
        ? [PassType.singleTicket]
        : [PassType.day, PassType.monthly, PassType.annual];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: types.map((type) {
          return PassTypeCard(
            type: type,
            label: vm.labelFor(type),
            price: vm.priceFor(type),
            duration: vm.durationFor(type),
            features: vm.featuresFor(type),
            isMostPopular: vm.isMostPopularType(type),
            isLoading: _purchasingType == type,
            onSelect: () => _onSelect(context, type),
          );
        }).toList(),
      ),
    );
  }
}
