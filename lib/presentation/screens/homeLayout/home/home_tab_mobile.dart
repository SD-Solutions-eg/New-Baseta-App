import 'dart:async';
import 'dart:developer';
import 'dart:math' show min;

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/city_model.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/home/components/new_order_message.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/loading_image_container.dart';
import 'package:allin1/presentation/widgets/partner_card.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:allin1/presentation/widgets/widgetsClasses/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';

class HomeTabMobile extends StatefulWidget {
  const HomeTabMobile({Key? key}) : super(key: key);

  @override
  _HomeTabMobileState createState() => _HomeTabMobileState();
}

class _HomeTabMobileState extends State<HomeTabMobile> {
  int _currentIndex = 0;
  bool _isInit = false;
  bool showFilter = false;

  final slideshowCtrl = PageController();

  late final CategoryCubit categoryCubit;
  late final OrdersCubit ordersCubit;
  Timer? slideshowTimer;
  Timer? ordersTimer;
  List<LocationModel> locations = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      categoryCubit = CategoryCubit.get(context);
      ordersCubit = OrdersCubit.get(context);
      startSlideshowTimer();
      if (FirebaseAuthBloc.currentUser != null) {
        // ordersCubit.getOrders();
        bool addressPicked = false;
        // FirebaseMessaging.instance.unsubscribeFromTopic('orders-updates');
        addressPicked = hydratedStorage.read("addressPicked") as bool? ?? false;
        if (!addressPicked) {
          categoryCubit.getAllCities();
          Future.delayed(
            const Duration(seconds: 2),
            () => buildCityAreaSheet(context),
          );
          log('should be displayed');
          hydratedStorage.write("addressPicked", true);
        }
        // final selectedLocationData = jsonDecode(hydratedStorage.read("selectedLocation").toString());
        // if(selectedLocationData != null) {
        //   CustomerCubit.selectedLocation = LocationModel.fromMap(selectedLocationData as Map<String, dynamic>);
        // }
        // ordersCubit.refreshOrders();
      }
      _isInit = true;
    }
  }

  void startSlideshowTimer() {
    if (slideshowTimer != null && slideshowTimer!.isActive) {
      slideshowTimer!.cancel();
    }
    slideshowTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (slideshowCtrl.hasClients) {
        final double? currentPage = slideshowCtrl.page;
        _currentIndex = currentPage?.toInt() ?? 0;
        final slideshow = CategoryCubit.get(context).slideshowList;
        if (currentPage != null && currentPage < (slideshow.length - 1)) {
          if (mounted) {
            setState(() => _currentIndex++);
          }
          slideshowCtrl.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 1000), curve: Curves.ease);
        } else if (currentPage != null &&
            currentPage == (slideshow.length - 1)) {
          if (mounted) {
            setState(() => _currentIndex = 0);
          }
          slideshowCtrl.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut);
        }
      }
    });
  }

  // void startOrdersTimer() {
  //   if (ordersTimer != null && ordersTimer!.isActive) {
  //     ordersTimer!.cancel();
  //   }
  //   ordersTimer = Timer.periodic(
  //       Duration(seconds: CategoryCubit.appDurations.customerOrdersDuration),
  //       (_) {
  //     ordersCubit.refreshOrders();
  //   });
  // }

  @override
  void dispose() {
    slideshowTimer?.cancel();
    // ordersTimer?.cancel();
    slideshowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          final categoryCubit = CategoryCubit.get(context);
          await categoryCubit.getSlideshow(context);
          await categoryCubit.getAllSections();
          await ordersCubit.getOrders();
          await ordersCubit.refreshOrders();
          await categoryCubit.getPartnersBySection(0);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: vVeryLargeMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (ordersCubit.newCustomerProcessingOrders.isNotEmpty) {
                      final order =
                          ordersCubit.newCustomerProcessingOrders.first;
                      if (state is! OrdersGetLoading) {
                        return NewOrderMessage(
                          order: order,
                          key: Key(
                            order.orderId.toString(),
                          ),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }
                    return const Offstage();
                  },
                ),
                // buildNewOrdersMessage(),
                SizedBox(height: vVerySmallMargin),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: hMediumPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(verySmallRadius),
                    color: authBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      buildSearchBar(),
                      Container(
                        width: 0.5.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: iconGreyColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: hVerySmallMargin),
                          child: Icon(
                            IconlyLight.filter,
                            size: 24.w,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                mainHomeView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column mainHomeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: vMediumPadding),
        buildCategoriesView(),
        SizedBox(height: vSmallPadding),
        const CustomDivider(),
        SizedBox(height: vVerySmallMargin),
        if (categoryCubit.slideshowList.isNotEmpty) ...[
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return buildSlideshowView();
            },
          ),
          SizedBox(height: vVerySmallPadding),
          const CustomDivider(),
        ],
        SizedBox(height: vMediumPadding),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
          child: SectionHeadline(
            sectionTitle: CategoryCubit.appText!.bestSellers,
          ),
        ),
        SizedBox(height: vVerySmallPadding),
        buildSpecialPartnersView(),
      ],
    );
  }

  Widget buildSlideshowView() {
    return Column(
      children: [
        SizedBox(
          height: 160.w,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: slideshowCtrl,
            itemCount: categoryCubit.slideshowList.length,
            itemBuilder: (context, index) {
              final slideshow = categoryCubit.slideshowList[index];
              return buildSlidesImageView(
                context,
                title: slideshow.title.trim(),
                subtitle: slideshow.subtitle?.trim(),
                imageUrl: slideshow.slideshowImage.imageUrl,
                index: index,
              );
            },
            onPageChanged: (value) {
              if (mounted) {
                setState(() => _currentIndex = value);
              }
            },
          ),
        ),
        SizedBox(height: vSmallPadding),
        Padding(
          padding: EdgeInsets.only(bottom: vSmallPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              categoryCubit.slideshowList.length,
              (index) => AnimatedBullet(
                index: index,
                selectedIndex: _currentIndex,
                isLastIndex: index == categoryCubit.slideshowList.length - 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoriesView() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categoryCubit = CategoryCubit.get(context);
        final sections = categoryCubit.allSections;
        return SizedBox(
          height: 110.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(smallRadius),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.section,
                  arguments: sections[index],
                ),
                child: SizedBox(
                  width: 0.19.sw,
                  height: 110.w,
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2.5,
                                spreadRadius: 0.6,
                                offset: Offset(1, 4),
                              )
                            ]),
                        child: CachedNetworkImage(
                          imageUrl: sections[index].thumbnail,
                          // imageUrl: sections.first.thumbnail,
                          fit: BoxFit.cover,
                          width: 65.w,
                          height: 65.w,
                          placeholder: (context, url) => LoadingImageContainer(
                            width: 65.w,
                            height: 65.w,
                          ),
                          errorWidget: (context, url, error) =>
                              LoadingImageContainer(
                            width: 65.w,
                            height: 65.w,
                          ),
                        ),
                      ),
                      SizedBox(height: vSmallPadding * 0.8),
                      Center(
                        child: Text(
                          sections[index].title,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              width: ScreenUtil().screenWidth > 800
                  ? hMediumPadding
                  : hSmallPadding,
            ),
            itemCount: sections.length,
          ),
        );
      },
    );
  }

  Container buildSlidesImageView(
    BuildContext context, {
    required String title,
    required String? subtitle,
    required String imageUrl,
    required int index,
  }) {
    final isArabic = Languages.of(context) is LanguageAr;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hMediumPadding),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallRadius),
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 160.w,
            width: double.infinity,
            color: Colors.black12,
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) => LoadingImageContainer(
              height: 160.w,
              width: double.infinity,
            ),
            placeholder: (context, url) => LoadingImageContainer(
              height: 160.w,
              width: double.infinity,
              repeat: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().screenWidth > 800
                  ? hLargePadding
                  : hMediumPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ZoomIn(
                  preferences: const AnimationPreferences(
                    duration: Duration(milliseconds: 1200),
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: vVerySmallPadding),
                if (subtitle != null)
                  ZoomIn(
                    preferences: const AnimationPreferences(
                      duration: Duration(milliseconds: 1400),
                    ),
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        shadows: [
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: vVerySmallMargin),
                ZoomIn(
                  preferences: const AnimationPreferences(
                    duration: Duration(milliseconds: 1600),
                  ),
                  child: DefaultButton(
                    text: CategoryCubit.appText!.orderNow,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.categories),
                    width: 125.w,
                    height: 35.w,
                    borderRadius: verySmallRadius,
                    alignment: isArabic
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Expanded(
      child: FilledTextFieldWithLabel(
        hintText: CategoryCubit.appText!.search,
        height: 45.w,
        readOnly: true,
        onTap: () => Navigator.pushNamed(context, AppRouter.search),
        prefixIcon: Icon(
          IconlyLight.search,
          size: 20.w,
        ),
      ),
    );
  }

  Widget buildSpecialPartnersView() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final partners = categoryCubit.featuredPartners;

        return SizedBox(
          height: 260.w,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: hMediumPadding, vertical: vMediumPadding),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => SizedBox(
              width: 0.55.sw,
              child: PartnerCard(
                section: partners[index].section ?? const SectionModel.create(),
                partner: partners[index],
                imageHeight: 0.3.sw,
              ),
            ),
            separatorBuilder: (context, index) =>
                SizedBox(width: hMediumPadding),
            itemCount: min(10, partners.length),
          ),
        );
      },
    );
  }

  AppBar buildHomeAppBar(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;
    return AppBar(
      title: InkWell(
        onTap: () {
          categoryCubit.getAllCities();
          buildCityAreaSheet(context);
          // Navigator.pushNamed(context, AppRouter.map);
        },
        borderRadius: BorderRadius.circular(verySmallRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: vSmallPadding, horizontal: hMediumPadding),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.locationDot,
                size: 32.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: hSmallPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CategoryCubit.appText!.deliveryTo,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    FirebaseAuthBloc.currentUser?.userData.area?.name ??
                        CategoryCubit.appText!.selectYourArea,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  // BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
                  //   builder: (context, state) {
                  //     return Text(
                  //       FirebaseAuthBloc.currentUser!.userData.locations.isEmpty
                  //           ? CategoryCubit.appText!.selectYourArea
                  //           : FirebaseAuthBloc
                  //               .currentUser!.userData.locations.last.city,
                  //       style: Theme.of(context).textTheme.subtitle1,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0.5,
      toolbarHeight: 65.w,
      actions: [
        NotificationsIcon(isArabic: isArabic),
        SizedBox(width: hMediumPadding),
      ],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

Future<dynamic> buildCityAreaSheet(BuildContext context) {
  UserModel? user = FirebaseAuthBloc.currentUser;
  bool hasArea = user != null && user.userData.area != null;
  List<CityModel> allCities = [];
  List<AreaModel> allAreas = [];
  final formBuilderKey = GlobalKey<FormBuilderState>();
  final CategoryCubit categoryCubit = CategoryCubit.get(context);
  final outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 0.2,
      color: Colors.grey.shade900.withOpacity(0.6),
    ),
  );
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(largeRadius),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setModelState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: hasArea ? 0.25.sh : 0.5.sh,
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              allCities = categoryCubit.allCities;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding, vertical: vMediumPadding),
                  child: Column(
                    children: [
                      SizedBox(height: vSmallPadding),
                      Text(
                        CategoryCubit.appText!.availableAreasForDelivery,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      SizedBox(height: vVeryLargePadding),
                      if (hasArea)
                        InkWell(
                          onTap: () {
                            setModelState(() => hasArea = false);
                          },
                          borderRadius: BorderRadius.circular(mediumRadius),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: hMediumPadding,
                                vertical: vSmallPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: iconGreyColor,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(mediumRadius),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  user!.userData.area!.name,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                const Spacer(),
                                InkWell(
                                  borderRadius:
                                      BorderRadius.circular(veryLargeRadius),
                                  onTap: () {
                                    setModelState(() => hasArea = false);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(hSmallPadding),
                                    child: Icon(
                                      IconlyBold.edit,
                                      size: 30.w,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        FormBuilder(
                          key: formBuilderKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: hLargePadding),
                                child: FormBuilderDropdown<CityModel>(
                                  name: 'city',
                                  hint: Text(
                                      CategoryCubit.appText!.selectedYourState),
                                  decoration: FilledTextFieldWithLabel
                                          .customInputDecoration(
                                              context: context)
                                      .copyWith(
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    border: outlineInputBorder,
                                    focusedBorder: outlineInputBorder,
                                    enabledBorder: outlineInputBorder,
                                  ),
                                  items:
                                      List.generate(allCities.length, (index) {
                                    final city = allCities[index];
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(
                                        city.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    );
                                  }),
                                  onChanged: (city) async {
                                    if (city != null) {
                                      setModelState(() {
                                        allAreas.clear();
                                        categoryCubit.allAreas.clear();
                                      });
                                      formBuilderKey.currentState!
                                          .removeInternalFieldValue('area',
                                              isSetState: true);
                                      await categoryCubit
                                          .getAreasByCity(city.id);
                                      setModelState(() =>
                                          allAreas = categoryCubit.allAreas);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return CategoryCubit
                                          .appText!.filedIsRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (state is GetAllAreasLoading)
                                SizedBox(height: vLargePadding),
                              if (state is GetAllAreasLoading)
                                SizedBox(
                                  width: 25.w,
                                  height: 25.w,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              SizedBox(height: vMediumPadding),
                              if (allAreas.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: hLargePadding),
                                  child: FormBuilderDropdown<AreaModel>(
                                    name: 'area',
                                    hint: Text(
                                        CategoryCubit.appText!.selectYourArea),
                                    decoration: FilledTextFieldWithLabel
                                            .customInputDecoration(
                                                context: context)
                                        .copyWith(
                                      fillColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      border: outlineInputBorder,
                                      focusedBorder: outlineInputBorder,
                                      enabledBorder: outlineInputBorder,
                                    ),
                                    enabled: allAreas.isNotEmpty,
                                    items:
                                        List.generate(allAreas.length, (index) {
                                      final area = allAreas[index];
                                      return DropdownMenuItem(
                                        key: Key(area.id.toString()),
                                        value: area,
                                        child: Text(
                                          '${area.name} (${'${area.deliveryPrice} EGP'})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      );
                                    }),
                                    validator: (value) {
                                      if (value == null) {
                                        return CategoryCubit
                                            .appText!.filedIsRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // SizedBox(height: vMediumPadding),
                        // Text(CategoryCubit.appText!.selectYourArea),
                        SizedBox(height: vVeryLargePadding),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: hMediumPadding,
                              vertical: vMediumPadding),
                          child: BlocConsumer<CustomerCubit, CustomerState>(
                            listener: (context, state) {
                              if (state is UpdateUserAreaSuccess) {
                                setModelState(() => hasArea = true);
                              } else if (state is UpdateUserAreaFailed) {
                                customSnackBar(
                                    context: context, message: state.error);
                              }
                            },
                            builder: (context, state) {
                              return DefaultButton(
                                width: double.infinity,
                                isLoading: state is UpdateUserAreaLoading,
                                text: CategoryCubit.appText!.saveChanges,
                                onPressed: () async {
                                  if (user != null) {
                                    if (formBuilderKey.currentState != null &&
                                        formBuilderKey.currentState!
                                            .saveAndValidate()) {
                                      final formMap =
                                          formBuilderKey.currentState!.value;
                                      log('Form Map: $formMap');
                                      final area = formMap['area'] as AreaModel;
                                      await CustomerCubit.get(context)
                                          .updateUserArea(
                                              id: user!.id, areaId: area.id);
                                      setModelState(() {
                                        user = FirebaseAuthBloc.currentUser;
                                      });
                                    }
                                  } else {
                                    customSnackBar(
                                      context: context,
                                      message: CategoryCubit
                                          .appText!.needToLoginFirst,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    );
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        AppRouter.authScreen, (route) => false);
                                    tabController = null;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        );
      });
    },
  );
}

Future<dynamic> buildAddressSheet(BuildContext context) {
  final UserModel? user = FirebaseAuthBloc.currentUser;
  int currentIndex = CustomerCubit.currentLocationIndex ?? 0;
  List<LocationModel> locations =
      FirebaseAuthBloc.currentUser!.userData.locations;

  // bool hasArea = user != null && user.userData.area != null;
  // List<CityModel> allCities = [];
  // List<AreaModel> allAreas = [];
  final formBuilderKey = GlobalKey<FormBuilderState>();
  // final CategoryCubit categoryCubit = CategoryCubit.get(context);
  // final outlineInputBorder = OutlineInputBorder(
  //   borderSide: BorderSide(
  //     width: 0.2,
  //     color: Colors.grey.shade900.withOpacity(0.6),
  //   ),
  // );
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(largeRadius),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setModelState) {
        return BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: hMediumPadding, vertical: vMediumPadding),
              child: FormBuilder(
                key: formBuilderKey,
                child: Column(
                  children: [
                    SizedBox(height: vSmallPadding),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                      child: Row(
                        children: [
                          Icon(
                            IconlyBold.location,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22.w,
                          ),
                          SizedBox(width: hSmallPadding),
                          Text(
                            CategoryCubit.appText!.deliveryAddress,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRouter.myLocation);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(hVerySmallPadding),
                              child: Text(
                                CategoryCubit.appText!.addAddress,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: vSmallPadding),
                    BlocBuilder<CustomerCubit, CustomerState>(
                      builder: (context, state) {
                        locations =
                            FirebaseAuthBloc.currentUser!.userData.locations;
                        return Expanded(
                          child: ListView.separated(
                            // physics: const NeverScrollableScrollPhysics(),
                            // shrinkWrap: true,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(locations[index].city),
                              subtitle:
                                  Text(locations[index].address, maxLines: 2),
                              onTap: () {
                                setModelState(() {
                                  currentIndex = index;
                                  CustomerCubit.get(context)
                                      .updateSelectedLocation(
                                          locations[currentIndex]);
                                  CustomerCubit.currentLocationIndex =
                                      currentIndex;
                                });
                              },
                              trailing: index == currentIndex
                                  ? Icon(
                                      Icons.check_circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 22.w,
                                    )
                                  : const SizedBox(),
                            ),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: locations.length,
                          ),
                        );
                      },
                    ),
                    // SizedBox(height: vVeryLargePadding),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: hMediumPadding, vertical: vMediumPadding),
                      child: DefaultButton(
                        width: double.infinity,
                        text: CategoryCubit.appText!.saveChanges,
                        onPressed: () async {
                          if (user != null) {
                            // CustomerCubit.selectedLocation = locations[currentIndex];
                            CustomerCubit.get(context).updateSelectedLocation(
                                locations[currentIndex]);
                            CustomerCubit.currentLocationIndex = currentIndex;
                            log('Selected Location: ${locations[currentIndex].address}');
                            Navigator.of(context, rootNavigator: true).pop();
                          } else {
                            customSnackBar(
                              context: context,
                              message: CategoryCubit.appText!.needToLoginFirst,
                              color: Theme.of(context).colorScheme.primary,
                            );
                            Navigator.pushNamedAndRemoveUntil(context,
                                AppRouter.authScreen, (route) => false);
                            tabController = null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    },
  );
}
