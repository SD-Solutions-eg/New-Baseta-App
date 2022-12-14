import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';

class CodeAndNewPasswordScreen extends StatefulWidget {
  final String? email;
  const CodeAndNewPasswordScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<CodeAndNewPasswordScreen> createState() =>
      _CodeAndNewPasswordScreenState();
}

class _CodeAndNewPasswordScreenState extends State<CodeAndNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
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
              height: 0.3.sh,
              width: 0.5.sw,
            ),
            SizedBox(height: vMediumPadding),
            Container(
              height: 0.66.sh,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 600
                    ? hLargePadding
                    : hMediumPadding,
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
                  SizedBox(height: vSmallPadding),
                  Text(
                    CategoryCubit.appText!.resetPassword,
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
                  SizedBox(height: vLargePadding),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FilledTextFieldWithLabel(
                          controller: _newPasswordCtrl,
                          labelText: CategoryCubit.appText!.newPassword,
                          labelColor: Theme.of(context).colorScheme.primary,
                          obscureText: !_showPassword,
                          keyboardType: TextInputType.visiblePassword,
                          textDirection: TextDirection.ltr,
                          suffixIcon: InkWell(
                            onTap: () =>
                                setState(() => _showPassword = !_showPassword),
                            canRequestFocus: false,
                            child: Icon(
                              _showPassword
                                  ? ETagerIcons.eye_slash
                                  : ETagerIcons.eye,
                              size: 18.w,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CategoryCubit.appText!.pleaseEnterPass;
                            } else if (value.length < 6) {
                              return CategoryCubit.appText!.passShort;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: vMediumPadding),
                        FilledTextFieldWithLabel(
                          labelText: CategoryCubit.appText!.confirmNewPassword,
                          labelColor: Theme.of(context).colorScheme.primary,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_showConfirmPassword,
                          inputAction: TextInputAction.done,
                          textDirection: TextDirection.ltr,
                          suffixIcon: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: InkWell(
                              onTap: () => setState(
                                () => _showConfirmPassword =
                                    !_showConfirmPassword,
                              ),
                              canRequestFocus: false,
                              radius: 5,
                              borderRadius: BorderRadius.circular(largeRadius),
                              child: Icon(
                                _showConfirmPassword
                                    ? ETagerIcons.eye_slash
                                    : ETagerIcons.eye,
                                size: 18.w,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty &&
                                    _newPasswordCtrl.text.isNotEmpty) {
                              return CategoryCubit.appText!.pleaseEnterPass;
                            } else if (value != _newPasswordCtrl.text &&
                                _newPasswordCtrl.text.isNotEmpty) {
                              return CategoryCubit.appText!.passNotMatch;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: vVeryLargeMargin),
                  BlocConsumer<CustomerCubit, CustomerState>(
                    listener: (context, state) {
                      if (state is UpdatePasswordSuccess) {
                        customSnackBar(
                          context: context,
                          message:
                              "Your Password has been updated successfully",
                          color: Theme.of(context).colorScheme.primary,
                        );
                        CustomerCubit.get(context).searchedForUserId = null;
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      } else if (state is UpdatePasswordFailed) {
                        customSnackBar(context: context, message: state.error);
                      }
                    },
                    builder: (context, state) => DefaultButton(
                      width: 0.5.sw,
                      smallSize: true,
                      height: 55.h,
                      text: CategoryCubit.appText!.confirm,
                      borderRadius: veryLargeRadius,
                      isLoading: state is UpdatePasswordLoading,
                      onPressed: () => _submit(context),
                    ),
                  ),
                  SizedBox(height: vLargePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${CategoryCubit.appText!.haveAccount} '),
                      InkWell(
                        onTap: () => Navigator.of(context)
                          ..pop()
                          ..pop(),
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

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await CustomerCubit.get(context).updatePassword(
        newPassword: _newPasswordCtrl.text.trim(),
        userId: CustomerCubit.get(context).searchedForUserId,
      );
    }
  }
}
