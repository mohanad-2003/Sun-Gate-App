import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final OtpFlowType flowType;

  const OtpScreen({super.key, required this.email, required this.flowType});

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
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
        setState(() => _seconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (!next.isSuccess) return;

      if (widget.flowType == OtpFlowType.verifyEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully')),
        );
        context.go(RouteNames.login);
      } else {
        if (next.resetToken?.isNotEmpty ?? false) {
          context.push(
            RouteNames.newPassword,
            extra: {'email': widget.email, 'token': next.resetToken!},
          );
        }
      }
    });

    return AuthScaffoldBody(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            AuthBackButton(onTap: () => context.go(RouteNames.signUp)),

            const SizedBox(height: 48),

            AuthHeader(
              title: 'Enter OTP',
              subtitle: 'We sent a code to\n${widget.email}',
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;

                double itemWidth = (totalWidth - 60) / 6;

                itemWidth = itemWidth.clamp(40, 55);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: itemWidth,
                        height: 52,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF274777),
                              ),
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
                );
              },
            ),

            const SizedBox(height: 18),

            /// RESEND
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  'Didn’t receive code? ',
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
                    _seconds == 0 ? 'Resend' : 'Resend in $_seconds s',
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

            if (state.errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],

            AuthPrimaryButton(
              text: 'Continue',
              isLoading: state.isLoading,
              onPressed: _otpCode.length == 6
                  ? () async {
                      if (widget.flowType == OtpFlowType.verifyEmail) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .verifyEmail(email: widget.email, code: _otpCode);
                      } else {
                        await ref
                            .read(authControllerProvider.notifier)
                            .verifyOtp(email: widget.email, code: _otpCode);
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
