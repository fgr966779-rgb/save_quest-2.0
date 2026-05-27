import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/surface_card.dart';

class BlacklistScreen extends ConsumerStatefulWidget {
  const BlacklistScreen({super.key});

  @override
  ConsumerState<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends ConsumerState<BlacklistScreen> {
  final TextEditingController _categoryController = TextEditingController();

  late final List<String> _commonCategories;

  @override
  void initState() {
    super.initState();
    _commonCategories = [
      'blacklist_cat_fastfood', 'blacklist_cat_games', 'blacklist_cat_coffee', 'blacklist_cat_subs', 'blacklist_cat_shopping', 'blacklist_cat_alcohol',
    ];
  }

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
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('blacklist_title'),
          style: AppTypography.h3(context, color: AppColors.error),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary(brightness)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 64),
            const SizedBox(height: 16.0),
            Text(
              t('blacklist_desc'),
              textAlign: TextAlign.center,
              style: AppTypography.body(context),
            ),
            const SizedBox(height: 32.0),

            // Active Blacklist Categories
            Text(
              t('blacklist_active'),
              style: AppTypography.caption(context, color: AppColors.textPrimary(brightness)),
            ),
            const SizedBox(height: 12.0),
            if (blacklist.isEmpty)
              SurfaceCard(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t('blacklist_empty'),
                  style: AppTypography.body(context, color: AppColors.textTertiary(brightness)).copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: blacklist.map((cat) {
                  return Chip(
                    label: Text(cat, style: TextStyle(color: AppColors.textPrimary(brightness), fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.error.withValues(alpha: 0.2),
                    side: const BorderSide(color: AppColors.error),
                    deleteIconColor: AppColors.textPrimary(brightness),
                    onDeleted: () => _removeCategory(cat),
                  );
                }).toList(),
              ),
            const SizedBox(height: 32.0),

            // Add Custom Category
            SurfaceCard(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _categoryController,
                      style: TextStyle(color: AppColors.textPrimary(brightness)),
                      decoration: InputDecoration(
                        hintText: t('blacklist_hint'),
                        hintStyle: TextStyle(color: AppColors.textTertiary(brightness)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _addCategory,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.error),
                    onPressed: () => _addCategory(_categoryController.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Suggestions
            Text(
              t('blacklist_frequent'),
              style: AppTypography.caption(context),
            ),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _commonCategories.map((key) {
                final cat = t(key);
                final isAdded = blacklist.contains(cat);
                return ActionChip(
                  label: Text(cat),
                  labelStyle: TextStyle(color: isAdded ? AppColors.textTertiary(brightness) : Colors.white),
                  backgroundColor: isAdded ? AppColors.surfaceMuted(brightness) : AppColors.accent,
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
