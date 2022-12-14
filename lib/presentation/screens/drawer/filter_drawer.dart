import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/drawer/filter_drawer_mobile.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({
    Key? key,
    this.isFilterScreen = false,
  }) : super(key: key);
  final bool isFilterScreen;

  @override
  Widget build(BuildContext context) {
    return FilterDrawerMobile(isFilterScreen: isFilterScreen);
  }
}
