import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/MainTabView/main_tab_view.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:image_picker/image_picker.dart';

class AccountDetailsMobile extends StatefulWidget {
  @override
  _AccountDetailsMobileState createState() => _AccountDetailsMobileState();
}

class _AccountDetailsMobileState extends State<AccountDetailsMobile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _secondPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _showCurrentPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;
  File? _pickedFile;
  bool _isInit = false;
  late final CustomerCubit customerCubit;
  final role = FirebaseAuthBloc.currentUser!.role;
  late String? _imageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      customerCubit = CustomerCubit.get(context);
      final customer = FirebaseAuthBloc.currentUser;
      if (customer != null) {
        _firstNameCtrl.text = customer.firstName;
        _lastNameCtrl.text = customer.lastName;
        _accountCtrl.text = customer.username;
        _secondPhoneCtrl.text = customer.userData.mobile;
        _emailCtrl.text = customer.email.contains('.app') ? '' : customer.email;
        _imageUrl = customer.avatarUrl;
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _accountCtrl.dispose();
    _secondPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CustomerCubit, CustomerState>(
        listener: (context, state) async {
          if (state is CustomerUpdateSuccess) {
            showLoadingDialog(context);
            Navigator.pop(context);
            customSnackBar(
              context: context,
              message: CategoryCubit.appText!.yourProfileUpdated,
              color: Theme.of(context).colorScheme.primary,
            );
          } else if (state is CustomerUpdateFailed) {
            customSnackBar(context: context, message: state.error);
          } else if (state is VerifyPhoneSent) {
            Navigator.pushNamed(context, AppRouter.otp);
          } else if (state is VerifyOTPSuccess) {
            Navigator.pop(context);
            await updateUser();
          } else if (state is VerifyPhoneFailed) {
            customSnackBar(context: context, message: state.error);
          } else if (state is UpdateUserMobileFailed) {
            customSnackBar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return MainTabView(
            title: CategoryCubit.appText!.myAccount,
            leading: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().screenWidth > 800
                      ? hLargePadding
                      : hMediumPadding,
                  vertical: vMediumPadding,
                ),
                child: Column(
                  children: [
                    SizedBox(height: vMediumPadding),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildProfilePicture(context),
                          SizedBox(height: vMediumMargin),
                          buildUserInfoForm(),
                          SizedBox(height: vLargePadding),
                          if (role == UserType.customer)
                            if (!FirebaseAuthBloc.socialUser)
                              buildChangePasswordForm(context),
                        ],
                      ),
                    ),
                    SizedBox(height: vLargePadding),
                    if (role == UserType.customer) ...[
                      DefaultButton(
                        width: double.infinity,
                        text: CategoryCubit.appText!.saveChanges,
                        isLoading: state is CustomerUpdateLoading ||
                            state is UpdatePasswordLoading ||
                            state is UploadAvatarLoading ||
                            state is UpdateAvatarLoading ||
                            state is UpdateUserMobileLoading ||
                            state is VerifyPhoneLoading,
                        onPressed: () async => _submit(state),
                      ),
                      SizedBox(height: vMediumPadding),
                      DefaultButton(
                        width: double.infinity,
                        text: Languages.of(context).deleteAccount,
                        buttonColor: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Languages.of(context).areYouSure),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(Languages.of(context)
                                      .deleteAccountWarning),
                                  SizedBox(height: vLargePadding),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DefaultButton(
                                          text: CategoryCubit.appText!.cancel,
                                          height: 40.h,
                                          buttonColor: Colors.grey,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                      SizedBox(width: hSmallPadding),
                                      Expanded(
                                        child: DefaultButton(
                                          text: Languages.of(context)
                                              .deleteAccount,
                                          height: 40.h,
                                          buttonColor: Colors.red,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            customerCubit.deleteAccount();
                                            FirebaseAuthBloc.get(context)
                                                .add(DeleteUserEvent());
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    SizedBox(height: vVeryLargeMargin),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column buildUserInfoForm() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: UnderLineTextFieldWithLabel(
                labelText: CategoryCubit.appText!.firstName,
                controller: _firstNameCtrl,
                requiredField: true,
                readOnly: role != UserType.customer,
                capitalization: TextCapitalization.words,
                inputBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return CategoryCubit.appText!.filedIsRequired;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: hMediumPadding),
            Expanded(
              child: UnderLineTextFieldWithLabel(
                labelText: CategoryCubit.appText!.lastName,
                controller: _lastNameCtrl,
                requiredField: true,
                readOnly: role != UserType.customer,
                capitalization: TextCapitalization.words,
                inputBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return CategoryCubit.appText!.filedIsRequired;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.phone,
          controller: _secondPhoneCtrl,
          readOnly: role != UserType.customer,
          requiredField: FirebaseAuthBloc.socialUser,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
          ),
          validator: (value) {
            if (FirebaseAuthBloc.socialUser) {
              if (value == null || value.isEmpty) {
                return CategoryCubit.appText!.filedIsRequired;
              } else if (!phoneValidationRegExp.hasMatch(value)) {
                return CategoryCubit.appText!.enterValidNumber;
              }
            }
            return null;
          },
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.emailAddress,
          controller: _emailCtrl,
          requiredField: !FirebaseAuthBloc.socialUser,
          readOnly: FirebaseAuthBloc.socialUser || role != UserType.customer,
          enabled: !FirebaseAuthBloc.socialUser,
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.done,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              return CategoryCubit.appText!.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.account,
          controller: _accountCtrl,
          readOnly: true,
          enabled: false,
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Column buildChangePasswordForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CategoryCubit.appText!.passwordChange,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.currentPassword,
          controller: _currentPassCtrl,
          obscureText: !_showCurrentPass,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
          ),
          suffixIcon: InkWell(
            canRequestFocus: false,
            onTap: () => setState(() => _showCurrentPass = !_showCurrentPass),
            child: Icon(
              _showCurrentPass ? ETagerIcons.eye_slash : ETagerIcons.eye,
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length < 6) {
              return CategoryCubit.appText!.passShort;
            }
            return null;
          },
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.newPassword,
          controller: _newPassCtrl,
          obscureText: !_showNewPass,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
          ),
          suffixIcon: InkWell(
            canRequestFocus: false,
            onTap: () => setState(() => _showNewPass = !_showNewPass),
            child: Icon(
              _showNewPass ? ETagerIcons.eye_slash : ETagerIcons.eye,
            ),
          ),
          validator: (value) {
            if (_currentPassCtrl.text.isNotEmpty &&
                (value == null || value.isEmpty)) {
              return CategoryCubit.appText!.filedIsRequired;
            } else if (_currentPassCtrl.text.isNotEmpty &&
                (value != null && value.length < 6)) {
              return CategoryCubit.appText!.passShort;
            }
            return null;
          },
        ),
        SizedBox(height: vMediumPadding),
        UnderLineTextFieldWithLabel(
          labelText: CategoryCubit.appText!.confirmNewPassword,
          obscureText: !_showConfirmPass,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _showConfirmPass ? ETagerIcons.eye_slash : ETagerIcons.eye,
            ),
            onPressed: () =>
                setState(() => _showConfirmPass = !_showConfirmPass),
          ),
          validator: (value) {
            if (_newPassCtrl.text.isNotEmpty) {
              if (value == null || value != _newPassCtrl.text) {
                return CategoryCubit.appText!.passNotMatch;
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  // Stack buildProfilePicture(BuildContext context) {
  //   return Stack(
  //     clipBehavior: Clip.none,
  //     alignment: AlignmentDirectional.bottomStart,
  //     children: [
  //       if (_pickedFile != null)
  //         CircleAvatar(
  //           radius: 40,
  //           backgroundImage: FileImage(_pickedFile!),
  //           backgroundColor: Theme.of(context).backgroundColor,
  //         )
  //       else
  //         CircleAvatar(
  //           radius: 40,
  //           backgroundImage: NetworkImage(_imageUrl!),
  //           backgroundColor: Theme.of(context).backgroundColor,
  //           onBackgroundImageError: (exception, stackTrace) {},
  //         ),
  //       // Positioned.directional(
  //       //   bottom: -vVerySmallMargin,
  //       //   start: -hSmallPadding,
  //       //   textDirection: TextDirection.ltr,
  //       //   child: InkWell(
  //       //     onTap: () async {
  //       //       final xFile =
  //       //           await ImagePicker().pickImage(source: ImageSource.gallery);
  //       //       if (xFile != null) {
  //       //         setState(() {
  //       //           _pickedFile = File(xFile.path);
  //       //         });
  //       //       }
  //       //     },
  //       //     child: Stack(
  //       //       alignment: Alignment.center,
  //       //       children: [
  //       //         CircleAvatar(
  //       //           radius: 22,
  //       //           backgroundColor: Theme.of(context).backgroundColor,
  //       //         ),
  //       //         CircleAvatar(
  //       //           radius: 20,
  //       //           backgroundColor: Theme.of(context).colorScheme.secondary,
  //       //           child: const Icon(
  //       //             Icons.edit_rounded,
  //       //             color: Colors.white,
  //       //           ),
  //       //         ),
  //       //       ],
  //       //     ),
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  Stack buildProfilePicture(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomStart,
      children: [
        if (_pickedFile != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(_pickedFile!),
            backgroundColor: Theme.of(context).backgroundColor,
          )
        else
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_imageUrl!),
            backgroundColor: Theme.of(context).backgroundColor,
            onBackgroundImageError: (exception, stackTrace) {},
          ),
        if (role != UserType.delivery)
          Positioned.directional(
            bottom: -vVerySmallMargin,
            start: -hSmallPadding,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: InkWell(
              onTap: () async {
                final xFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (xFile != null) {
                  setState(() {
                    _pickedFile = File(xFile.path);
                  });
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _submit(CustomerState state) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      updateUser();
    }
  }

  Future<void> updateUser() async {
    if (_pickedFile != null) {
      log('Uploading user avatar...');
      final imageData = await customerCubit.uploadImageFile(_pickedFile!);
      if (imageData != null) {
        final imageId = imageData['id'] as int;
        log('Update user avatar, avatar ID: $imageId');
        await customerCubit.updateUserAvatar(imageId);
        await customerCubit.updateCustomerName(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
        );
      }
    }

    if (_currentPassCtrl.text.isNotEmpty && _newPassCtrl.text.isNotEmpty) {
      await customerCubit.updatePassword(newPassword: _newPassCtrl.text);
    }
    final user = FirebaseAuthBloc.currentUser!;
    if (FirebaseAuthBloc.currentUser!.email.toLowerCase() !=
        _emailCtrl.text.trim().toLowerCase()) {
      final newCustomer = user.copyWith(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
      );
      await customerCubit.updateUser(newCustomer);
    } else {
      final newUser = user.copyWith(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
      );
      await customerCubit.updateUser(newUser);
    }

    if (_secondPhoneCtrl.text.trim().isNotEmpty &&
        FirebaseAuthBloc.currentUser!.userData.mobile !=
            _secondPhoneCtrl.text.trim()) {
      log('Updating phone number...');
      await customerCubit.updateUserMobile(
        id: FirebaseAuthBloc.currentUser!.id,
        mobile: _secondPhoneCtrl.text.trim(),
      );
    }
  }
}
