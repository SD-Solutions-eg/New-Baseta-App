import 'dart:developer';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/otp/otp_screen.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:phone_number/phone_number.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _filedKey = GlobalKey<FormState>();

  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: vVeryLargeMargin),
            Image.asset(
              'assets/images/reset_password.png',
              height: 0.28.sh,
              width: 0.5.sw,
            ),
            SizedBox(height: vMediumMargin),
            Container(
              height: 0.66.sh,
              padding: EdgeInsets.symmetric(
                horizontal: hMediumPadding,
                vertical: vMediumPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(largeRadius),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: vMediumPadding),
                  Text(
                    CategoryCubit.appText!.sendingVerificationCode,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: vVerySmallPadding),
                  Container(
                    height: 7.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(smallRadius),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: vVeryLargePadding),
                  Text(
                    CategoryCubit.appText!.pleaseEnterYourNumberSentence,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          height: 1.3,
                          color: const Color(0xff505050).withOpacity(0.56),
                        ),
                  ),
                  SizedBox(height: vLargePadding),
                  Form(
                    key: _filedKey,
                    child: FilledTextFieldWithLabel(
                      controller: _phoneCtrl,
                      labelText: CategoryCubit.appText!.phone,
                      labelColor: Theme.of(context).colorScheme.primary,
                      hintText: CategoryCubit.appText!.phone,
                      keyboardType: TextInputType.phone,
                      inputAction: TextInputAction.done,
                      textDirection: TextDirection.ltr,
                      suffixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          ETagerIcons.phone,
                          size: 18.w,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CategoryCubit.appText!.filedIsRequired;
                        } else if (!phoneValidationRegExp.hasMatch(value)) {
                          return CategoryCubit.appText!.enterValidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: vVeryLargeMargin),
                  BlocConsumer<CustomerCubit, CustomerState>(
                    listener: (context, state) async =>
                        listenToMobileVerification(state, context),
                    builder: (context, state) {
                      return DefaultButton(
                        text: CategoryCubit.appText!.sendResetCode,
                        height: 55.h,
                        width: 235.w,
                        borderRadius: veryLargeRadius,
                        isLoading: state is SearchForUserLoading ||
                            state is SendSmsLoading,
                        onPressed: () async =>
                            _validateNumber(context, _phoneCtrl.text, state),
                      );
                    },
                  ),
                  SizedBox(height: vLargePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${CategoryCubit.appText!.haveAccount} '),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          CategoryCubit.appText!.login,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: vVeryLargeMargin),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> listenToMobileVerification(
      CustomerState state, BuildContext context) async {
    if (state is CheckOtpSuccess) {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.codeAndNewPass,
      );
    } else if (state is SendSmsSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OTPScreen(
              smsEgypt: true,
            ),
          ));
    } else if (state is SendSmsFailed) {
      customSnackBar(context: context, message: state.error);
    }
  }

  Future<void> _validateNumber(
    BuildContext context,
    String phone,
    CustomerState state,
  ) async {
    if (_filedKey.currentState != null && _filedKey.currentState!.validate()) {
      final validNumber = await PhoneNumberUtil().validate(phone, 'EG');
      if (validNumber) {
        final customerCubit = CustomerCubit.get(context);
        await customerCubit.searchForUserByMobileNumber(_phoneCtrl.text.trim());
        final userId = customerCubit.searchedForUserId;
        if (userId != null) {
          await _sendOTP(phone, context, state);
        } else {
          customSnackBar(
              context: context,
              message: 'There is no user with this phone number');
        }
      } else {
        customSnackBar(
          context: context,
          message: '$phone ${CategoryCubit.appText!.isInvalidNumber}',
        );
      }
    }
  }

  Future<void> _sendOTP(
      String phone, BuildContext context, CustomerState state) async {
    final phoneNumber = await PhoneNumberUtil().parse(phone, regionCode: 'EG');
    final customerCubit = CustomerCubit.get(context);
    log(phoneNumber.e164);
    if (state is! SendSmsSuccess ||
        customerCubit.phoneNumber != phoneNumber.e164) {
      customerCubit.phoneNumber = phoneNumber.e164;
      await customerCubit.sendSmsOtp(
        phoneNumber: phoneNumber.nationalNumber,
      );
    } else {
      if (state is! ReverifyPhoneSent) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OTPScreen(smsEgypt: true),
            ));
      }
    }
  }

  // Future<void> _submit(BuildContext context) async {
  //   if (_filedKey.currentState != null && _filedKey.currentState!.validate()) {
  //     await CustomerCubit.get(context)
  //         .sendResetPasswordEmail(email: _phoneCtrl.text.trim());
  //   }
  // }
}
