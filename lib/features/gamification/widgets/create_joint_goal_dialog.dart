import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/l10n.dart';
import '../providers/joint_goals_provider.dart';

class CreateJointGoalDialog extends ConsumerStatefulWidget {
  const CreateJointGoalDialog({super.key});

  @override
  ConsumerState<CreateJointGoalDialog> createState() =>
      _CreateJointGoalDialogState();
}

class _CreateJointGoalDialogState extends ConsumerState<CreateJointGoalDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final List<TextEditingController> _friendControllers = [
    TextEditingController()
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    for (var c in _friendControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final friends = _friendControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (title.isEmpty || amountText.isEmpty) return;

    final targetAmount = (double.tryParse(amountText) ?? 0) * 100; // to kopecks
    if (targetAmount <= 0) return;

    await ref
        .read(jointGoalsNotifierProvider.notifier)
        .createGoal(title, targetAmount.toInt(), friends);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    final brightness = Theme.of(context).brightness;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SurfaceCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20.0),
        borderRadius: 16,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t('joint_create_title'),
                style: AppTypography.h2(context, color: AppColors.accent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                style: AppTypography.body(context),
                decoration: InputDecoration(
                  labelText: t('joint_create_name_label'),
                  labelStyle: AppTypography.bodySmall(context),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.border(brightness)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                style: AppTypography.body(context),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: t('joint_create_amount_label'),
                  labelStyle: AppTypography.bodySmall(context),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.border(brightness)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t('joint_create_members'),
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_friendControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _friendControllers[index],
                          style: AppTypography.body(context),
                          decoration: InputDecoration(
                            hintText: t('joint_create_name_hint'),
                            hintStyle: AppTypography.body(
                              context,
                              color: AppColors.textTertiary(brightness),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.border(brightness),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.accent),
                            ),
                          ),
                        ),
                      ),
                      if (index == _friendControllers.length - 1)
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: AppColors.accent),
                          onPressed: () {
                            setState(() {
                              _friendControllers.add(TextEditingController());
                            });
                          },
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              AppButton(
                label: t('joint_create_btn'),
                variant: ButtonVariant.primary,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
