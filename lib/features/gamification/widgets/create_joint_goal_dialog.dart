import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/joint_goals_provider.dart';

class CreateJointGoalDialog extends ConsumerStatefulWidget {
  const CreateJointGoalDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateJointGoalDialog> createState() => _CreateJointGoalDialogState();
}

class _CreateJointGoalDialogState extends ConsumerState<CreateJointGoalDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final List<TextEditingController> _friendControllers = [TextEditingController()];

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

    await ref.read(jointGoalsNotifierProvider.notifier).createGoal(
          title,
          targetAmount.toInt(),
          friends,
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.magentaAccent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'НОВА СПІЛЬНА ЦІЛЬ',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 18,
                  color: AppColors.magentaAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Назва цілі (Напр. ПС5)',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderNeon)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magentaAccent)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                style: const TextStyle(color: Colors.white),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Сума (₴)',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderNeon)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magentaAccent)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Учасники (Віртуальні/Офлайн)',
                style: AppTextStyles.rajdhaniMedium(fontSize: 16, color: AppColors.cyanAccent),
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
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Ім\'я друга',
                            hintStyle: const TextStyle(color: AppColors.textMuted),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderNeon)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cyanAccent)),
                          ),
                        ),
                      ),
                      if (index == _friendControllers.length - 1)
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: AppColors.cyanAccent),
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
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.magentaAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('СТВОРИТИ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
