import 'package:allin1/presentation/routers/import_helper.dart';

class NewAddressScreen extends StatefulWidget {
  final bool? isEditing;
  final String title;
  final bool fromCart;
  const NewAddressScreen({
    Key? key,
    this.isEditing,
    this.fromCart = false,
    required this.title,
  }) : super(key: key);

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return const Offstage();
  }
}
/*
class _NewAddressScreenState extends State<NewAddressScreen> {
  final formBuilderKey = GlobalKey<FormBuilderState>();
  final _stateCtrl = TextEditingController();
  late final AddressModel addressModel;
  late bool isBilling;

  bool _isInit = false;
  bool isLoading = true;
  String countryCode = 'EG';
  String stateCode = 'C';
  final debouncer = Debounces();
  StateModel stateModel = const StateModel(name: 'Cairo', code: 'C');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      isBilling = widget.title == CategoryCubit.appText!.billingAddress;
      addressModel = isBilling
          ? FirebaseAuthBloc.customer!.billing
          : FirebaseAuthBloc.customer!.shipping;
      countryCode =
          addressModel.country.isNotEmpty ? addressModel.country : 'EG';
      stateCode = addressModel.state.isNotEmpty
          ? addressModel.state.substring(2, addressModel.state.length)
          : stateCode;
      getStateModel();
      _isInit = true;
    }
  }

  Future<void> getStateModel() async {
    stateModel = await CustomerCubit.get(context)
            .getStateDetailsByCode(countryCode, stateCode) ??
        stateModel;

    _stateCtrl.text = stateModel.name;
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _stateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CustomerCubit, CustomerState>(
        listener: (context, state) async {
          if (state is CustomerUpdateSuccess) {
            showLoadingDialog(context);

            await CartCubit.get(context).getCartModel();
            Navigator.pop(context);
            customSnackBar(
              context: context,
              message: CategoryCubit.appText!.addressUpdated,
              color: Theme.of(context).colorScheme.secondary,
            );
            if (widget.fromCart) {
              Navigator.pop(context);
            } else {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed(AppRouter.addresses);
            }
          } else if (state is CustomerUpdateFailed) {
            customSnackBar(context: context, message: state.error);
          } else if (state is VerifyPhoneSent) {
            Navigator.pushNamed(context, AppRouter.otp);
          } else if (state is VerifyOTPSuccess) {
            Navigator.pop(context);
            await updateCustomer();
          } else if (state is VerifyPhoneFailed) {
            customSnackBar(context: context, message: state.error);
          }
        },
        child: MainTabView(
          title: CategoryCubit.appText!.myAccount,
          leading: true,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hMediumPadding,
                    vertical: vLargePadding,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: vLargePadding),
                        FormBuilder(
                          key: formBuilderKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: _buildAddressInfo(),
                        ),
                        SizedBox(height: vLargePadding),
                        BlocBuilder<CustomerCubit, CustomerState>(
                          builder: (context, state) {
                            return DefaultButton(
                              width: double.infinity,
                              text: CategoryCubit.appText!.saveChanges,
                              isLoading: state is VerifyPhoneLoading ||
                                  state is CustomerUpdateLoading,
                              onPressed: () async => saveAddress(state),
                            );
                          },
                        ),
                        SizedBox(height: vLargePadding),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> saveAddress(CustomerState state) async {
    if (formBuilderKey.currentState != null &&
        formBuilderKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      formBuilderKey.currentState!.save();

      // log(formBuilderKey.currentState!.value.toString());

      final customerCubit = CustomerCubit.get(context);
      final phone = formBuilderKey.currentState!.value['phone'] as String;
      if (phone != addressModel.phone) {
        if (state is! VerifyPhoneSent) {
          final validNumber = await PhoneNumberUtil().validate(phone, 'EG');
          if (validNumber) {
            final phoneNumber =
                await PhoneNumberUtil().parse(phone, regionCode: 'EG');
            await customerCubit.verifyPhoneNumber(
              phoneNumber: phoneNumber.e164,
            );
          } else {
            customSnackBar(
              context: context,
              message: '$phone ${CategoryCubit.appText!.isInvalidNumber}',
            );
          }
        } else {
          Navigator.pushNamed(context, AppRouter.otp);
        }
      } else {
        await updateCustomer();
      }
    }
  }

  Future<void> updateCustomer() async {
    final addressModel =
        AddressModel.fromMap(formBuilderKey.currentState!.value);
    final newAddressModel = addressModel.copyWith(
        country: countryCode, state: '$countryCode${stateModel.code}');

    final customerCubit = CustomerCubit.get(context);
    final newCustomer = FirebaseAuthBloc.customer!.copyWith(
      billing: isBilling ? newAddressModel : null,
      shipping: isBilling ? null : newAddressModel,
    );
    await customerCubit.updateCustomer(newCustomer);
  }

  Column _buildAddressInfo() {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyFormBuilderFiled(
                inputAction: TextInputAction.next,
                id: 'first_name',
                title: CategoryCubit.appText!.firstName,
                initialValue: addressModel.firstName.isNotEmpty
                    ? addressModel.firstName
                    : null,
                capitalization: TextCapitalization.words,
                isRequired: true,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return CategoryCubit.appText!.filedIsRequired;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(width: hMediumPadding),
            Expanded(
              child: MyFormBuilderFiled(
                inputAction: TextInputAction.next,
                id: 'last_name',
                title: CategoryCubit.appText!.lastName,
                capitalization: TextCapitalization.words,
                initialValue: addressModel.lastName.isNotEmpty
                    ? addressModel.lastName
                    : null,
                isRequired: true,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return CategoryCubit.appText!.filedIsRequired;
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: vMediumPadding),
        MyFormBuilderFiled(
          inputAction: TextInputAction.next,
          id: 'company',
          title: CategoryCubit.appText!.companyName,
          capitalization: TextCapitalization.words,
          initialValue:
              addressModel.company.isNotEmpty ? addressModel.company : '',
        ),
        // Visibility(
        //   visible: false,
        //   child: Column(
        //     children: [
        //       SizedBox(height: vMediumPadding),
        //       MyFormBuilderFiled(
        //         inputAction: TextInputAction.next,
        //         id: 'country',
        //         // title: CategoryCubit.appText!.countryRegion,
        //         initialValue: addressModel.country.isNotEmpty
        //             ? addressModel.country
        //             : null,
        //         // isRequired: true,
        //         // validator: (p0) {
        //         //   if (p0 == null || p0.isEmpty) {
        //         //     return CategoryCubit.appText!.filedIsRequired;
        //         //   } else {
        //         //     return null;
        //         //   }
        //         // },
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: vMediumPadding),
        MyFormBuilderFiled(
          inputAction: TextInputAction.next,
          id: 'address_1',
          title: CategoryCubit.appText!.streetAddress,
          keyboardType: TextInputType.streetAddress,
          isRequired: true,
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            } else {
              return null;
            }
          },
          initialValue:
              addressModel.address1.isNotEmpty ? addressModel.address1 : null,
          hintText: CategoryCubit.appText!.houseNumber,
        ),

        SizedBox(height: vMediumPadding),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: RichText(
            text: TextSpan(
              text: CategoryCubit.appText!.countryRegion,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: ' *',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.red),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: vSmallPadding),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: iconGreyColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(verySmallRadius),
            color: authBackgroundColor,
          ),
          child: CountryCodePicker(
            dialogTextStyle: Theme.of(context).textTheme.subtitle1,
            initialSelection: countryCode,
            onChanged: (country) async {
              countryCode = country.code!;
              _stateCtrl.clear();
              await CustomerCubit.get(context).getStateByCountry(countryCode);
              // debouncer.run(() async {
              // });
            },
            onInit: (country) async {
              countryCode = country!.code!;

              await CustomerCubit.get(context).getStateByCountry(countryCode);
            },
            showCountryOnly: true,
            favorite: const ['+20', 'EG'],
            alignLeft: true,
            showFlag: false,
            showDropDownButton: true,
            showOnlyCountryWhenClosed: true,
            barrierColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
            dialogBackgroundColor:
                Theme.of(context).backgroundColor.withOpacity(0.98),
            dialogSize: Size(MediaQuery.of(context).size.width - 50, 500.h),
            padding: EdgeInsets.symmetric(vertical: 1.h),
            textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        SizedBox(height: vMediumPadding),

        MyFormBuilderFiled(
          inputAction: TextInputAction.next,
          id: 'city',
          title: CategoryCubit.appText!.townCity,
          capitalization: TextCapitalization.words,
          initialValue: addressModel.city.isNotEmpty ? addressModel.city : null,
          isRequired: true,
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: vMediumPadding),

        BlocBuilder<CustomerCubit, CustomerState>(
          builder: (context, state) {
            final customerCubit = CustomerCubit.get(context);
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final outlineInputBorder = OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.2,
                color: Colors.grey.shade900.withOpacity(0.6),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: CategoryCubit.appText!.stateCountry,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.red),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                TypeAheadFormField<StateModel>(
                  hideKeyboard: customerCubit.allStates.isNotEmpty,
                  hideOnEmpty: true,
                  hideOnError: true,
                  hideOnLoading: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CategoryCubit.appText!.filedIsRequired;
                    }
                    return null;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _stateCtrl,
                    decoration: FilledTextFieldWithLabel.customInputDecoration(
                      context: context,
                      isDark: isDark,
                      maxLines: 1,
                    ).copyWith(
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      hintText: CategoryCubit.appText!.selectedYourState,
                      suffixIcon: customerCubit.allStates.isNotEmpty
                          ? Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: hLargePadding * 0.9),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                                size: 34.w,
                              ),
                            )
                          : null,
                    ),
                  ),
                  onSuggestionSelected: (suggestion) {
                    _stateCtrl.text = suggestion.name;
                    stateModel = suggestion;
                  },
                  itemBuilder: (context, stateModel) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: hMediumPadding, vertical: vMediumPadding),
                      child: Text(stateModel.name),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    final allStates = customerCubit.allStates;
                    return List.generate(
                      allStates.length,
                      (index) => allStates[index],
                    );
                  },
                ),
              ],
            );
          },
        ),
        SizedBox(height: vMediumPadding),
        MyFormBuilderFiled(
          inputAction: TextInputAction.next,
          id: 'postcode',
          title: CategoryCubit.appText!.postcodeZIP,
          keyboardType: TextInputType.number,
          initialValue:
              addressModel.postcode.isNotEmpty ? addressModel.postcode : null,
          isRequired: true,
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: vMediumPadding),
        MyFormBuilderFiled(
          inputAction: TextInputAction.next,
          id: 'phone',
          title: CategoryCubit.appText!.phone,
          initialValue: addressModel.phone,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return CategoryCubit.appText!.filedIsRequired;
            } else if (!phoneValidationRegExp.hasMatch(value)) {
              return '$value ${CategoryCubit.appText!.isInvalidNumber}';
            }
            return null;
          },
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: vMediumPadding),
        if (widget.title == CategoryCubit.appText!.billingAddress) ...[
          MyFormBuilderFiled(
            id: 'email',
            title: CategoryCubit.appText!.email,
            initialValue: addressModel.email,
            isRequired: true,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return CategoryCubit.appText!.filedIsRequired;
              } else if (!emailValidatorRegExp.hasMatch(p0)) {
                return CategoryCubit.appText!.pleaseEnterValidEmail;
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.done,
          ),
          SizedBox(height: vMediumPadding),
        ],
      ],
    );
  }
}
*/
