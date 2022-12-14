import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/loadingSpinner/loading_spinner.dart';

class NotificationsMobile extends StatefulWidget {
  const NotificationsMobile({Key? key}) : super(key: key);

  @override
  State<NotificationsMobile> createState() => _NotificationsMobileState();
}

class _NotificationsMobileState extends State<NotificationsMobile> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      NotificationsCubit.get(context).readNotificationMsg();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final newNotifications = [CategoryCubit.appText!.newNotify1, CategoryCubit.appText!.earlierNotify1];
    // final earlierNotifications = [
    //   '${CategoryCubit.appText!.earlierNotify1} ${CategoryCubit.appText!.earlierNotify1}',
    //   CategoryCubit.appText!.newNotify1,
    //   CategoryCubit.appText!.newNotify1,
    // ];

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Scaffold(
          body: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final notifications =
                  NotificationsCubit.get(context).notifications;
              if (state is! NotificationsGetLoading) {
                if (notifications.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        NotificationsCubit.get(context).getNotifications(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: vMediumPadding),
                          ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final currentNotification = notifications[index];
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: ListTile(
                                  title: Text(currentNotification.subject),
                                  minLeadingWidth: 30,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(currentNotification.message.trim()),
                                      // SizedBox(height: vVerySmallPadding),
                                    ],
                                  ),
                                  leading: const Icon(ETagerIcons.bell),
                                  trailing: Text(
                                    currentNotification.date.substring(0, 10),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  // tileColor: isDark ? darkGrey : lightGrey,
                                  isThreeLine: true,
                                  // onTap: () async {
                                  //   if (currentNotification.link.isNotEmpty) {
                                  //     final validLink =
                                  //         await canLaunch(currentNotification.link);
                                  //     if (validLink) {
                                  //       NotificationsCubit.get(context)
                                  //           .readNotificationMsg();
                                  //       await launch(currentNotification.link);
                                  //     }
                                  //   }
                                  // },
                                ),
                              );
                            },
                          ),
                          // buildHeaderTitle(CategoryCubit.appText!.earlier, context),
                          // ListView.builder(
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: earlierNotifications.length,
                          //   itemBuilder: (context, index) {
                          //     return ListTile(
                          //       title: Text(earlierNotifications[index]),
                          //       subtitle: Text(CategoryCubit.appText!.timeAgo2),
                          //       leading: index > 0
                          //           ? const Icon(ETagerIcons.car)
                          //           : const Icon(ETagerIcons.gift),
                          //       isThreeLine: true,
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return EmptyScreenView(
                    icon: ETagerIcons.bell_slash,
                    subtitle: CategoryCubit.appText!.noNotification,
                    shiftLeft: true,
                  );
                }
              } else {
                return const LoadingSpinner();
              }
            },
          ),
        );
      },
    );
  }

  Padding buildHeaderTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
        vertical: vMediumPadding,
      ),
      child: Text(
        '$title:',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
