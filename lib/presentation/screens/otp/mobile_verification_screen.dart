import 'dart:developer';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/countryPicker/country_picker.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:allin1/presentation/widgets/widgetsClasses/widgets.dart';
import 'package:phone_number/phone_number.dart';

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen({Key? key}) : super(key: key);

  @override
  State<MobileVerificationScreen> createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  String regionCode = 'EG';
  String phoneNumberE164 = '';
  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hMediumPadding,
              vertical: vMediumPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/otp.png',
                  height: 0.4.sh,
                  width: 0.6.sw,
                ),
                Text(
                  CategoryCubit.appText!.mobileVerification,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: vVerySmallPadding),
                const UnderlineContainer(),
                SizedBox(height: vLargePadding),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                  child: Text(
                    CategoryCubit.appText!.pleaseEnterYourNumberSentence,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: const Color(0xff505050),
                          height: 1.3,
                        ),
                  ),
                ),
                SizedBox(height: vVeryLargePadding),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    CategoryCubit.appText!.phone,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                SizedBox(height: vVerySmallPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 53.h,
                        decoration: BoxDecoration(
                          color: authBackgroundColor,
                          borderRadius: BorderRadius.circular(verySmallRadius),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: hVerySmallPadding),
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 28.w,
                              color: Colors.grey.shade600,
                            ),
                            Expanded(
                              child: MyCountryPicker(
                                initialSelection: regionCode,
                                onSelected: (countryCode) {
                                  regionCode = countryCode.code!;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: hSmallPadding),
                    Expanded(
                      flex: 5,
                      child: Form(
                        key: formKey,
                        child: FilledTextFieldWithLabel(
                          inputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          height: 90.h,
                          forceHeight: true,
                          style: Theme.of(context).textTheme.headline4,
                          hintSize:
                              Theme.of(context).textTheme.headline4!.fontSize,
                          controller: phoneCtrl,
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
                    ),
                  ],
                ),
                SizedBox(height: vVeryLargePadding),
                BlocConsumer<CustomerCubit, CustomerState>(
                  listener: (context, state) async {
                    if (state is VerifyOTPSuccess) {
                      final customer = FirebaseAuthBloc.currentUser!;

                      await CustomerCubit.get(context).updateUser(customer);
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.verificationSuccess,
                      );
                    } else if (state is VerifyPhoneSent) {
                      Navigator.pushNamed(context, AppRouter.otp);
                    }
                  },
                  builder: (context, state) {
                    return DefaultButton(
                      text: CategoryCubit.appText!.sendingVerificationCode,
                      smallSize: true,
                      height: 55.h,
                      width: 235.w,
                      borderRadius: largeRadius,
                      isLoading: state is VerifyPhoneLoading,
                      onPressed: () async =>
                          _sendCode(context, phoneCtrl.text, state),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendCode(
    BuildContext context,
    String phone,
    CustomerState state,
  ) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final validNumber = await PhoneNumberUtil().validate(phone, regionCode);
      if (validNumber) {
        final phoneNumber =
            await PhoneNumberUtil().parse(phone, regionCode: regionCode);
        final customerCubit = CustomerCubit.get(context);
        log(phoneNumber.e164);
        if (state is! VerifyPhoneSent ||
            customerCubit.phoneNumber != phoneNumber.e164) {
          customerCubit.phoneNumber = phoneNumber.e164;
          await customerCubit.verifyPhoneNumber(phoneNumber: phoneNumber.e164);
        } else {
          if (state is! ReverifyPhoneSent) {
            Navigator.pushNamed(context, AppRouter.otp);
          }
        }
      } else {
        customSnackBar(
          context: context,
          message: '$phone ${CategoryCubit.appText!.isInvalidNumber}',
        );
      }
    }
  }
}
