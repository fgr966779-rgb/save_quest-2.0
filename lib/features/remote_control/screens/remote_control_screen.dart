import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/l10n.dart';
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
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    final state = ref.watch(remoteControlProvider);
    final notifier = ref.read(remoteControlProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          AppLocalizations.get(locale, 'remote_title'),
          style: AppTypography.h3(context, color: AppColors.accent),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary(brightness)),
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
                color: AppColors.accent,
              ),
              tooltip: AppLocalizations.get(locale, _directTouchMode ? 'remote_mode_direct' : 'remote_mode_trackpad'),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _directTouchMode = !_directTouchMode);
              },
            ),
            IconButton(
              icon: const Icon(Icons.flash_on, color: AppColors.warning),
              tooltip: AppLocalizations.get(locale, 'remote_latency'),
              onPressed: () {
                notifier.measureLatency();
              },
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: AppColors.error),
              tooltip: AppLocalizations.get(locale, 'remote_disconnect'),
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
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

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
                color: AppColors.accent.withOpacity(0.08),
                border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2.0),
              ),
              child: Icon(Icons.terminal, color: AppColors.accent, size: 48.0),
            ),
          ),
          const SizedBox(height: 24.0),
          Center(
            child: Text(
              'VAULT-17 LINK PORTAL',
              style: AppTypography.h2(context),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              AppLocalizations.get(locale, 'remote_desc'),
              textAlign: TextAlign.center,
              style: AppTypography.body(
                context,
                color: AppColors.textSecondary(brightness),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          
          if (state.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.error.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: AppTypography.bodySmall(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],

          SurfaceCard(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(
                  label: AppLocalizations.get(locale, 'remote_ip_label'),
                  controller: _ipController,
                  hint: '192.168.1.100',
                  icon: Icons.wifi,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  label: AppLocalizations.get(locale, 'remote_port_label'),
                  controller: _portController,
                  hint: '8080',
                  icon: Icons.settings_ethernet,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  label: AppLocalizations.get(locale, 'remote_pin_label'),
                  controller: _passwordController,
                  hint: AppLocalizations.get(locale, 'remote_pin_hint'),
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          
          _isConnecting 
              ? Center(child: CircularProgressIndicator(color: AppColors.accent))
              : AppButton(
                  label: AppLocalizations.get(locale, 'remote_connect_btn'),
                  variant: ButtonVariant.primary,
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
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

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
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    AppLocalizations.get(locale, 'remote_connected'),
                    style: AppTypography.overline(context, color: AppColors.success),
                  ),
                ],
              ),
              Text(
                '${AppLocalizations.get(locale, 'remote_ping')}${state.latency}${AppLocalizations.get(locale, 'remote_ping_ms')}',
                style: AppTypography.overline(context, color: AppColors.textSecondary(brightness)),
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.get(locale, 'remote_quality'),
                    style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                  ),
                  DropdownButton<int>(
                    value: state.quality,
                    dropdownColor: AppColors.surface(brightness),
                    style: AppTypography.overline(context, color: AppColors.accent),
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
              border: Border.all(color: AppColors.borderStrong(brightness), width: 2.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: state.frameBytes == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.accent),
                        const SizedBox(height: 16.0),
                        Text(
                          AppLocalizations.get(locale, 'remote_streaming'),
                          style: TextStyle(color: AppColors.textTertiary(brightness), fontSize: 12.0),
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

        // Controller quick bar
        _buildQuickControllerSheet(notifier),
      ],
    );
  }

  Widget _buildQuickControllerSheet(RemoteControlNotifier notifier) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        border: Border(top: BorderSide(color: AppColors.border(brightness))),
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
                VerticalDivider(color: AppColors.borderStrong(brightness), width: 1),
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
                    icon: const Icon(Icons.arrow_downward_rounded, color: AppColors.goalB),
                    tooltip: AppLocalizations.get(locale, 'remote_scroll_down'),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      notifier.sendMouseScroll(-120);
                    },
                  ),
                  Icon(Icons.unfold_more_rounded, color: AppColors.textTertiary(brightness), size: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, color: AppColors.accent),
                    tooltip: AppLocalizations.get(locale, 'remote_scroll_up'),
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
                    icon: Icon(Icons.arrow_left, color: AppColors.textPrimary(brightness)),
                    onPressed: () => _sendKeyPressWithModifiers('left'),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up, color: AppColors.textPrimary(brightness)),
                        onPressed: () => _sendKeyPressWithModifiers('up'),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary(brightness)),
                        onPressed: () => _sendKeyPressWithModifiers('down'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right, color: AppColors.textPrimary(brightness)),
                    onPressed: () => _sendKeyPressWithModifiers('right'),
                  ),
                ],
              ),
              
              // Full Text Input keyboard dialog
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  side: BorderSide(color: AppColors.accent),
                ),
                icon: Icon(Icons.keyboard, color: AppColors.accent, size: 18),
                label: Text(
                  AppLocalizations.get(locale, 'remote_text_btn'),
                  style: AppTypography.overline(context, color: AppColors.accent),
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
    final brightness = Theme.of(context).brightness;
    final bool isActive = _activeModifiers.contains(modifierKey);
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTypography.overline(
            context,
            color: isActive ? Colors.black : AppColors.textPrimary(brightness),
          ),
        ),
        selected: isActive,
        selectedColor: AppColors.accent,
        backgroundColor: AppColors.surfaceMuted(brightness),
        onSelected: (_) => _toggleModifier(modifierKey),
      ),
    );
  }

  Widget _buildShortcutButton(String key, String label) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        backgroundColor: AppColors.surfaceMuted(brightness),
        label: Text(
          label,
          style: AppTypography.overline(context, color: AppColors.textPrimary(brightness)),
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
    final brightness = Theme.of(context).brightness;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTypography.caption(
            context,
            color: AppColors.textSecondary(brightness),
          ),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: TextStyle(color: AppColors.textPrimary(brightness), fontSize: 13.0),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textTertiary(brightness).withOpacity(0.5)),
            prefixIcon: Icon(icon, color: AppColors.accent, size: 18.0),
            filled: true,
            fillColor: AppColors.surfaceMuted(brightness),
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
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    final textEditController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.accent),
          ),
          title: Text(
            AppLocalizations.get(locale, 'remote_text_dialog_title'),
            style: AppTypography.h3(context, color: AppColors.accent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.get(locale, 'remote_text_dialog_desc'),
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: textEditController,
                autofocus: true,
                style: TextStyle(color: AppColors.textPrimary(brightness)),
                decoration: InputDecoration(
                  hintText: AppLocalizations.get(locale, 'remote_text_hint'),
                  hintStyle: TextStyle(color: AppColors.textTertiary(brightness)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border(brightness))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.get(locale, 'common_cancel'),
                style: AppTypography.body(context, color: AppColors.textSecondary(brightness)),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                AppLocalizations.get(locale, 'remote_send_btn'),
                style: AppTypography.body(context, color: AppColors.accent),
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
