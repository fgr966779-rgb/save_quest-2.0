import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

class BiometricVaultScreen extends ConsumerStatefulWidget {
  const BiometricVaultScreen({super.key});

  @override
  ConsumerState<BiometricVaultScreen> createState() => _BiometricVaultScreenState();
}

class _BiometricVaultScreenState extends ConsumerState<BiometricVaultScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool _isTimeLocked = true;
  Timer? _timer;
  int _remainingSeconds = 86400; // 24 hours lock

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isTimeLocked = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan fingerprint or face to bypass the vault lock',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated && mounted) {
        Navigator.pop(context, true);
        return;
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Access Granted' : 'Access Denied';
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - $e';
      });
      return;
    }
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BIOMETRIC VAULT',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _authorized == 'Access Granted' ? Icons.lock_open : Icons.lock_outline,
              size: 100,
              color: _authorized == 'Access Granted' ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(height: 30),
            if (_isTimeLocked && _authorized != 'Access Granted') ...[
              Text(
                'TIME LOCK ACTIVE',
                style: GoogleFonts.orbitron(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _formatTime(_remainingSeconds),
                style: GoogleFonts.shareTechMono(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Bypass with Biometrics:',
                style: GoogleFonts.shareTechMono(color: Colors.white70),
              ),
            ] else ...[
              Text(
                'VAULT UNLOCKED',
                style: GoogleFonts.orbitron(
                  color: Colors.greenAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  foregroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: const BorderSide(color: Colors.greenAccent),
                ),
                child: Text('PROCEED', style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
              ),
            ],
            const SizedBox(height: 30),
            if (_isTimeLocked)
              ElevatedButton.icon(
                onPressed: _isAuthenticating || _authorized == 'Access Granted' ? null : _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: Text(
                  _isAuthenticating ? 'Scanning...' : 'AUTHORIZE',
                  style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.withValues(alpha: 0.2),
                  foregroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: const BorderSide(color: Colors.cyanAccent),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _authorized,
              style: GoogleFonts.shareTechMono(
                color: _authorized == 'Access Granted' ? Colors.green : Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
