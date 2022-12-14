import 'dart:async';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/createOrder/create_order_screen.dart';
import 'package:allin1/presentation/screens/drawer/filter_drawer.dart';
import 'package:allin1/presentation/screens/homeLayout/home/home_tab.dart';
import 'package:allin1/presentation/screens/homeLayout/profile/profile_tab.dart';
import 'package:allin1/presentation/screens/homeLayout/sections/sections_tab.dart';
import 'package:allin1/presentation/screens/orders/orders_mobile.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:iconly/iconly.dart';

class HomeLayoutMobile extends StatefulWidget {
  final bool? reload;
  const HomeLayoutMobile({
    Key? key,
    required this.reload,
  }) : super(key: key);
  @override
  _HomeLayoutMobileState createState() => _HomeLayoutMobileState();
}

class _HomeLayoutMobileState extends State<HomeLayoutMobile>
    with SingleTickerProviderStateMixin {
  bool _isInit = false;
  int initialIndex = 0;
  DateTime? lastPressed;
  Timer? ordersTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tabController ??= TabController(
      length: 5,
      vsync: this,
    );

    if (!_isInit) {
      final categoryCubit = CategoryCubit.get(context);
      if (widget.reload != null && widget.reload!) {
        categoryCubit.getSlideshow(context);
      }
      NotificationsCubit.get(context).getNotifications();

      if (FirebaseAuthBloc.currentUser != null) {
        final ordersCubit = OrdersCubit.get(context);
        ordersCubit.refreshOrders();
        startOrdersTimer();
      }

      _isInit = true;
    }
  }

  void startOrdersTimer() {
    if (ordersTimer != null && ordersTimer!.isActive) {
      ordersTimer!.cancel();
    }
    ordersTimer = Timer.periodic(
        Duration(seconds: CategoryCubit.appDurations.customerOrdersDuration),
        (_) {
      OrdersCubit.get(context).refreshOrders();
      OrdersCubit.get(context).getOrders();
    });
  }

  @override
  void dispose() {
    ordersTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: navKey,
      drawer: const FilterDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                if (FirebaseAuthBloc.currentUser != null) {
                  tabController!.animateTo(2);
                } else {
                  customSnackBar(
                    context: context,
                    message: CategoryCubit.appText!.needToLoginFirst,
                    color: Theme.of(context).colorScheme.primary,
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRouter.authScreen, (route) => false);
                  tabController = null;
                }
              },
              child: Container(
                padding: EdgeInsets.all(15.w),
                decoration: const BoxDecoration(
                    color: primarySwatch, shape: BoxShape.circle),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIconsLight.shopping_basket,
                      size: 22.w,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      CategoryCubit.appText!.order,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (tabController!.index > 0) {
            tabController!.animateTo(0);
            return false;
          } else {
            final now = DateTime.now();
            const maxDuration = Duration(seconds: 2);
            final isWarning = lastPressed == null ||
                now.difference(lastPressed!) > maxDuration;

            if (isWarning) {
              lastPressed = DateTime.now();
              customSnackBar(
                context: context,
                message: CategoryCubit.appText!.doubleTapToClose,
                color: Theme.of(context).colorScheme.primary,
              );
              return false;
            } else {
              return true;
            }
          }
        },
        child: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: ProductsCubit.get(context),
                ),
                BlocProvider.value(
                  value: OrdersCubit.get(context),
                ),
              ],
              child: const HomeTab(),
            ),
            const SectionsTab(),
            const CreateOrderScreen(),
            OrdersMobile(),
            // const InboxTab(),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: CustomerCubit.get(context),
                ),
                BlocProvider.value(
                  value: ProductsCubit.get(context),
                ),
              ],
              child: ProfileTab(
                productsCubit: ProductsCubit.get(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 65.w,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, -10),
              )
            ],
          ),
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return TabBar(
                controller: tabController,
                labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      height: 1,
                    ),
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: darkGrey.withOpacity(0.6),
                unselectedLabelStyle:
                    Theme.of(context).textTheme.bodyText2!.copyWith(
                          height: 0.8,
                        ),
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 0.1,
                padding: EdgeInsets.zero,
                tabs: [
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return Tab(
                        icon: Icon(
                          IconlyLight.home,
                          size: 22.w,
                        ),
                        text: CategoryCubit.appText!.explore,
                      );
                    },
                  ),
                  Tab(
                    icon: Icon(
                      IconlyLight.category,
                      size: 22.w,
                    ),
                    text: CategoryCubit.appText!.categories,
                  ),
                  const Tab(icon: SizedBox(), text: ''),

                  Tab(
                    icon: Icon(
                      IconlyLight.document,
                      size: 22.w,
                    ),
                    text: CategoryCubit.appText!.orders,
                  ),
                  // Tab(
                  //   icon: Icon(
                  //     FontAwesomeIconsLight.inbox,
                  //     size: 22.w,
                  //   ),
                  //   text: CategoryCubit.appText!.inbox,
                  // ),
                  /*
                          Tab(
                            icon: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              clipBehavior: Clip.none,
                              children: [
                                Icon(ETagerIcons.cart_arrow_down, size: 22.w),
                                BlocBuilder<CartCubit, CartState>(
                                  builder: (context, state) {
                                    final cartModel = CartCubit.get(context).cartModel;
                                    if (cartModel != null && cartModel.itemsCount > 0) {
                                      return Positioned.directional(
                                        textDirection: Languages.of(context) is LanguageAr
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        top: -vSmallPadding * 0.8,
                                        end: -hMediumPadding * 0.9,
                                        child:
                                            OvalNotifyCount(count: cartModel.itemsCount),
                                      );
                                    } else {
                                      return const Offstage();
                                    }
                                  },
                                ),
                              ],
                            ),
                            text: CategoryCubit.appText!.cart,
                          ),
                          */
                  Tab(
                    icon: Icon(FontAwesomeIconsLight.user, size: 22.w),
                    text: CategoryCubit.appText!.account,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
