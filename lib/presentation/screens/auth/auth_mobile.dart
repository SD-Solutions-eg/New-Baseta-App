import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/logic/cubit/apple/apple_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/auth/complete_data_screen.dart';
import 'package:allin1/presentation/screens/otp/otp_screen.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/social_login_button.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:phone_number/phone_number.dart';

class AuthScreenMobile extends StatefulWidget {
  @override
  _AuthScreenMobileState createState() => _AuthScreenMobileState();
}

class _AuthScreenMobileState extends State<AuthScreenMobile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameOrEmailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoginMode = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool rememberMe = true;
  bool resetPassword = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _usernameOrEmailCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRouter.homeLayout, (_) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 200,
          toolbarHeight: 45.w,
          leading: InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRouter.homeLayout, (_) => false);
            },
            child: Row(
              children: [
                SizedBox(width: hLargePadding),
                Icon(
                  Icons.arrow_back_ios,
                  size: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: hSmallPadding),
                Text(
                  CategoryCubit.appText!.back,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: vLargeMargin),
              SlideInDown(
                key: Key(_isLoginMode.toString()),
                preferences: const AnimationPreferences(
                  duration: Duration(milliseconds: 500),
                ),
                child: Container(
                  width: double.infinity,
                  height: 90.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding, vertical: vMediumPadding),
                  child: DefaultButton(
                    text: '',
                    onPressed: () =>
                        setState(() => _isLoginMode = !_isLoginMode),
                    width: double.infinity,
                    buttonColor: Colors.black,
                    child: _isLoginMode
                        ? RichText(
                            text: TextSpan(
                                text: CategoryCubit.appText!.newUser,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                                children: [
                                  TextSpan(
                                      text:
                                          '  ${CategoryCubit.appText!.createAccount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Colors.white,
                                          )),
                                ]),
                          )
                        : RichText(
                            text: TextSpan(
                                text: CategoryCubit.appText!.haveAccount,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                                children: [
                                  TextSpan(
                                      text:
                                          '  ${CategoryCubit.appText!.signIn}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Colors.white,
                                          )),
                                ]),
                          ),
                  ),
                ),
              ),
              SizedBox(height: vSmallMargin),
              if (_isLoginMode)
                SlideInUp(
                  key: const Key('login'),
                  preferences: const AnimationPreferences(
                    duration: Duration(milliseconds: 500),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                    child: Text(
                      CategoryCubit.appText!.signIn,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                )
              else ...[
                SlideInUp(
                  key: const Key('register'),
                  preferences: const AnimationPreferences(
                    duration: Duration(milliseconds: 500),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                    child: Text(
                      CategoryCubit.appText!.createAccount,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
              ],
              Column(
                children: [
                  SizedBox(height: vVeryLargeMargin),
                  if (_isLoginMode)
                    Padding(
                      padding: ScreenUtil().screenWidth > 600
                          ? EdgeInsets.symmetric(horizontal: hLargePadding)
                          : EdgeInsets.zero,
                      child: buildLoginAuth(context),
                    )
                  else
                    Padding(
                      padding: ScreenUtil().screenWidth > 600
                          ? EdgeInsets.symmetric(horizontal: hLargePadding)
                          : EdgeInsets.zero,
                      child: buildRegisterAuth(context),
                    ),
                ],
              )
            ],
          ),
        ),
        // bottomNavigationBar: SlideInUp(
        //   key: Key(_isLoginMode.toString()),
        //   preferences: const AnimationPreferences(
        //     duration: Duration(milliseconds: 500),
        //   ),
        //   child: Container(
        //     width: double.infinity,
        //     height: 90.w,
        //     padding: EdgeInsets.symmetric(
        //         horizontal: hMediumPadding, vertical: vMediumPadding),
        //     child: DefaultButton(
        //       text: '',
        //       onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
        //       width: double.infinity,
        //       buttonColor: lightBgGrey,
        //       child: _isLoginMode
        //           ? RichText(
        //               text: TextSpan(
        //                   text: CategoryCubit.appText!.newUser,
        //                   style:
        //                       Theme.of(context).textTheme.subtitle1!.copyWith(
        //                             color: darkGrey,
        //                           ),
        //                   children: [
        //                     TextSpan(
        //                         text:
        //                             '  ${CategoryCubit.appText!.createAccount}',
        //                         style: Theme.of(context)
        //                             .textTheme
        //                             .subtitle1!
        //                             .copyWith(
        //                               color:
        //                                   Theme.of(context).colorScheme.primary,
        //                             )),
        //                   ]),
        //             )
        //           : RichText(
        //               text: TextSpan(
        //                   text: CategoryCubit.appText!.haveAccount,
        //                   style:
        //                       Theme.of(context).textTheme.subtitle1!.copyWith(
        //                             color: darkGrey,
        //                           ),
        //                   children: [
        //                     TextSpan(
        //                         text: '  ${CategoryCubit.appText!.signIn}',
        //                         style: Theme.of(context)
        //                             .textTheme
        //                             .subtitle1!
        //                             .copyWith(
        //                               color:
        //                                   Theme.of(context).colorScheme.primary,
        //                             )),
        //                   ]),
        //             ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  void changeAuthMode({required bool isLogin}) {
    _usernameOrEmailCtrl.clear();
    _usernameCtrl.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    setState(() => _isLoginMode = isLogin);
  }

  Widget buildAppleButton() {
    return BlocConsumer<AppleCubit, AppleState>(
      listener: (context, state) {
        if (state is AppleSignInSuccess) {
          if (FirebaseAuthBloc.currentUser != null) {
            if (FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.deliveryLayout,
                (route) => false,
              );
            } else {
              // if (AppleCubit.isNewUser) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const CompleteUserDataScreen(),
              //       ));
              // } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.homeLayout,
                (route) => false,
              );
              // }
            }
          }
        } else if (state is AppleSignInFailed) {
          if (state.error.contains('Cancelled')) {
            return;
          } else {
            final error = state.error.contains('Null')
                ? CategoryCubit.appText!.failedToLogin
                : state.error;
            customSnackBar(context: context, message: error);
          }
        }
      },
      builder: (context, state) {
        final appleCubit = AppleCubit.get(context);

        if (appleCubit.isAvailable) {
          return InkWell(
            onTap: () async => appleCubit.appleLogin(),
            borderRadius: BorderRadius.circular(verySmallRadius),
            child: SocialLoginButton(
              socialTitle: 'Apple',
              imagePath: 'assets/images/apple.png',
              loadingAnimationPath: '',
              loadingWidget: CupertinoActivityIndicator(radius: 18.r),
              isLoading: state is AppleSignInLoading,
              color: Colors.black,
            ),
          );
        } else {
          return const Offstage();
        }
      },
    );
  }

  Widget buildFacebookButton() {
    return BlocConsumer<FacebookCubit, FacebookState>(
      listener: (context, state) {
        if (state is FacebookSuccess) {
          if (FirebaseAuthBloc.currentUser != null) {
            if (FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.deliveryLayout,
                (route) => false,
              );
            } else {
              if (FacebookCubit.isNewUser) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteUserDataScreen(),
                    ));
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.homeLayout,
                  (route) => false,
                );
              }
            }
          }
        } else if (state is FacebookFailed) {
          if (state.error.contains('Cancelled')) {
            return;
          } else {
            final error = state.error.contains('Null')
                ? CategoryCubit.appText!.failedToLogin
                : state.error;
            customSnackBar(context: context, message: error);
          }
        }
      },
      builder: (context, state) => InkWell(
        onTap: state is FacebookLoading
            ? null
            : () async => FacebookCubit.get(context).facebookLogin(),
        borderRadius: BorderRadius.circular(smallRadius),
        child: SocialLoginButton(
          socialTitle: 'Facebook',
          imagePath: 'assets/images/facebook.png',
          loadingAnimationPath: 'assets/animations/facebook_loading.json',
          isLoading: state is FacebookLoading,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget buildGoogleButton() {
    return BlocConsumer<GoogleCubit, GoogleState>(
      listener: (context, state) {
        if (state is GoogleSuccess) {
          if (FirebaseAuthBloc.currentUser != null) {
            if (FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.deliveryLayout,
                (route) => false,
              );
            } else {
              if (GoogleCubit.isNewUser) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteUserDataScreen(),
                    ));
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.homeLayout,
                  (route) => false,
                );
              }
            }
          }
        } else if (state is GoogleFailed) {
          if (state.error == 'CANCELLED') {
            return;
          } else {
            final error = state.error.contains('Null')
                ? CategoryCubit.appText!.failedToLogin
                : state.error;
            customSnackBar(context: context, message: error);
          }
        } else if (state is GoogleCancelled) {}
      },
      builder: (context, state) => InkWell(
        onTap: state is GoogleLoading
            ? null
            : () async => GoogleCubit.get(context).googleLogin(),
        borderRadius: BorderRadius.circular(smallRadius),
        child: SocialLoginButton(
          socialTitle: 'Google',
          imagePath: 'assets/images/google.png',
          loadingAnimationPath: 'assets/animations/google_loading.json',
          isLoading: state is GoogleLoading,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget buildLoginAuth(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess || state is LoginUnverified) {
          if (FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.deliveryLayout,
              (route) => false,
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.homeLayout,
              (route) => false,
            );
          }
        } else if (state is LoginFailed) {
          final error = state.error.contains('Null')
              ? CategoryCubit.appText!.failedToLogin
              : state.error;
          customSnackBar(context: context, message: error);
          print('Error : ${state.error}');
        }
      },
      builder: (context, state) => SlideInUp(
        preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 600),
        ),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: _loginForm(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 600
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vMediumPadding,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) =>
                            setState(() => rememberMe = value!),
                        activeColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(verySmallRadius * 0.7),
                        ),
                      ),
                      Text(
                        CategoryCubit.appText!.rememberMe,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: isDark ? null : Colors.black87,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.resetPassword),
                    child: Text(
                      CategoryCubit.appText!.forgetPassword,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
              child: DefaultButton(
                text: CategoryCubit.appText!.signIn,
                width: double.infinity,
                borderRadius: smallRadius,
                isLoading: state is LoginLoading,
                onPressed: submit,
              ),
            ),
            SizedBox(height: vMediumPadding),
            Text(CategoryCubit.appText!.byLogin),
            SizedBox(height: vVerySmallPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final customerCubit = CustomerCubit.get(context);
                    showLoadingDialog(context);
                    await customerCubit.getTermsAndConditions();
                    Navigator.pop(context);
                    if (customerCubit.terms != null) {
                      buildPolicyBottomSheet(
                        context,
                        title: CategoryCubit.appText!.termsAndConditions,
                        policyModel: customerCubit.terms!,
                      );
                    }
                  },
                  child: Text(
                    CategoryCubit.appText!.termsAndConditions,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Text('  ${CategoryCubit.appText!.and}  '),
                InkWell(
                  onTap: () async {
                    final customerCubit = CustomerCubit.get(context);
                    showLoadingDialog(context);
                    await customerCubit.getPrivacyPolicy();
                    Navigator.pop(context);
                    if (customerCubit.privacyPolicy != null) {
                      buildPolicyBottomSheet(
                        context,
                        title: CategoryCubit.appText!.privacyPolicy,
                        policyModel: customerCubit.privacyPolicy!,
                      );
                    }
                  },
                  child: Text(
                    CategoryCubit.appText!.privacyPolicy,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: vVeryLargePadding),
            Text(
              CategoryCubit.appText!.orSignInWith,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: darkGrey,
                  ),
            ),
            SizedBox(height: vMediumPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (Platform.isIOS) ...[
                  buildAppleButton(),
                  SizedBox(width: hMediumMargin),
                ],
                buildGoogleButton(),
                SizedBox(width: hMediumMargin),
                buildFacebookButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterAuth(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CompleteUserDataScreen(isPhoneAuth: true),
              ));
        } else if (state is RegistrationFailed) {
          final error = state.error.contains('Null')
              ? CategoryCubit.appText!.failedToLogin
              : state.error;
          customSnackBar(context: context, message: error);
          log('Error : ${state.error}');
        }
      },
      builder: (context, registerState) => SlideInUp(
        preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 400),
        ),
        key: const Key('Register'),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: _registerForm(),
            ),
            SizedBox(height: vMediumMargin),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
              child: BlocConsumer<CustomerCubit, CustomerState>(
                listener: (context, state) async {
                  if (state is SendSmsSuccess) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OTPScreen(
                            smsEgypt: true,
                          ),
                        ));
                  } else if (state is CheckOtpSuccess) {
                    Navigator.pop(context);
                    await RegistrationCubit.get(context).registerUser(
                      context,
                      phone: _phoneCtrl.text,
                      password: _passwordCtrl.text,
                    );

                    // await CustomerCubit.get(context).updateUserMobile(
                    //     id: FirebaseAuthBloc.currentUser!.id,
                    //     mobile: _phoneCtrl.text);
                  } else if (state is SendSmsFailed) {
                    customSnackBar(context: context, message: state.error);
                  } else if (state is CheckOtpFailed) {
                    customSnackBar(context: context, message: state.error);
                  }
                },
                builder: (context, customerState) {
                  return DefaultButton(
                    text: CategoryCubit.appText!.register,
                    width: double.infinity,
                    borderRadius: smallRadius,
                    isLoading: registerState is RegistrationLoading ||
                        customerState is SendSmsLoading ||
                        customerState is UpdateUserMobileLoading,
                    onPressed: submit,
                  );
                },
              ),
            ),
            SizedBox(height: vMediumPadding),
            SizedBox(height: vLargePadding),
            Text(CategoryCubit.appText!.byRegister),
            SizedBox(height: vVerySmallPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final customerCubit = CustomerCubit.get(context);
                    showLoadingDialog(context);
                    await customerCubit.getTermsAndConditions();
                    Navigator.pop(context);
                    if (customerCubit.terms != null) {
                      buildPolicyBottomSheet(
                        context,
                        title: CategoryCubit.appText!.termsAndConditions,
                        policyModel: customerCubit.terms!,
                      );
                    }
                  },
                  child: Text(
                    CategoryCubit.appText!.termsAndConditions,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
                Text('  ${CategoryCubit.appText!.and}  '),
                InkWell(
                  onTap: () async {
                    final customerCubit = CustomerCubit.get(context);
                    showLoadingDialog(context);
                    await customerCubit.getPrivacyPolicy();
                    Navigator.pop(context);
                    if (customerCubit.privacyPolicy != null) {
                      await buildPolicyBottomSheet(
                        context,
                        title: CategoryCubit.appText!.privacyPolicy,
                        policyModel: customerCubit.privacyPolicy!,
                      );
                    }
                  },
                  child: Text(
                    CategoryCubit.appText!.privacyPolicy,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
      ),
      child: Column(
        children: [
          FilledTextFieldWithLabel(
            key: const Key('phone'),
            labelText: CategoryCubit.appText!.phone,
            labelColor: Theme.of(context).colorScheme.primary,
            hintText: CategoryCubit.appText!.phone,
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
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
          ),
          SizedBox(height: vSmallMargin),
          FilledTextFieldWithLabel(
            key: const Key('password'),
            labelText: CategoryCubit.appText!.pass,
            labelColor: Theme.of(context).colorScheme.primary,
            controller: _passwordCtrl,
            obscureText: !_showPassword,
            textDirection: TextDirection.ltr,
            inputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: () => setState(() => _showPassword = !_showPassword),
              canRequestFocus: false,
              child: Icon(
                _showPassword ? ETagerIcons.eye_slash : ETagerIcons.eye,
                size: 18,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return CategoryCubit.appText!.pleaseEnterPass;
              }
              if (value.length < 6) {
                return CategoryCubit.appText!.passShort;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Padding _registerForm() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
      ),
      child: Column(
        children: [
          FilledTextFieldWithLabel(
            key: const Key('phone'),
            labelText: CategoryCubit.appText!.phone,
            labelColor: Theme.of(context).colorScheme.primary,
            hintText: CategoryCubit.appText!.phone,
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
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
          ),
          SizedBox(height: vSmallMargin),
          FilledTextFieldWithLabel(
            key: const Key('password'),
            labelText: CategoryCubit.appText!.pass,
            labelColor: Theme.of(context).colorScheme.primary,
            textDirection: TextDirection.ltr,
            controller: _passwordCtrl,
            obscureText: !_showPassword,
            suffixIcon: InkWell(
              onTap: () => setState(() => _showPassword = !_showPassword),
              canRequestFocus: false,
              child: Icon(
                _showPassword ? ETagerIcons.eye_slash : ETagerIcons.eye,
                size: 18,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return CategoryCubit.appText!.pleaseEnterPass;
              }
              if (value.length < 6) {
                return CategoryCubit.appText!.passShort;
              }
              return null;
            },
          ),
          SizedBox(height: vSmallMargin),
          FilledTextFieldWithLabel(
            key: const Key('confirm password'),
            labelText: CategoryCubit.appText!.confirmPass,
            labelColor: Theme.of(context).colorScheme.primary,
            textDirection: TextDirection.ltr,
            obscureText: !_showConfirmPassword,
            inputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: () => setState(
                () => _showConfirmPassword = !_showConfirmPassword,
              ),
              canRequestFocus: false,
              radius: 5,
              borderRadius: BorderRadius.circular(largeRadius),
              child: Icon(
                _showConfirmPassword ? ETagerIcons.eye_slash : ETagerIcons.eye,
                size: 18,
              ),
            ),
            validator: (value) {
              if (value != _passwordCtrl.text) {
                return CategoryCubit.appText!.passNotMatch;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (_isLoginMode) {
        final phone = _phoneCtrl.text.trim();
        await LoginCubit.get(context).login(
          context,
          phone: phone,
          password: _passwordCtrl.text,
        );
      } else {
        final customerCubit = CustomerCubit.get(context);
        final phone = _phoneCtrl.text.trim();
        final validNumber = await PhoneNumberUtil().validate(phone, 'EG');
        if (validNumber) {
          log('Is Valid Number true');
          final phoneNumber =
              await PhoneNumberUtil().parse(phone, regionCode: 'EG');
          await customerCubit.sendSmsOtp(
            phoneNumber: phoneNumber.nationalNumber,
          );
        } else {
          log('Invalid Number');
          customSnackBar(
            context: context,
            message: '$phone ${CategoryCubit.appText!.isInvalidNumber}',
          );
        }

        // await RegistrationCubit.get(context).registerUser(
        //   context,
        //   username: _usernameCtrl.text,
        //   email: _emailCtrl.text,
        //   password: _passwordCtrl.text,
        // );
      }
    }
  }
}

class AuthModeItem extends StatelessWidget {
  const AuthModeItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.showIndicator,
  }) : super(key: key);
  final VoidCallback onTap;
  final String title;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: vMediumPadding),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.normal, height: 0.5),
              ),
              SizedBox(height: vSmallPadding),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 7.h,
                width: showIndicator ? 35 : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(smallRadius),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
