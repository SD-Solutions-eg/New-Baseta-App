import 'dart:developer';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/otp/otp_screen.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:allin1/presentation/widgets/widgetsClasses/widgets.dart';
import 'package:phone_number/phone_number.dart';

class CompleteUserDataScreen extends StatefulWidget {
  const CompleteUserDataScreen({Key? key, this.isPhoneAuth = false})
      : super(key: key);

  final bool isPhoneAuth;
  @override
  State<CompleteUserDataScreen> createState() => _CompleteUserDataScreenState();
}

class _CompleteUserDataScreenState extends State<CompleteUserDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  bool _isInit = false;
  late final CustomerCubit customerCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      customerCubit = CustomerCubit.get(context);
      final customer = FirebaseAuthBloc.currentUser;
      if (customer != null) {
        _firstNameCtrl.text = customer.firstName;
        _lastNameCtrl.text = customer.lastName;
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200.w,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(width: hMediumPadding),
              const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff909090),
              ),
              Text(
                CategoryCubit.appText!.back,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: const Color(0xff909090),
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hMediumPadding,
            vertical: vMediumPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login.png',
                height: 0.25.sh,
                // width: 0.6.sw,
              ),
              SizedBox(height: vVerySmallPadding),
              const UnderlineContainer(),
              SizedBox(height: vLargePadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FilledTextFieldWithLabel(
                      labelText: CategoryCubit.appText!.firstName,
                      labelColor: Theme.of(context).colorScheme.primary,
                      textDirection: TextDirection.ltr,
                      controller: _firstNameCtrl,
                      hintText: CategoryCubit.appText!.firstName,
                      capitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CategoryCubit.appText!.filedIsRequired;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vSmallPadding,
                    ),
                    FilledTextFieldWithLabel(
                      labelText: CategoryCubit.appText!.lastName,
                      labelColor: Theme.of(context).colorScheme.primary,
                      textDirection: TextDirection.ltr,
                      controller: _lastNameCtrl,
                      capitalization: TextCapitalization.words,
                      inputAction: widget.isPhoneAuth
                          ? TextInputAction.done
                          : TextInputAction.next,
                      hintText: CategoryCubit.appText!.lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CategoryCubit.appText!.filedIsRequired;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vSmallPadding,
                    ),
                    if (!widget.isPhoneAuth)
                      FilledTextFieldWithLabel(
                        labelText: CategoryCubit.appText!.phone,
                        labelColor: Theme.of(context).colorScheme.primary,
                        hintText: CategoryCubit.appText!.phone,
                        controller: _phoneCtrl,
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
                          if (value!.isEmpty) {
                            return CategoryCubit.appText!.filedIsRequired;
                          } else if (!phoneValidationRegExp.hasMatch(value)) {
                            return CategoryCubit.appText!.enterValidNumber;
                          }
                          return null;
                        },
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: vMediumMargin),
              BlocConsumer<CustomerCubit, CustomerState>(
                listener: (context, state) {
                  if (state is CustomerUpdateSuccess) {
                    tabController = null;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.homeLayout,
                      (route) => false,
                    );
                  } else if (state is CustomerUpdateFailed) {
                    customSnackBar(context: context, message: state.error);
                  } else if (state is SendSmsSuccess) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OTPScreen(
                            smsEgypt: true,
                          ),
                        ));
                  } else if (state is CheckOtpSuccess) {
                    Navigator.pop(context);
                    customerCubit.updateCustomerName(
                      firstName: _firstNameCtrl.text,
                      lastName: _lastNameCtrl.text,
                    );
                    customerCubit.updateUserMobile(
                        id: FirebaseAuthBloc.currentUser!.id,
                        mobile: _phoneCtrl.text);
                  } else if (state is SendSmsFailed) {
                    customSnackBar(context: context, message: state.error);
                  }
                },
                builder: (context, state) {
                  return DefaultButton(
                      text: CategoryCubit.appText!.confirm,
                      height: 50.h,
                      width: 0.4.sw,
                      borderRadius: largeRadius,
                      isLoading: state is SendSmsLoading ||
                          state is CustomerUpdateLoading ||
                          state is UpdateUserMobileLoading,
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          if (!widget.isPhoneAuth) {
                            if (state is! SendSmsSuccess) {
                              final validNumber = await PhoneNumberUtil()
                                  .validate(_phoneCtrl.text, 'EG');
                              if (validNumber) {
                                log('Is Valid Number true');
                                final phoneNumber = await PhoneNumberUtil()
                                    .parse(_phoneCtrl.text, regionCode: 'EG');
                                await customerCubit.sendSmsOtp(
                                  phoneNumber: phoneNumber.nationalNumber,
                                );
                              } else {
                                log('Invalid Number');
                                customSnackBar(
                                  context: context,
                                  message:
                                      '$_phoneCtrl.text ${CategoryCubit.appText!.isInvalidNumber}',
                                );
                              }
                            } else {
                              log('State is VerifyPhoneSent');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OTPScreen(smsEgypt: true),
                                  ));
                            }
                          } else {
                            await customerCubit.updateCustomerName(
                              firstName: _firstNameCtrl.text,
                              lastName: _lastNameCtrl.text,
                            );
                          }
                        }
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
