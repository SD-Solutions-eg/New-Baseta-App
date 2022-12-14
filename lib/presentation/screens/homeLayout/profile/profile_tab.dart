import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/profile/profile_tab_mobile.dart';

class ProfileTab extends StatelessWidget {
  final ProductsCubit productsCubit;
  const ProfileTab({
    Key? key,
    required this.productsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileTabMobile(productsCubit: productsCubit);
  }
}
