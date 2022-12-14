import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/accountDetails/account_details_mobile.dart';
import 'package:allin1/presentation/screens/accountDetails/account_details_tablet.dart';

class AccountDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtil().scaleWidth > 800
        ? AccountDetailsTablet()
        : AccountDetailsMobile();
  }
}
