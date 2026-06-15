import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/banklink_provider.dart';

class BankSyncScreen extends ConsumerWidget {
  const BankSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bankLinkProvider);
    final notifier = ref.read(bankLinkProvider.notifier);
    final isConnected = state.activeConfig?.status == 'connected';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BANKLINK',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isConnected)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton.icon(
                icon: state.isSyncing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: Color(0xFF39FF14),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.sync, color: Color(0xFF39FF14), size: 18),
                label: Text(
                  'SYNC',
                  style: GoogleFonts.orbitron(
                    color: const Color(0xFF39FF14),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: state.isSyncing ? null : () => notifier.syncNow(),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Provider selection
            Text(
              'ПРОВАЙДЕР',
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _ProviderCard(
                  name: 'PrivatBank',
                  icon: Icons.account_balance,
                  color: Colors.green,
                  isSelected: state.activeConfig?.provider == 'privatbank',
                  onTap: () => notifier.connectProvider('privatbank'),
                ),
                const SizedBox(width: 12),
                _ProviderCard(
                  name: 'Plaid',
                  icon: Icons.hub,
                  color: Colors.blue,
                  isSelected: state.activeConfig?.provider == 'plaid',
                  onTap: () => notifier.connectProvider('plaid'),
                ),
                const SizedBox(width: 12),
                _ProviderCard(
                  name: 'Mock Demo',
                  icon: Icons.play_circle,
                  color: Colors.purple,
                  isSelected: state.activeConfig?.provider == 'mock',
                  onTap: () => notifier.connectProvider('mock'),
                ),
              ],
            ),

            if (state.isSyncing && !isConnected) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF39FF14)),
              ),
              const SizedBox(height: 12),
              Text(
                'Підключення...',
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(color: Colors.white54),
              ),
            ],

            if (isConnected) ...[
              const SizedBox(height: 32),
              // Status card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF39FF14).withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF39FF14).withValues(alpha: 0.1),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF39FF14).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.link, color: Color(0xFF39FF14), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.activeConfig!.provider.toUpperCase()} — CONNECTED',
                            style: GoogleFonts.orbitron(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF39FF14),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.activeConfig!.maskedAccount ?? '**** ****',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          if (state.activeConfig!.lastSyncAt != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Останній синк: ${DateFormat('dd.MM HH:mm').format(state.activeConfig!.lastSyncAt!)}',
                              style: GoogleFonts.shareTechMono(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // Round-up section
              Text(
                'ROUND-UP ЗАОЩАДЖЕННЯ',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Автоматичний round-up',
                          style: GoogleFonts.shareTechMono(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Switch(
                          value: state.activeConfig?.roundUpEnabled ?? false,
                          onChanged: (val) => notifier.toggleRoundUp(val),
                          activeColor: const Color(0xFF39FF14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Округлює кожну покупку до наступної гривні та переводить різницю на ціль.',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white38,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    if (state.calculatedRoundUp > 0) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Зібрано за сьогодні:',
                              style: GoogleFonts.shareTechMono(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${(state.calculatedRoundUp / 100).toStringAsFixed(2)} ₴',
                              style: GoogleFonts.orbitron(
                                color: const Color(0xFF39FF14),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // Recent transactions
              if (state.recentTransactions.isNotEmpty) ...[
                Text(
                  'ОСТАННІ ТРАНЗАКЦІЇ',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.recentTransactions.map((tx) => _TransactionRow(tx: tx)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.white12,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12)]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.white38, size: 28),
              const SizedBox(height: 8),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: isSelected ? color : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final dynamic tx;

  const _TransactionRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final int amount = tx.amountKopecks as int;
    final int remainder = amount % 100;
    final int roundUp = remainder > 0 ? (100 - remainder) : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx.description as String,
                style: GoogleFonts.shareTechMono(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.category as String,
                style: GoogleFonts.shareTechMono(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(amount / 100).toStringAsFixed(2)} ₴',
                style: GoogleFonts.shareTechMono(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              if (roundUp > 0)
                Text(
                  '+${(roundUp / 100).toStringAsFixed(2)} ₴',
                  style: GoogleFonts.shareTechMono(
                    color: const Color(0xFF39FF14),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
