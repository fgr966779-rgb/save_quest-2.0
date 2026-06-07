import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../core/providers/providers.dart';
import '../../../core/services/gamification/xp_service.dart';

class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({super.key});

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  final TextEditingController _cmdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isDecrypting = false;
  String _decryptionTarget = '';
  int _decryptionTimeLeft = 0;
  Timer? _countdownTimer;

  void _startDecryption() {
    _countdownTimer?.cancel();

    final words = [
      'SYS_OVERLOAD',
      'NETRUNNER',
      'NEON_VAULT',
      'BLACKOUT',
      'ARASAKA',
      'MATRIX_CORE',
      'CORP_SPY',
      'CYBERNETIC',
      'QUANTUM_BIT',
      'FIREWALL_BYPASS'
    ];
    final random = math.Random();
    _decryptionTarget = words[random.nextInt(words.length)];
    _isDecrypting = true;
    _decryptionTimeLeft = 12;

    _log('DECRYPTION PROTOCOL INITIATED...');
    _log('RETRIEVING SECURITY CIPHER...');
    _log('CYPHER GENERATED: $_decryptionTarget');
    _log('ENTER CYPHER WITHIN 12 SECONDS TO PURGE VIRUS.');

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _decryptionTimeLeft--;
        if (_decryptionTimeLeft <= 0) {
          timer.cancel();
          _isDecrypting = false;
          _log('DECRYPTION TIMED OUT. CONNECTION CLOSED. SYSTEM DAMAGE ENFORCED.');
        }
      });
    });
  }

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
    _countdownTimer?.cancel();
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

    if (_isDecrypting) {
      _countdownTimer?.cancel();
      setState(() {
        _isDecrypting = false;
      });

      if (input.toUpperCase() == _decryptionTarget.toUpperCase()) {
        _log('DECRYPTION SUCCESSFUL!');
        _log('VIRUS REMOVED FROM SECTORS.');

        final db = ref.read(databaseProvider);
        final profile = await db.getUserProfile();
        if (profile != null) {
          final newPenalty = math.max(0, profile.penaltyBalance - 5000); // subtract 50 UAH (5000 cents)
          var newXP = profile.xp + 50;
          var currentLevel = profile.level;
          bool leveledUp = false;
          while (newXP >= XpService.xpRequiredForLevel(currentLevel)) {
            currentLevel++;
            leveledUp = true;
          }
          await db.updateUserProfile(profile.copyWith(
            penaltyBalance: newPenalty,
            xp: newXP,
            level: currentLevel,
            hackerXp: profile.hackerXp + 10,
          ));

          _log('PENALTY RECOVERED: -50.00 UAH');
          _log('+ XP GAINED: 50');
          _log('+ HACKER XP GAINED: 10');
          if (leveledUp) {
            _log('!!! SYSTEM LEVEL UP: $currentLevel !!!');
          }

          ref.invalidate(userProfileProvider);
        }
      } else {
        _log('ERROR: DECRYPTION FAILED. INVALID CIPHER. VIRUS STILL ACTIVE.');
      }

      _focusNode.requestFocus();
      return;
    }

    final parts = input.split(' ');
    final command = parts.first.toLowerCase();

    switch (command) {
      case '/help':
        _log('AVAILABLE COMMANDS:');
        _log('  /status   - Display current system metrics and balances');
        _log('  /save <X> - Deposit X amount into your savings');
        _log('  /goals    - List all active savings goals');
        _log('  /decrypt  - Try to decrypt and clear active virus');
        _log('  /purge    - Instantly purge active virus for 15 crystals');
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

      case '/decrypt':
        final profileAsync = ref.read(userProfileProvider);
        profileAsync.whenData((profile) {
          if (profile == null) {
            _log('ERROR: PROFILE NOT FOUND.');
            return;
          }
          if (profile.penaltyBalance <= 0) {
            _log('SYSTEM STABLE. NO VIRUS DETECTED. NO NEED TO DECRYPT.');
            return;
          }
          _startDecryption();
        });
        break;

      case '/purge':
        final db = ref.read(databaseProvider);
        final profile = await db.getUserProfile();
        if (profile == null) {
          _log('ERROR: PROFILE NOT FOUND.');
          break;
        }
        if (profile.penaltyBalance <= 0) {
          _log('SYSTEM STABLE. NO ACTIVE VIRUSES TO PURGE.');
          break;
        }
        if (profile.crystalsBalance < 15) {
          _log('ERROR: INSUFFICIENT CRYSTALS. NEED 15, YOU HAVE ${profile.crystalsBalance}.');
          break;
        }
        _log('PURGING VIRUS FROM SYSTEMS...');
        await db.updateUserProfile(profile.copyWith(
          penaltyBalance: 0,
          crystalsBalance: profile.crystalsBalance - 15,
        ));
        _log('SUCCESS: VIRUS PURGED. SHIELD RESTORED. -15 CRYSTALS.');
        ref.invalidate(userProfileProvider);
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
                          color: Color(0xFF00E5FF), // Terminal cyan
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
                        color: Color(0xFF00E5FF),
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
                        cursorColor: Color(0xFF00E5FF),
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
