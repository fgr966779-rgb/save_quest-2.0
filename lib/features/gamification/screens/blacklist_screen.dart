import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';

class BlacklistScreen extends ConsumerStatefulWidget {
  const BlacklistScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends ConsumerState<BlacklistScreen> {
  final TextEditingController _categoryController = TextEditingController();

  final List<String> _commonCategories = [
    'Фастфуд', 'Ігри', 'Кава', 'Підписки', 'Шопінг', 'Алкоголь'
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _addCategory(String cat) {
    if (cat.trim().isEmpty) return;
    
    final settings = ref.read(settingsServiceProvider);
    final currentList = List<String>.from(settings.blacklistedCategories);
    
    if (!currentList.contains(cat.trim())) {
      HapticFeedback.lightImpact();
      currentList.add(cat.trim());
      settings.blacklistedCategories = currentList;
      setState(() {});
      _categoryController.clear();
    }
  }

  void _removeCategory(String cat) {
    HapticFeedback.mediumImpact();
    final settings = ref.read(settingsServiceProvider);
    final currentList = List<String>.from(settings.blacklistedCategories);
    
    currentList.remove(cat);
    settings.blacklistedCategories = currentList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsServiceProvider);
    final blacklist = settings.blacklistedCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'АВТО-ШТРАФИ (BLACKLIST)',
          style: AppTextStyles.orbitronHeading(
            fontSize: 14.0,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16.0),
            Text(
              'Якщо система виявить транзакції у вказаних нижче категоріях, буде автоматично нараховано штраф!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32.0),

            // Active Blacklist Categories
            Text(
              'АКТИВНИЙ БЛЕКЛІСТ',
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            if (blacklist.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(16.0),
                borderColor: AppColors.borderNeon.withOpacity(0.5),
                child: const Text(
                  'Жодної категорії не додано. Ви у безпеці... поки що.',
                  style: TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: blacklist.map((cat) {
                  return Chip(
                    label: Text(cat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    side: const BorderSide(color: Colors.redAccent),
                    deleteIconColor: Colors.white,
                    onDeleted: () => _removeCategory(cat),
                  );
                }).toList(),
              ),
            const SizedBox(height: 32.0),

            // Add Custom Category
            GlassCard(
              padding: const EdgeInsets.all(16.0),
              borderColor: AppColors.borderNeon,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _categoryController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Введіть назву категорії...',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _addCategory,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.redAccent),
                    onPressed: () => _addCategory(_categoryController.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Suggestions
            Text(
              'ЧАСТІ ПОРУШНИКИ:',
              style: AppTextStyles.orbitronHeading(
                fontSize: 10.0,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _commonCategories.map((cat) {
                final isAdded = blacklist.contains(cat);
                return ActionChip(
                  label: Text(cat),
                  labelStyle: TextStyle(color: isAdded ? AppColors.textMuted : Colors.black),
                  backgroundColor: isAdded ? AppColors.cardBg : AppColors.cyanAccent,
                  onPressed: isAdded ? null : () => _addCategory(cat),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
