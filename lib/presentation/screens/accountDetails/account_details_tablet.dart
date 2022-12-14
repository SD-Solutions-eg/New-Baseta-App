import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/MainTabView/main_tab_view_tab.dart';
import 'package:allin1/presentation/widgets/components/components_tab.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button_tab.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:image_picker/image_picker.dart';

class AccountDetailsTablet extends StatefulWidget {
  @override
  _AccountDetailsTabletState createState() => _AccountDetailsTabletState();
}

class _AccountDetailsTabletState extends State<AccountDetailsTablet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _showCurrentPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;
  File? _pickedFile;
  bool _isInit = false;
  late final CustomerCubit customerCubit;
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
        _usernameCtrl.text = customer.username;
        _emailCtrl.text = customer.email;
        _imageUrl = customer.avatarUrl;
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          return MainTabViewTablet(
            title: CategoryCubit.appText!.myAccount,
            leading: true,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 800
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vMediumPadding,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: vMediumPadding),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildProfilePicture(context),
                          SizedBox(height: vVeryLargeMargin),
                          buildUserInfoForm(),
                          SizedBox(height: vLargePadding),
                          if (!FirebaseAuthBloc.socialUser)
                            buildChangePasswordForm(context),
                        ],
                      ),
                    ),
                    SizedBox(height: vLargePadding),
                    DefaultButtonTablet(
                      width: double.infinity,
                      text: CategoryCubit.appText!.saveChanges,
                      isLoading: state is CustomerUpdateLoading ||
                          state is UpdatePasswordLoading,
                      onPressed: _submit,
                    ),
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
          labelText: CategoryCubit.appText!.emailAddress,
          controller: _emailCtrl,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
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
          labelText: CategoryCubit.appText!.username,
          controller: _usernameCtrl,
          capitalization: TextCapitalization.words,
          readOnly: true,
          enabled: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            }
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

  Stack buildProfilePicture(BuildContext context) {
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
        Positioned.directional(
          bottom: -vVerySmallMargin,
          start: -hSmallPadding,
          textDirection: TextDirection.ltr,
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

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      if (_currentPassCtrl.text.isNotEmpty && _newPassCtrl.text.isNotEmpty) {
        // final isValid = await customerCubit.validatePassword(
        //     currentPassword: _currentPassCtrl.text);

        // if (isValid) {
        await customerCubit.updatePassword(newPassword: _newPassCtrl.text);
        // } else {
        //   customSnackBar(
        //     context: context,
        //     message: CategoryCubit.appText!.currentPassIsIncorrect,
        //   );
        //   return;
        // }
      }
      if (FirebaseAuthBloc.currentUser!.email.toLowerCase() !=
          _emailCtrl.text.trim().toLowerCase()) {
        log('Changing email');
        await customerCubit.updateCustomerName(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
          email: _emailCtrl.text.trim().toLowerCase(),
        );
      } else {
        log('Changing Name only');
        await customerCubit.updateCustomerName(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
        );
      }
      customSnackBarTablet(
        context: context,
        message: CategoryCubit.appText!.yourProfileUpdated,
        color: Theme.of(context).colorScheme.primary,
      );
    }
  }
}
