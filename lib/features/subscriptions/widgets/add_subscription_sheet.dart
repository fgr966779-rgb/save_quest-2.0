// FILE: lib/features/subscriptions/widgets/add_subscription_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../data/database.dart';
import '../providers/subscription_provider.dart';
import '../services/subscription_service.dart';

class AddSubscriptionSheet extends ConsumerStatefulWidget {
  const AddSubscriptionSheet({super.key});

  @override
  ConsumerState<AddSubscriptionSheet> createState() =>
      _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends ConsumerState<AddSubscriptionSheet> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _cycle = 'monthly';
  DateTime _nextDate = DateTime.now().add(const Duration(days: 30));
  int _reminderDays = 3;
  String _selectedTemplate = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _applyTemplate(Map<String, dynamic> tpl) {
    setState(() {
      _selectedTemplate = tpl['name'] as String;
      if (tpl['name'] != 'Своє (ручне)') {
        _nameCtrl.text = tpl['name'] as String;
        _amountCtrl.text =
            ((tpl['amount'] as int) / 100).toStringAsFixed(0);
        _cycle = tpl['cycle'] as String;
      } else {
        _nameCtrl.clear();
        _amountCtrl.clear();
      }
    });
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final amountStr = _amountCtrl.text.trim().replaceAll(',', '.');
    if (name.isEmpty || amountStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFFF3B30).withValues(alpha: 0.9),
        content: Text('Заповни назву та суму',
            style: GoogleFonts.spaceMono(color: Colors.white)),
      ));
      return;
    }
    final amount = (double.tryParse(amountStr) ?? 0) * 100;

    final companion = SubscriptionsCompanion.insert(
      name: name,
      amountKopecks: amount.round(),
      billingCycle: Value(_cycle),
      nextBillingDate: _nextDate,
      reminderDaysBefore: Value(_reminderDays),
    );

    await ref.read(subscriptionServiceProvider).addSubscription(companion);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
              top: BorderSide(color: Color(0xFF00FF9D), width: 1)),
        ),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text('🥷 Додати паразита',
                style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Оберіть шаблон або введіть вручну',
                style: GoogleFonts.spaceMono(
                    color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 16),

            // ── Template chips ─────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SubscriptionService.kTemplates.map((tpl) {
                final isSelected = _selectedTemplate == tpl['name'];
                return GestureDetector(
                  onTap: () => _applyTemplate(tpl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00FF9D).withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00FF9D)
                            : Colors.white24,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: Text(
                      tpl['name'] as String,
                      style: GoogleFonts.spaceMono(
                        color: isSelected
                            ? const Color(0xFF00FF9D)
                            : Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            _Divider(),

            // ── Name field ─────────────────────────────────────────────
            _NeonField(
              controller: _nameCtrl,
              label: 'Назва сервісу',
              hint: 'напр. Netflix',
            ),
            const SizedBox(height: 12),

            // ── Amount field ───────────────────────────────────────────
            _NeonField(
              controller: _amountCtrl,
              label: 'Сума (UAH)',
              hint: '199.00',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),

            // ── Billing cycle ──────────────────────────────────────────
            Text('Частота списання',
                style: GoogleFonts.spaceMono(
                    color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 6),
            Row(
              children: [
                _CycleButton(
                    label: 'Щомісяця',
                    isSelected: _cycle == 'monthly',
                    onTap: () => setState(() => _cycle = 'monthly')),
                const SizedBox(width: 10),
                _CycleButton(
                    label: 'Щороку',
                    isSelected: _cycle == 'yearly',
                    onTap: () => setState(() => _cycle = 'yearly')),
              ],
            ),
            const SizedBox(height: 12),

            // ── Next billing date ──────────────────────────────────────
            Text('Наступне списання',
                style: GoogleFonts.spaceMono(
                    color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _nextDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 400)),
                  builder: (ctx, child) => Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Color(0xFF00FF9D),
                        surface: Color(0xFF1A1A2E),
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  setState(() => _nextDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFF00FF9D), size: 16),
                    const SizedBox(width: 10),
                    Text(
                      '${_nextDate.day.toString().padLeft(2, '0')}.${_nextDate.month.toString().padLeft(2, '0')}.${_nextDate.year}',
                      style: GoogleFonts.spaceMono(
                          color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Reminder ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Нагадувати за',
                    style: GoogleFonts.spaceMono(
                        color: Colors.white54, fontSize: 11)),
                DropdownButton<int>(
                  value: _reminderDays,
                  dropdownColor: const Color(0xFF1A1A2E),
                  style: GoogleFonts.spaceMono(
                      color: const Color(0xFF00FF9D), fontSize: 12),
                  underline: const SizedBox(),
                  items: [1, 2, 3, 5, 7].map((d) {
                    return DropdownMenuItem(
                        value: d,
                        child: Text('$d дн.'));
                  }).toList(),
                  onChanged: (v) =>
                      setState(() => _reminderDays = v ?? 3),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Save button ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF9D),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _save,
                icon: const Icon(Icons.add, color: Colors.black),
                label: Text('Відстежувати паразита',
                    style: GoogleFonts.spaceMono(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.white12));
}

class _NeonField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  const _NeonField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.spaceMono(
                  color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.spaceMono(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.spaceMono(
                  color: Colors.white24, fontSize: 13),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFF00FF9D), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
          ),
        ],
      );
}

class _CycleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CycleButton(
      {required this.label,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF00FF9D).withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00FF9D)
                    : Colors.white24,
              ),
            ),
            child: Center(
              child: Text(label,
                  style: GoogleFonts.spaceMono(
                    color: isSelected
                        ? const Color(0xFF00FF9D)
                        : Colors.white54,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
            ),
          ),
        ),
      );
}
