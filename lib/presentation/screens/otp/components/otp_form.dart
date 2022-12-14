// ignore_for_file: avoid_multiple_declarations_per_line

import 'dart:async';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';

class OtpForm extends StatefulWidget {
  final String phone;
  final bool smsEgypt;
  const OtpForm({
    Key? key,
    required this.phone,  required this.smsEgypt,
  }) : super(key: key);
  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> with AutomaticKeepAliveClientMixin {
  late final FocusNode node1, node2, node3, node4, node5, node6;
  late final TextEditingController ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6;
  Map<String, String> otpMap = {};
  bool resendCode = false;
  String? verificationCode;
  String appSignature = '';
  bool deniedPermission = false;

  @override
  void initState() {
    node1 = FocusNode();
    node2 = FocusNode();
    node3 = FocusNode();
    node4 = FocusNode();
    node5 = FocusNode();
    node6 = FocusNode();
    ctrl1 = TextEditingController();
    ctrl2 = TextEditingController();
    ctrl3 = TextEditingController();
    ctrl4 = TextEditingController();
    ctrl5 = TextEditingController();
    ctrl6 = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    node1.dispose();
    node2.dispose();
    node3.dispose();
    node4.dispose();
    node5.dispose();
    node6.dispose();
    super.dispose();
  }

  void nextFocus(String value, FocusNode node, String index) {
    if (value.length == 1) {
      node.requestFocus();
      otpMap[index] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is ReverifyPhoneSent) {
          Navigator.pushReplacementNamed(
            context,
            AppRouter.otp,
            arguments: widget.phone,
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNumberField(
                    firstNode: true,
                    ctrl: ctrl1,
                    node: node1,
                    onChange: (value) {
                      if (value.trim().isNotEmpty) {
                        ctrl2.clear();
                        nextFocus(value, node2, '1');
                      }
                    },
                  ),
                  buildNumberField(
                    ctrl: ctrl2,
                    node: node2,
                    onChange: (value) {
                      if (value.trim().isNotEmpty) {
                        ctrl3.clear();
                        nextFocus(value, node3, '2');
                      } else {
                        nextFocus(value, node1, '0');
                      }
                    },
                  ),
                  buildNumberField(
                    ctrl: ctrl3,
                    node: node3,
                    onChange: (value) {
                      if (value.trim().isNotEmpty) {
                        ctrl4.clear();
                        nextFocus(value, node4, '3');
                      } else {
                        nextFocus(value, node2, '1');
                      }
                    },
                  ),
                  buildNumberField(
                    ctrl: ctrl4,
                    node: node4,
                    onChange: (String value) {
                      if (value.trim().isNotEmpty) {
                        ctrl5.clear();
                        nextFocus(value, node5, '4');
                      } else {
                        nextFocus(value, node3, '2');
                      }
                    },
                  ),
                  buildNumberField(
                    ctrl: ctrl5,
                    node: node5,
                    onChange: (String value) {
                      if (value.trim().isNotEmpty) {
                        ctrl6.clear();
                        nextFocus(value, node6, '5');
                      } else {
                        nextFocus(value, node4, '3');
                      }
                    },
                  ),
                  buildNumberField(
                    ctrl: ctrl6,
                    node: node6,
                    onChange: (String value) async {
                      if (value.length == 1) {
                        otpMap['6'] = value;
                        FocusScope.of(context).unfocus();
                      } else {
                        nextFocus(value, node5, '4');
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: vMediumPadding),
            if (state is VerifyPhoneFailed)
              Text(
                state.error,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.red),
              ),
            SizedBox(height: vMediumMargin),
            DefaultButton(
              text: CategoryCubit.appText!.confirm,
              height: 50.h,
              width: 0.4.sw,
              borderRadius: largeRadius,
              onPressed: () async => _submitOTP(state),
              isLoading: state is VerifyOTPLoading || state is VerifyOTPSuccess
              || state is CheckOtpLoading,
            ),
            SizedBox(height: vMediumMargin),
            buildTimer(),
            TextButton(
              onPressed: resendCode && (state is! ReverifyPhoneLoading || state is! SendSmsLoading)
                  ? () async =>
                      widget.smsEgypt?
        CustomerCubit.get(context).sendSmsOtp(phoneNumber: widget.phone)
        :CustomerCubit.get(context).resendVerificationCode()
                  : null,
              child: Text(
                CategoryCubit.appText!.resendCode,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: resendCode && (state is! ReverifyPhoneLoading || state is! SendSmsLoading)
                          ? Theme.of(context).colorScheme.primary
                          : iconGreyColor,
                    ),
              ),
            ),
            SizedBox(height: vVeryLargeMargin),
          ],
        );
      },
    );
  }

  Future<void> _submitOTP(CustomerState state) async {
    final code = [
      ctrl1.text,
      ctrl2.text,
      ctrl3.text,
      ctrl4.text,
      ctrl5.text,
      ctrl6.text
    ].join();
    // final code = otpMap.values.join();
    FocusScope.of(context).unfocus();
    widget.smsEgypt
        ?await CustomerCubit.get(context).checkSmsOtp(phoneNumber: widget.phone, otp: code)
        :await CustomerCubit.get(context).verifyOTP(code);
  }

  Expanded buildNumberField({
    required void Function(String) onChange,
    FocusNode? node,
    bool firstNode = false,
    required TextEditingController ctrl,
  }) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: hVerySmallPadding * 0.5),
        child: FilledTextFieldWithLabel(
          controller: ctrl,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          height: 60.w,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                fontFamily: 'Roboto',
              ),
          onTap: () => ctrl.clear(),
          maxLength: 1,
          counterText: '',
          onChange: onChange,
          focusNode: node,
          autofocus: firstNode,
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(CategoryCubit.appText!.resendCode),
        SizedBox(width: hVerySmallPadding),
        TweenAnimationBuilder<double>(
          duration: const Duration(seconds: 59),
          tween: Tween<double>(begin: 59.0, end: 0.0),
          onEnd: () => setState(() => resendCode = true),
          builder: (context, value, child) {
            final oneChar = value.toInt().toString().length < 2;
            final time = value.toInt();

            return Text(
              oneChar ? "00:0$time" : "00:$time",
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
