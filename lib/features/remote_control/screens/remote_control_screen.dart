import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../services/remote_control_service.dart';

class RemoteControlScreen extends ConsumerStatefulWidget {
  const RemoteControlScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends ConsumerState<RemoteControlScreen> {
  final TextEditingController _ipController = TextEditingController(text: '192.168.1.');
  final TextEditingController _portController = TextEditingController(text: '8080');
  final TextEditingController _passwordController = TextEditingController(text: 'cybervault');
  
  bool _isConnecting = false;
  bool _directTouchMode = false; // Direct mouse click on tap vs Trackpad relative drag
  
  // Track relative drag states for trackpad mode
  double _lastDragX = 0.0;
  double _lastDragY = 0.0;
  
  // Modifiers active list
  final Set<String> _activeModifiers = {};

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleModifier(String mod) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_activeModifiers.contains(mod)) {
        _activeModifiers.remove(mod);
      } else {
        _activeModifiers.add(mod);
      }
    });
  }

  void _sendKeyPressWithModifiers(String key) {
    HapticFeedback.mediumImpact();
    final notifier = ref.read(remoteControlProvider.notifier);
    notifier.sendKeyPress(key, modifiers: _activeModifiers.toList());
    
    // Clear modifiers after a key combo tap (except Shift/Ctrl toggles, but here we clear for ease)
    setState(() {
      _activeModifiers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(remoteControlProvider);
    final notifier = ref.read(remoteControlProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'КІБЕР-УПРАВЛІННЯ ПК',
          style: AppTextStyles.orbitronHeading(fontSize: 16.0, color: AppColors.cyanAccent),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            notifier.disconnect();
            context.pop();
          },
        ),
        actions: [
          if (state.isAuthenticated) ...[
            IconButton(
              icon: Icon(
                _directTouchMode ? Icons.touch_app : Icons.mouse,
                color: AppColors.cyanAccent,
              ),
              tooltip: _directTouchMode ? 'Режим: Прямий Клік' : 'Режим: Трекпад',
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _directTouchMode = !_directTouchMode);
              },
            ),
            IconButton(
              icon: const Icon(Icons.flash_on, color: AppColors.goldAccent),
              tooltip: 'Виміряти затримку',
              onPressed: () {
                notifier.measureLatency();
              },
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
              tooltip: 'Відключитися',
              onPressed: () {
                HapticFeedback.heavyImpact();
                notifier.disconnect();
              },
            ),
          ]
        ],
      ),
      body: SafeArea(
        child: state.isAuthenticated 
            ? _buildStreamingViewport(state, notifier)
            : _buildConnectionSettings(state, notifier),
      ),
    );
  }

  Widget _buildConnectionSettings(RemoteControlState state, RemoteControlNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16.0),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyanAccent.withOpacity(0.08),
                border: Border.all(color: AppColors.cyanAccent.withOpacity(0.3), width: 2.0),
              ),
              child: const Icon(Icons.terminal, color: AppColors.cyanAccent, size: 48.0),
            ),
          ),
          const SizedBox(height: 24.0),
          Center(
            child: Text(
              'VAULT-17 LINK PORTAL',
              style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              'Встановіть з\'єднання з хост-сервером Node.js',
              textAlign: TextAlign.center,
              style: AppTextStyles.interBody(fontSize: 12.0, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32.0),
          
          if (state.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],

          GlassCard(
            padding: const EdgeInsets.all(20.0),
            borderColor: AppColors.cyanAccent.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(
                  label: 'IP АДРЕСА ПК',
                  controller: _ipController,
                  hint: '192.168.1.100',
                  icon: Icons.wifi,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  label: 'ПОРТ WebSocket',
                  controller: _portController,
                  hint: '8080',
                  icon: Icons.settings_ethernet,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  label: 'КІБЕР-ПАРОЛЬ (PIN)',
                  controller: _passwordController,
                  hint: 'Введіть пароль від сервера',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          
          _isConnecting 
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyanAccent))
              : NeonButton(
                  text: 'ВСТАНОВИТИ З\'ЄДНАННЯ',
                  baseColor: AppColors.cyanAccent,
                  glowColor: AppColors.cyanAccent,
                  onPressed: () async {
                    HapticFeedback.heavyImpact();
                    setState(() => _isConnecting = true);
                    await notifier.connect(
                      _ipController.text.trim(),
                      _portController.text.trim(),
                      _passwordController.text,
                    );
                    if (mounted) setState(() => _isConnecting = false);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildStreamingViewport(RemoteControlState state, RemoteControlNotifier notifier) {
    return Column(
      children: [
        // Top status indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'З\'ЄДНАНО',
                    style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.greenAccent),
                  ),
                ],
              ),
              Text(
                'ПІНГ: ${state.latency}мс',
                style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.textSecondary),
              ),
              Row(
                children: [
                  Text(
                    'ЯКІСТЬ: ',
                    style: AppTextStyles.orbitronHeading(fontSize: 9.0, color: AppColors.textSecondary),
                  ),
                  DropdownButton<int>(
                    value: state.quality,
                    dropdownColor: AppColors.cardBg,
                    style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.cyanAccent),
                    underline: const SizedBox(),
                    items: [30, 45, 60, 75, 90].map((q) {
                      return DropdownMenuItem<int>(
                        value: q,
                        child: Text('${q}%'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        notifier.setQuality(val);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Interactive Canvas Container
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.borderNeonActive, width: 2.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: state.frameBytes == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.cyanAccent),
                        SizedBox(height: 16.0),
                        Text(
                          'Очікування потоку екрану...',
                          style: TextStyle(color: Colors.white60, fontSize: 12.0),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        // Handle tap events for clicking mouse
                        onTapDown: (details) {
                          HapticFeedback.lightImpact();
                          final normalizedX = details.localPosition.dx / constraints.maxWidth;
                          final normalizedY = details.localPosition.dy / constraints.maxHeight;
                          
                          if (_directTouchMode) {
                            // In direct tap click mode, move and left click immediately
                            notifier.sendMouseMove(normalizedX, normalizedY);
                            Future.delayed(const Duration(milliseconds: 50), () {
                              notifier.sendMouseClick('left');
                            });
                          } else {
                            // Trackpad mode: click at current server cursor position
                            notifier.sendMouseClick('left');
                          }
                        },
                        
                        onDoubleTap: () {
                          HapticFeedback.mediumImpact();
                          notifier.sendMouseClick('left', doubleClick: true);
                        },

                        onLongPress: () {
                          HapticFeedback.heavyImpact();
                          notifier.sendMouseClick('right');
                        },

                        // Handle drag events for mouse movement
                        onPanStart: (details) {
                          _lastDragX = details.localPosition.dx;
                          _lastDragY = details.localPosition.dy;
                        },

                        onPanUpdate: (details) {
                          if (_directTouchMode) {
                            // Direct mapping
                            final normalizedX = details.localPosition.dx / constraints.maxWidth;
                            final normalizedY = details.localPosition.dy / constraints.maxHeight;
                            notifier.sendMouseMove(normalizedX, normalizedY);
                          } else {
                            // Relative mouse movements like a trackpad
                            final dx = (details.localPosition.dx - _lastDragX) / constraints.maxWidth;
                            final dy = (details.localPosition.dy - _lastDragY) / constraints.maxHeight;
                            
                            // Send relative movement step (adds offset scaling for speed)
                            notifier.sendMouseMove(
                              (details.localPosition.dx / constraints.maxWidth) + (dx * 1.5),
                              (details.localPosition.dy / constraints.maxHeight) + (dy * 1.5)
                            );
                            
                            _lastDragX = details.localPosition.dx;
                            _lastDragY = details.localPosition.dy;
                          }
                        },

                        child: Image.memory(
                          state.frameBytes!,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        ),
                      );
                    },
                  ),
          ),
        ),

        // Cyberpunk floating modifier keyboard quick bar
        _buildQuickControllerSheet(notifier),
      ],
    );
  }

  Widget _buildQuickControllerSheet(RemoteControlNotifier notifier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.borderNeon.withOpacity(0.5))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Modifier Key Toggles
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildModifierButton('ctrl', 'CTRL'),
                _buildModifierButton('alt', 'ALT'),
                _buildModifierButton('shift', 'SHIFT'),
                _buildModifierButton('win', 'WIN'),
                const SizedBox(width: 8.0),
                const VerticalDivider(color: Colors.white24, width: 1),
                const SizedBox(width: 8.0),
                _buildShortcutButton('esc', 'ESC'),
                _buildShortcutButton('tab', 'TAB'),
                _buildShortcutButton('enter', 'ENTER'),
                _buildShortcutButton('backspace', 'BACKSPACE'),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          
          // Row 2: Navigation Arrows, Mouse Wheel, Keyboard Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Scroll Controls
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_downward_rounded, color: AppColors.magentaAccent),
                    tooltip: 'Скрол Вниз',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      notifier.sendMouseScroll(-120);
                    },
                  ),
                  const Icon(Icons.unfold_more_rounded, color: Colors.white38, size: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, color: AppColors.cyanAccent),
                    tooltip: 'Скрол Вгору',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      notifier.sendMouseScroll(120);
                    },
                  ),
                ],
              ),
              
              // Arrow keys Pad
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: () => _sendKeyPressWithModifiers('left'),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                        onPressed: () => _sendKeyPressWithModifiers('up'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        onPressed: () => _sendKeyPressWithModifiers('down'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: () => _sendKeyPressWithModifiers('right'),
                  ),
                ],
              ),
              
              // Full Text Input keyboard dialog
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.cyanAccent.withOpacity(0.1),
                  side: const BorderSide(color: AppColors.cyanAccent),
                ),
                icon: const Icon(Icons.keyboard, color: AppColors.cyanAccent, size: 18),
                label: Text(
                  'ТЕКСТ',
                  style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.cyanAccent),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _showTextInputDialog(notifier);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModifierButton(String modifierKey, String label) {
    final bool isActive = _activeModifiers.contains(modifierKey);
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTextStyles.orbitronHeading(
            fontSize: 9.0,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
        selected: isActive,
        selectedColor: AppColors.cyanAccent,
        backgroundColor: AppColors.cardBgLight,
        onSelected: (_) => _toggleModifier(modifierKey),
      ),
    );
  }

  Widget _buildShortcutButton(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        backgroundColor: AppColors.cardBgLight,
        label: Text(
          label,
          style: AppTextStyles.orbitronHeading(fontSize: 9.0, color: Colors.white),
        ),
        onPressed: () => _sendKeyPressWithModifiers(key),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.orbitronHeading(
            fontSize: 10.0,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 13.0),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: AppColors.cyanAccent, size: 18.0),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          ),
        ),
      ],
    );
  }

  void _showTextInputDialog(RemoteControlNotifier notifier) {
    final textEditController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: AppColors.cyanAccent),
          ),
          title: Text(
            'ВВЕДЕННЯ ТЕКСТУ НА ПК',
            style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: AppColors.cyanAccent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Введений нижче текст буде послідовно надіслано на ваш ПК як натискання клавіш.',
                style: AppTextStyles.interBody(fontSize: 10.0, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: textEditController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Введіть текст...',
                  hintStyle: TextStyle(color: Colors.white30),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cyanAccent)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'СКАСУВАТИ',
                style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'НАДІСЛАТИ',
                style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.cyanAccent),
              ),
              onPressed: () {
                final txt = textEditController.text;
                if (txt.isNotEmpty) {
                  HapticFeedback.heavyImpact();
                  // Stream keys
                  for (int i = 0; i < txt.length; i++) {
                    notifier.sendKeyPress(txt[i]);
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
