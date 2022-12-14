import 'package:allin1/presentation/screens/homeLayout/home_layout_mobile.dart';
import 'package:flutter/material.dart';

TabController? tabController;
GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class HomeLayout extends StatelessWidget {
  final bool? reload;
  const HomeLayout({
    Key? key,
    required this.reload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeLayoutMobile(reload: reload);
  }
}
