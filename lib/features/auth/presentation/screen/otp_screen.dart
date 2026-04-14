import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(value.length - 1);
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});
  }

  void _startTimer() {
    _seconds = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? 'Code resent successfully')),
        );
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.go(RouteNames.signUp)),
          const SizedBox(height: 48),

          AuthHeader(
            title: 'Enter OTP',
            subtitle:
                'We have just sent you 6 digit code via your\nemail ${widget.email}',
          ),

          const SizedBox(height: 28),

          /// OTP BOXES
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: 42,
                  height: 52,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF274777)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF274777),
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          /// RESEND
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                "Didn't receive code ? ",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              GestureDetector(
                onTap: _seconds == 0
                    ? () {
                        ref
                            .read(authControllerProvider.notifier)
                            .forgotPassword(email: widget.email);
                        _startTimer();
                      }
                    : null,
                child: Text(
                  _seconds == 0 ? 'Resend Code' : 'Resend in $_seconds s',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _seconds == 0
                        ? const Color(0xFF274777)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// ERROR
          if (state.errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.20)),
              ),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],

          /// CONTINUE BUTTON
          AuthPrimaryButton(
            text: 'Continue',
            isLoading: state.isLoading,
            onPressed: _otpCode.length == 6
                ? () {
                    context.push(
                      RouteNames.newPassword,
                      extra: {'email': widget.email, 'token': _otpCode},
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
