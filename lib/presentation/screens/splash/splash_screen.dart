import 'dart:async';

import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final FirebaseAuthBloc authBloc;
  const SplashScreen({
    Key? key,
    required this.authBloc,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    animation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(animationController);

    _controller = VideoPlayerController.asset("assets/animations/splash.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
        });
      });
    });

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FirebaseAuthBloc, FirebaseAuthState>(
        listenWhen: (previous, current) {
          if (previous is AuthCheckLoading || current is AuthCheckFailed) {
            return true;
          }
          return false;
        },
        listener: (context, state) async {
          final categoryCubit = CategoryCubit.get(context);
          final orderCubit = OrdersCubit.get(context);
          if (state is! AuthCheckFailed ||
              state is! AuthCheckLoading ||
              state is! FirebaseAuthInitial) {
            // await Future.delayed(const Duration(minutes: 10));
            await categoryCubit.getAppText(context);
            await categoryCubit.getAppDurations();
            if (CategoryCubit.appText != null) {
              if (mounted) {
                try {
                  if (FirebaseAuthBloc.currentUser != null &&
                      FirebaseAuthBloc.currentUser!.role == UserType.delivery) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.deliveryLayout,
                      (route) => false,
                    );
                  } else {
                    categoryCubit.getPartnersBySection(0);
                    await categoryCubit.getSlideshow(context);
                    await orderCubit.getPaymentGateways();
                    await categoryCubit.getPayTabsAccount();
                    await orderCubit.getOrders();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.homeLayout,
                      (route) => false,
                    );

                    categoryCubit.getAllSections();
                    // categoryCubit.getAllCities();
                  }
                } catch (e) {
                  print('message');
                }
              }
            } else {
              final tryAgain = await showWarningDialog(context);
              if (tryAgain != null && tryAgain) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.splash,
                  (route) => false,
                );
              } else {
                await SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
              }
            }
          } else if (state is AuthCheckLoading ||
              state is FirebaseAuthInitial) {
            // Do Nothing...
          } else {
            await categoryCubit.getAppText(context);

            final tryAgain = await showWarningDialog(
              context,
              title: state.error,
            );
            if (tryAgain != null && tryAgain) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.splash,
                (route) => false,
              );
            } else {
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          }
        },
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Container(),
      ),
    );
  }
}
