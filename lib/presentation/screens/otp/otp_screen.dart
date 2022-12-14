import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/otp/components/otp_form.dart';
import 'package:allin1/presentation/widgets/widgetsClasses/widgets.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({
    Key? key, required this.smsEgypt,
  }) : super(key: key);
  final bool smsEgypt;
  @override
  Widget build(BuildContext context) {
    final customerCubit = CustomerCubit.get(context);
    final phoneNumber = customerCubit.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200.w,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(width: hMediumPadding),
              const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff909090),
              ),
              Text(
                CategoryCubit.appText!.back,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: const Color(0xff909090),
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
            vertical: vMediumPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp.png',
                height: 0.40.sh,
                width: 0.6.sw,
              ),
              Text(
                CategoryCubit.appText!.verificationCode,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: vVerySmallPadding),
              const UnderlineContainer(),
              SizedBox(height: vLargePadding),
              Text(
                "${CategoryCubit.appText!.codeSent} $phoneNumber",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: vVerySmallPadding),
              Text(
                CategoryCubit.appText!.enterThemCodeBelow,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: vMediumMargin),
              SizedBox(
                width: double.infinity,
                child: OtpForm(
                  phone: phoneNumber!,
                  smsEgypt: smsEgypt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
