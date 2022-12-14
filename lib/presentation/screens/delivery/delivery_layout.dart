import 'dart:async';

import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/delivery/delivery_orders_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/notifications/notifications_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/profile/profile_tab.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:iconly/iconly.dart';

TabController? deliveryTabCtrl;

class DeliveryLayout extends StatefulWidget {
  const DeliveryLayout({Key? key}) : super(key: key);
  @override
  _DeliveryLayoutState createState() => _DeliveryLayoutState();
}

class _DeliveryLayoutState extends State<DeliveryLayout>
    with SingleTickerProviderStateMixin {
  DateTime? lastPressed;
  bool _isInit = false;
  int initialIndex = 0;
  Timer? ordersTimer;
  late final OrdersCubit ordersCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    deliveryTabCtrl ??= TabController(
      length: 3,
      vsync: this,
    );

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      ordersCubit.refreshOrders();
      startOrdersTimer();
      _isInit = true;
    }
  }

  Future<void> startOrdersTimer() async {
    if (ordersTimer != null && ordersTimer!.isActive) {
      ordersTimer!.cancel();
    }
    ordersTimer = Timer.periodic(
        Duration(seconds: CategoryCubit.appDurations.deliveryOrdersDuration),
        (timer) {
      ordersCubit.refreshOrders();
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
      body: WillPopScope(
        onWillPop: () async {
          if (deliveryTabCtrl!.index > 0) {
            deliveryTabCtrl!.animateTo(0);
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
          controller: deliveryTabCtrl,
          children: [
            BlocProvider.value(
              value: OrdersCubit.get(context),
              child: const DeliveryOrdersScreen(),
            ),
            const NotificationsScreen(),
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
          ),
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return TabBar(
                controller: deliveryTabCtrl,
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
                          IconlyLight.paper,
                          size: 22.w,
                        ),
                        text: CategoryCubit.appText!.orders,
                      );
                    },
                  ),
                  Tab(
                    icon: Icon(
                      FontAwesomeIconsLight.bell,
                      size: 22.w,
                    ),
                    text: CategoryCubit.appText!.notifications,
                  ),
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
