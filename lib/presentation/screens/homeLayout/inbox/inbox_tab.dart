import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/chats_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/notifications/notifications_screen.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';

class InboxTab extends StatefulWidget {
  const InboxTab({Key? key}) : super(key: key);
  @override
  _InboxTabState createState() => _InboxTabState();
}

class _InboxTabState extends State<InboxTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    NotificationsCubit.get(context).getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 65.w,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                child: Text(
                  CategoryCubit.appText!.inbox,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            body: Column(
              children: [
                const CustomDivider(),
                TabBar(
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorPadding:
                      EdgeInsets.symmetric(horizontal: hLargePadding),
                  unselectedLabelColor: darkGrey.withOpacity(0.6),
                  tabs: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: vMediumPadding),
                      child: Text(CategoryCubit.appText!.notifications),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: vMediumPadding),
                      child: Text(CategoryCubit.appText!.chats),
                    ),
                  ],
                ),
                const CustomDivider(),
                const Expanded(
                  child: TabBarView(
                    children: [
                      NotificationsScreen(),
                      ChatScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
