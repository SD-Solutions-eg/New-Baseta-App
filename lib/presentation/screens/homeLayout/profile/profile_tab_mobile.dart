import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/core/utilities/debouncer.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/delivery/delivery_layout.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:allin1/presentation/widgets/scopelinks_copyrights.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconly/iconly.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileTabMobile extends StatefulWidget {
  final ProductsCubit productsCubit;
  const ProfileTabMobile({
    Key? key,
    required this.productsCubit,
  }) : super(key: key);

  @override
  _ProfileTabMobileState createState() => _ProfileTabMobileState();
}

class _ProfileTabMobileState extends State<ProfileTabMobile> {
  bool _notifications = true;
  bool _isAr = true;
  bool _isInit = false;
  UserModel? user;
  final debouncer = Debounces();
  String localeVersion = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      getCurrentVersion();
      _notifications = hydratedStorage.read('notification') as bool? ?? true;
      user = FirebaseAuthBloc.currentUser;
      _isInit = true;
    }
    getLocal();
  }

  Future<void> getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() => localeVersion = packageInfo.version);
      log('App Version iS: $localeVersion');
    } catch (e) {
      log('Error Checking can update: $e');
    }
  }

  void getLocal() =>
      setState(() => _isAr = Languages.of(context) is LanguageAr);

  @override
  Widget build(BuildContext context) {
    var role = UserType.customer;
    if (FirebaseAuthBloc.currentUser != null) {
      role = FirebaseAuthBloc.currentUser!.role;
    }
    return Scaffold(
      appBar: buildProfileAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: vMediumPadding),
                child: Column(
                  children: [
                    if (user != null)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRouter.accountDetails),
                        child: Column(
                          children: [
                            BlocBuilder<CustomerCubit, CustomerState>(
                              builder: (context, state) {
                                user = FirebaseAuthBloc.currentUser;
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: hMediumPadding),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 75.w,
                                        height: 75.w,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: user != null
                                            ? CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    ColoredBox(
                                                        color: Theme.of(context)
                                                            .backgroundColor),
                                                imageUrl: user!.avatarUrl,
                                                fit: BoxFit.cover,
                                                errorWidget: (context, error,
                                                        stackTrace) =>
                                                    ColoredBox(
                                                        color: Theme.of(context)
                                                            .backgroundColor),
                                              )
                                            : ColoredBox(
                                                color: Theme.of(context)
                                                    .backgroundColor),
                                      ),
                                      SizedBox(width: hMediumPadding),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (user!.firstName.isNotEmpty)
                                            SizedBox(height: vSmallPadding),
                                          if (user!.firstName.isNotEmpty)
                                            Text(
                                              '${user!.firstName} ${user!.lastName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black54),
                                            ),
                                          SizedBox(height: vSmallPadding),
                                          Text(
                                            user!.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: vSmallPadding),
                            const CustomDivider(),
                            if (role == UserType.customer)
                              buildListItem(
                                suffix: Icon(
                                  IconlyLight.document,
                                  size: 22.w,
                                  color: darkGrey,
                                ),
                                text: CategoryCubit.appText!.orders,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRouter.orders),
                              ),
                            if (role == UserType.customer)
                              const Divider(
                                thickness: 1,
                                height: 1,
                                color: authBackgroundColor,
                              ),
                            if (role == UserType.customer)
                              buildListItem(
                                suffix: Icon(
                                  FontAwesomeIconsLight.map_marker_alt,
                                  size: 22.w,
                                  color: darkGrey,
                                ),
                                text: CategoryCubit.appText!.myAddresses,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRouter.myLocation),
                              ),
                            if (role == UserType.customer)
                              const Divider(
                                thickness: 1,
                                height: 1,
                                color: authBackgroundColor,
                              ),
                            buildListItem(
                              suffix: Icon(
                                FontAwesomeIconsLight.user_cog,
                                size: 20.w,
                                color: darkGrey,
                              ),
                              text: CategoryCubit.appText!.accountDetails,
                              onTap: () => Navigator.pushNamed(
                                  context, AppRouter.accountDetails),
                            ),
                            const Divider(
                              thickness: 1,
                              height: 1,
                              color: authBackgroundColor,
                            ),
                          ],
                        ),
                      ),
                    // const ParentSections(),
                    // const LiveLocationSection(),
                    // SizedBox(height: vSmallPadding),
                    // ProfileItemContainer(
                    //   text: "Company Reviews",
                    //   onTap: () =>
                    //       Navigator.pushNamed(context, AppRouter.reviews),
                    // ),
                    if (role == UserType.customer)
                      Column(
                        children: [
                          buildItemBackground(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: hSmallPadding),
                              child: Row(
                                children: [
                                  Icon(
                                    IconlyLight.notification,
                                    size: 22.w,
                                    color: darkGrey,
                                  ),
                                  SizedBox(width: hSmallPadding),
                                  Text(
                                    CategoryCubit.appText!.notifications,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54),
                                  ),
                                  const Spacer(),
                                  CupertinoSwitch(
                                    value: _notifications,
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                    onChanged: (value) {
                                      setState(() => _notifications = value);
                                      debouncer.run(() async {
                                        await hydratedStorage.write(
                                            'notification', value);
                                        if (value) {
                                          await FirebaseMessaging.instance
                                              .subscribeToTopic('public');
                                          log('Subscribed to public topic');
                                        } else {
                                          await FirebaseMessaging.instance
                                              .unsubscribeFromTopic('public');
                                          log('Unsubscribed from public topic');
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: authBackgroundColor,
                          ),
                          buildListItem(
                            suffix: Icon(
                              FontAwesomeIconsLight.question_circle,
                              size: 22.w,
                              color: darkGrey,
                            ),
                            text: CategoryCubit.appText!.support,
                            onTap: () =>
                                Navigator.pushNamed(context, AppRouter.support),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: authBackgroundColor,
                          ),
                          buildListItem(
                            suffix: Icon(
                              FontAwesomeIconsLight.info_circle,
                              size: 22.w,
                              color: darkGrey,
                            ),
                            text: CategoryCubit.appText!.aboutUs,
                            onTap: () =>
                                Navigator.pushNamed(context, AppRouter.aboutUs),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: authBackgroundColor,
                          ),
                          buildListItem(
                            suffix: Icon(
                              FontAwesomeIconsLight.user_cog,
                              size: 22.w,
                              color: darkGrey,
                            ),
                            text: CategoryCubit.appText!.contactUs,
                            onTap: () => Navigator.pushNamed(
                                context, AppRouter.contactUs),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: authBackgroundColor,
                          ),
                        ],
                      ),
                    buildListItem(
                      suffix: Icon(
                        FontAwesomeIconsLight.language,
                        size: 22.w,
                        color: darkGrey,
                      ),
                      text: CategoryCubit.appText!.language,
                      onTap: () => _showChangeLanguageSheet(),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: authBackgroundColor,
                    ),
                    BlocListener<FirebaseAuthBloc, FirebaseAuthState>(
                      listener: (context, state) {
                        if (state is AuthCheckUnauthenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRouter.authScreen, (route) => false);
                          tabController = null;
                        } else if (state is AuthCheckFailed) {
                          Navigator.pop(context);
                          customSnackBar(
                              context: context, message: state.error);
                          log(state.error);
                        }
                      },
                      child: buildListItem(
                        suffix: Icon(
                          user != null
                              ? FontAwesomeIconsLight.sign_out_alt
                              : FontAwesomeIconsLight.sign_in_alt,
                          size: 22.w,
                          color: darkGrey,
                        ),
                        text: user != null
                            ? CategoryCubit.appText!.logout
                            : CategoryCubit.appText!.login,
                        textColor: Theme.of(context).colorScheme.secondary,
                        showIcon: false,
                        onTap: () async {
                          Navigator.pushNamed(context, AppRouter.loadingScreen);
                          if (user != null) {
                            tabController = null;
                            deliveryTabCtrl = null;
                            FirebaseAuthBloc.get(context).add(SignOutEvent());
                            hydratedStorage.delete("addressPicked");
                            hydratedStorage.delete("selectedLocation");
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context,
                                AppRouter.authScreen, (route) => false);
                            tabController = null;
                            deliveryTabCtrl = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: vSmallPadding),
                  ],
                ),
              ),
            ),
          ),
          ScopeLinksCopyright(appVersion: localeVersion),
          const CustomDivider(),
        ],
      ),
    );
  }

  Widget buildListItem(
      {required String text,
      required VoidCallback onTap,
      Widget? suffix,
      Color? textColor,
      bool showIcon = true}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: hLargePadding, vertical: vMediumPadding),
        alignment: Alignment.center,
        child: Row(
          children: [
            if (suffix != null) suffix,
            SizedBox(width: hVerySmallMargin),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            if (showIcon)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.w,
                color: darkGrey,
              ),
          ],
        ),
      ),
    );
  }

  Container buildItemBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: hMediumPadding, vertical: vSmallPadding * 1.1),
      child: child,
    );
  }

  Future _showChangeLanguageSheet() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                if (!_isAr) {
                  showLoadingDialog(context);
                  final categoryCubit = CategoryCubit.get(context);
                  final orderCubit = OrdersCubit.get(context);
                  _isAr = true;
                  await changeLanguage(context, 'ar');
                  await categoryCubit.getAppText(context);
                  categoryCubit.getSlideshow(context);
                  orderCubit.getPaymentGateways();
                  categoryCubit.getAllSections();
                  categoryCubit.getPartnersBySection(0);
                  // await categoryCubit.getAllCities();
                  // if (categoryCubit.allCities.isNotEmpty) {
                  //   await categoryCubit
                  //       .getAreasByCity(categoryCubit.allCities.first.id);
                  // }
                  setState(() {});
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                CategoryCubit.appText!.arabic,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _isAr
                          ? lightPrimary
                          : isDark
                              ? Colors.white
                              : Colors.black,
                    ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                if (_isAr) {
                  showLoadingDialog(context);
                  final categoryCubit = CategoryCubit.get(context);
                  final orderCubit = OrdersCubit.get(context);
                  _isAr = false;
                  await changeLanguage(context, 'en');
                  await categoryCubit.getAppText(context);
                  categoryCubit.getSlideshow(context);
                  orderCubit.getPaymentGateways();
                  categoryCubit.getAllSections();
                  categoryCubit.getPartnersBySection(0);

                  // await categoryCubit.getAllCities();
                  // if (categoryCubit.allCities.isNotEmpty) {
                  //   await categoryCubit
                  //       .getAreasByCity(categoryCubit.allCities.first.id);
                  // }
                  setState(() {});
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                CategoryCubit.appText!.english,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _isAr
                        ? isDark
                            ? Colors.white
                            : Colors.black
                        : lightPrimary),
              ),
            ),
          ],
          cancelButton: DefaultButton(
            text: CategoryCubit.appText!.cancel,
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
          ),
        );
      },
    );
  }

  AppBar buildProfileAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 65.w,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
        child: Text(
          CategoryCubit.appText!.myAccount,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
