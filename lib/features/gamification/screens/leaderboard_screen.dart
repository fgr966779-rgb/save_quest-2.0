import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'ТАБЛИЦЯ ЛІДЕРІВ',
          style: AppTextStyles.orbitronHeading(fontSize: 20, color: AppColors.goldAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: Text(
          'Лідерборд у розробці',
          style: AppTextStyles.rajdhaniMedium(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
