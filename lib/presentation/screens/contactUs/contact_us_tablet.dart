// ignore_for_file: deprecated_member_use

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/contact_form_model.dart';
import 'package:allin1/data/models/contact_us_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/presentation/widgets/contactInfo/contact_info_card_tab.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button_tab.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/scrollableTabView/scrollable_tab_view_tab.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsTablet extends StatefulWidget {
  @override
  _ContactUsTabletState createState() => _ContactUsTabletState();
}

class _ContactUsTabletState extends State<ContactUsTablet> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  late final InformationCubit infoCubit;
  ContactUsModel? contactUsModel;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      final customer = FirebaseAuthBloc.currentUser;
      if (customer != null) {
        _fullNameCtrl.text = customer.firstName.isNotEmpty
            ? '${customer.firstName} ${customer.lastName}'
            : customer.username;
        _emailCtrl.text = customer.email;
      }
      infoCubit = InformationCubit.get(context);
      contactUsModel = infoCubit.contactUsModel;
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InformationCubit, InformationState>(
      builder: (context, state) {
        contactUsModel = infoCubit.contactUsModel;

        return ScrollableTabViewTablet(
          title: CategoryCubit.appText!.contactUs,
          topChild: Column(
            children: [
              SvgPicture.asset(
                'assets/images/contact-us.svg',
                height: 0.3.sh,
              ),
              SizedBox(height: vSmallPadding),
              if (state is! ContactUsLoading && contactUsModel != null)
                Column(
                  children: [
                    contactInfoRow(),
                    followUsRow(),
                  ],
                )
              else if (state is ContactUsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
          roundedBottom: state is ContactFormSendSuccess,
          child: buildContactFormView(),
        );
      },
    );
  }

  BlocBuilder<InformationCubit, InformationState> buildContactFormView() {
    return BlocBuilder<InformationCubit, InformationState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: vMediumPadding),
              child: Text(
                CategoryCubit.appText!.quickContact,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (state is ContactFormSendSuccess)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: vSmallPadding,
                  horizontal: ScreenUtil().screenWidth > 800
                      ? hLargePadding
                      : hMediumPadding,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 40,
                      color: dangerColor.withOpacity(0.8),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        color: warningShadeColor.withOpacity(0.35),
                        padding:
                            EdgeInsets.symmetric(horizontal: hSmallPadding),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(infoCubit.formStatusMsg!),
                              ),
                            ),
                            SizedBox(width: hVerySmallPadding),
                            const Icon(
                              Icons.check,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Form(
                key: _formKey,
                child: buildQuickContactForm(context),
              ),
              SizedBox(height: vMediumPadding),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().screenWidth > 800
                      ? hLargePadding
                      : hMediumPadding,
                ),
                child: DefaultButtonTablet(
                  text: CategoryCubit.appText!.sendMessage,
                  width: double.infinity,
                  isLoading: state is ContactFormLoading,
                  onPressed: _submit,
                ),
              ),
            ],
            SizedBox(height: vLargeMargin),
          ],
        );
      },
    );
  }

  Column buildQuickContactForm(BuildContext context) {
    final customer = FirebaseAuthBloc.currentUser;
    return Column(
      children: [
        if (customer == null) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hMediumPadding,
              vertical: vSmallPadding,
            ),
            child: FilledTextFieldWithLabelTablet(
              labelText: '${CategoryCubit.appText!.fullName}: *',
              hintText: CategoryCubit.appText!.fullName,
              controller: _fullNameCtrl,
              capitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return CategoryCubit.appText!.filedIsRequired;
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hMediumPadding,
              vertical: vMediumPadding,
            ),
            child: FilledTextFieldWithLabelTablet(
              labelText: '${CategoryCubit.appText!.emailAddress}: *',
              hintText: CategoryCubit.appText!.emailAddress,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return CategoryCubit.appText!.filedIsRequired;
                } else if (!emailValidatorRegExp.hasMatch(value)) {
                  return CategoryCubit.appText!.pleaseEnterValidEmail;
                }
                return null;
              },
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hMediumPadding,
            vertical: vSmallPadding,
          ),
          child: FilledTextFieldWithLabelTablet(
            labelText: '${CategoryCubit.appText!.subject}:',
            hintText: CategoryCubit.appText!.subject,
            controller: _subjectCtrl,
            capitalization: TextCapitalization.sentences,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hMediumPadding,
            vertical: vSmallPadding,
          ),
          child: FilledTextFieldWithLabelTablet(
            labelText: '${CategoryCubit.appText!.message}: *',
            hintText: CategoryCubit.appText!.message,
            maxLines: 4,
            controller: _messageCtrl,
            capitalization: TextCapitalization.words,
            inputAction: TextInputAction.newline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return CategoryCubit.appText!.filedIsRequired;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row contactInfoRow() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        SizedBox(width: hSmallPadding),
        Expanded(
          child: ContactInfoCardTablet(
            circleColor: callUsBackgroundColor,
            icon: const Icon(
              ETagerIcons.phone_alt,
              color: callUsTextColor,
            ),
            title: CategoryCubit.appText!.callUs,
            titleColor: callUsTextColor,
            onTap: () async => launch('tel:${contactUsModel!.mobile}'),
          ),
        ),
        SizedBox(width: hSmallPadding),
        Expanded(
          child: ContactInfoCardTablet(
            circleColor: emailAddressBackgroundColor,
            icon: const Icon(
              ETagerIcons.email,
              color: emailAddressTextColor,
            ),
            title: CategoryCubit.appText!.email,
            titleColor: emailAddressTextColor,
            onTap: () async => launch('mailto:${contactUsModel!.email}'),
          ),
        ),
        SizedBox(width: hSmallPadding),
        if (contactUsModel!.location != null)
          Expanded(
            child: ContactInfoCardTablet(
              circleColor: Colors.blue.shade100,
              icon: Icon(
                Icons.location_on_outlined,
                color: Colors.blue.shade900,
                size: 20,
              ),
              title: CategoryCubit.appText!.location,
              titleColor: isDark ? Colors.blue.shade200 : Colors.blue.shade600,
              onTap: () async {
                final location = contactUsModel!.location!;
                final availableMaps = await MapLauncher.installedMaps;

                await availableMaps.first.showMarker(
                  coords: Coords(location.lat, location.lng),
                  title: location.address,
                  zoom: location.zoom,
                );
              },
            ),
          ),
        SizedBox(width: hSmallPadding),
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final contactFormModel = ContactFormModel(
        name: _fullNameCtrl.text,
        email: _emailCtrl.text.trim(),
        subject: _subjectCtrl.text,
        message: _messageCtrl.text,
      );
      await infoCubit.sendContactForm(contactFormModel);
      // setState(() => _messageSent = true);
    }
  }

  Widget followUsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hMediumPadding,
            vertical: vMediumPadding,
          ).copyWith(bottom: 0),
          child: Text(
            CategoryCubit.appText!.followUs,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
          child: Row(
            children: [
              Material(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: () async {
                    final url =
                        "https://api.whatsapp.com/send?phone=${contactUsModel!.whatsApp}";

                    await launch(url);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.whatsapp,
                    size: 34,
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: () async {
                    final url = 'https://t.me/${contactUsModel!.telegram}';
                    await launch(url);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.telegram,
                    size: 34,
                  ),
                ),
              ),
              ...List.generate(contactUsModel!.socialMedia.length, (index) {
                final socialMedia = contactUsModel!.socialMedia[index];
                return Material(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    onPressed: () async => launch(socialMedia.link),
                    icon: SvgPicture.network(
                      socialMedia.iconUrl,
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}
