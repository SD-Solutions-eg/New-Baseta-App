import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hMediumPadding,
          vertical: vMediumPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/done.png',
              height: 230.w,
              width: 230.w,
            ),
            SizedBox(height: vLargeMargin * 1.1.h),
            Text(
              CategoryCubit.appText!.youSuccessfullyVerifyYourAccount,
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8),
            ),
            SizedBox(height: vLargeMargin * 1.1.h),
            DefaultButton(
              text: CategoryCubit.appText!.start,
              smallSize: true,
              height: 50.h,
              width: 220.w,
              borderRadius: largeRadius,
              onPressed: () {
                if (FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.deliveryLayout,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.homeLayout,
                    (route) => false,
                  );
                }
              },
            ),
            SizedBox(height: vLargeMargin),
          ],
        ),
      ),
    );
  }
}
