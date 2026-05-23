import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/savings_notifier.dart';

class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  final TextEditingController _cmdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _logs = [
    'SAVEQUEST OS v14.0.1 INITIATED',
    'CONNECTION ESTABLISHED. SECURITY PROTOCOLS: ACTIVE.',
    'TYPE /help FOR A LIST OF COMMANDS.',
    '----------------------------------------------------',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _cmdController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _log(String message) {
    setState(() {
      _logs.add(message);
    });
    _scrollToBottom();
  }

  Future<void> _handleCommand(String cmd) async {
    final input = cmd.trim();
    if (input.isEmpty) return;

    _cmdController.clear();
    _log('\n> $input');

    final parts = input.split(' ');
    final command = parts.first.toLowerCase();

    switch (command) {
      case '/help':
        _log('AVAILABLE COMMANDS:');
        _log('  /status   - Display current system metrics and balances');
        _log('  /save <X> - Deposit X amount into your savings');
        _log('  /goals    - List all active savings goals');
        _log('  /clear    - Clear terminal logs');
        _log('  /exit     - Return to visual interface');
        break;

      case '/clear':
        setState(() {
          _logs.clear();
          _log('SAVEQUEST OS v14.0.1 INITIATED');
        });
        break;

      case '/exit':
        _log('SHUTTING DOWN TERMINAL INTERFACE...');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.pop();
        });
        break;

      case '/status':
        final profileAsync = ref.read(userProfileProvider);
        profileAsync.whenData((profile) {
          if (profile != null) {
            _log('STATUS: STABLE');
            _log('XP: ${profile.xp} | LEVEL: ${profile.level}');
            _log('STREAK: ${profile.streakCount} DAYS');
            _log('PENALTY DEBT: ${profile.penaltyBalance / 100} UAH');
          } else {
            _log('ERROR: PROFILE DATA CORRUPTED OR UNAVAILABLE');
          }
        });
        break;

      case '/goals':
        // A simple query to database
        final db = ref.read(databaseProvider);
        final goals = await db.select(db.goals).get();
        if (goals.isEmpty) {
          _log('NO ACTIVE GOALS DETECTED.');
        } else {
          for (var g in goals) {
            _log('- ${g.id}: ${(g.currentAmount / 100).toStringAsFixed(2)} / ${(g.targetAmount / 100).toStringAsFixed(2)} UAH');
          }
        }
        break;

      case '/save':
        if (parts.length < 2) {
          _log('ERROR: INVALID SYNTAX. USE: /save <amount>');
          break;
        }
        final amountStr = parts[1];
        final amount = double.tryParse(amountStr);
        if (amount == null || amount <= 0) {
          _log('ERROR: AMOUNT MUST BE A POSITIVE NUMBER.');
          break;
        }

        _log('PROCESSING DEPOSIT OF $amount UAH...');
        
        final db = ref.read(databaseProvider);
        final goals = await db.select(db.goals).get();
        
        if (goals.isEmpty) {
          _log('ERROR: NO ACTIVE GOALS DETECTED. CANNOT DEPOSIT.');
          break;
        }

        final result = await ref.read(savingsNotifierProvider.notifier).createDeposit(
          amount: amount,
          goalAPercent: 50.0,
          note: 'CLI Deposit',
          context: ActionContext.cli,
        );

        if (result != null) {
          _log('SUCCESS: DEPOSIT CONFIRMED.');
          _log('+ XP GAINED: ${result.xpGained}');
          if (result.hackerXpGained > 0) {
            _log('+ HACKER XP GAINED: ${result.hackerXpGained}');
          }
          if (result.magnateXpGained > 0) {
            _log('+ MAGNATE XP GAINED: ${result.magnateXpGained}');
          }
          if (result.leveledUp) {
            _log('!!! SYSTEM LEVEL UP: ${result.newLevel} !!!');
          }
        } else {
          _log('ERROR: DEPOSIT FAILED.');
        }
        break;

      default:
        _log('ERROR: COMMAND NOT RECOGNIZED. TYPE /help.');
    }
    
    // Give focus back to the input
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // True terminal black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Output Area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          fontFamily: 'Courier', // Standard terminal font
                          fontSize: 14.0,
                          color: AppColors.cyanAccent, // Hacker green/cyan
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input Area
              Container(
                color: Colors.black,
                child: Row(
                  children: [
                    const Text(
                      '> ',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16.0,
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _cmdController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        cursorColor: AppColors.cyanAccent,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        onSubmitted: _handleCommand,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
