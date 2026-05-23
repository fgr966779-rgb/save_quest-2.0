import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../widgets/cipher_text.dart';

class SavingGoalCard extends StatefulWidget {
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String currency;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final String heroTag;
  final bool isCiphered;

  const SavingGoalCard({
    Key? key,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.currency,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    required this.heroTag,
    this.isCiphered = false,
  }) : super(key: key);

  @override
  State<SavingGoalCard> createState() => _SavingGoalCardState();
}

class _SavingGoalCardState extends State<SavingGoalCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.targetAmount > 0
        ? (widget.currentAmount / widget.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final percentage = (progress * 100).toInt();

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _scale = 0.96);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _scale = 1.0);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            // Soft glow/drop shadow
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(isDark ? 0.08 : 0.04),
                blurRadius: 32.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  // Frosted glass effect
                  color: isDark
                      ? AppColors.cardBg.withOpacity(0.65)
                      : Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24.0),
                  // Micro-border
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.04),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vertical left accent stripe
                    Container(
                      width: 4.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        borderRadius: BorderRadius.circular(2.0),
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withOpacity(0.6),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Hero(
                                    tag: widget.heroTag,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: widget.accentColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        widget.icon,
                                        color: widget.accentColor,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    widget.title.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$percentage%',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: widget.accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'НАКОПИЧЕНО',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  CipherText(
                                    text: '${widget.currentAmount.toStringAsFixed(0)} ${widget.currency}',
                                    isCiphered: widget.isCiphered,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'МІШЕНЬ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  CipherText(
                                    text: '${widget.targetAmount.toStringAsFixed(0)} ${widget.currency}',
                                    isCiphered: widget.isCiphered,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          // Custom animated progress bar
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final maxWidth = constraints.maxWidth;
                              final progressWidth = maxWidth * progress;

                              return Stack(
                                alignment: Alignment.centerLeft,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 7.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeOutQuad,
                                    height: 7.0,
                                    width: progressWidth,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          widget.accentColor,
                                          widget.accentColor.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.accentColor.withOpacity(0.25),
                                          blurRadius: 6.0,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: (progressWidth - 5).clamp(0.0, maxWidth - 10.0),
                                    child: Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: widget.accentColor,
                                            blurRadius: 6.0,
                                            spreadRadius: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
