import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/repositories/category_repository.dart';
import 'package:allin1/data/repositories/firebase_repository.dart';
import 'package:allin1/data/repositories/information_repository.dart';
import 'package:allin1/data/repositories/notifications_repository.dart';
import 'package:allin1/data/repositories/order_repository.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/data/services/authentication_services.dart';
import 'package:allin1/data/services/firebase_auth_services.dart';
import 'package:allin1/data/services/information_services.dart';
import 'package:allin1/data/services/local_notifications.dart';
import 'package:allin1/data/services/notifications_services.dart';
import 'package:allin1/data/services/order_services.dart';
import 'package:allin1/data/services/product_services.dart';
import 'package:allin1/firebase_options.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/customer/customer_cubit.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:allin1/logic/cubit/theme/theme_cubit.dart';
import 'package:allin1/logic/debug/app_bloc_observer.dart';
import 'package:allin1/my_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('On Background Handler data: ${message.data}');
  log('On Background Handler category: ${message.category}');
  log('On Background Handler from: ${message.from}');
  onNotifications.add(message.data.toString());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('Firebase initialized successfully');
  final connectivity = Connectivity();
  await initHydratedStorage();
  // await hydratedStorage.clear();
  Bloc.observer = AppBlocObserver();
  HttpOverrides.global = MyHttpOverrides();
  runApp(InitialApp(connectivity: connectivity));
}

class InitialApp extends StatelessWidget {
  InitialApp({
    Key? key,
    required this.connectivity,
  }) : super(key: key);

  final authServices = AuthenticationServices();
  final firebaseServices = FirebaseAuthenticationServices();
  final notificationsServices = NotificationsServices();
  final categoryServices = ProductServices();
  final infoServices = InformationServices();
  final ordersServices = OrdersServices();
  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(authServices),
        ),
        RepositoryProvider(
          create: (context) => FirebaseRepository(firebaseServices),
        ),
        RepositoryProvider(
          create: (context) => NotificationRepository(notificationsServices),
        ),
        RepositoryProvider(
          create: (context) => CategoryRepository(categoryServices),
        ),
        RepositoryProvider(
          create: (context) => InformationRepository(infoServices),
        ),
        RepositoryProvider(
          create: (context) => OrdersRepository(ordersServices),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                InternetCubit(connectivity)..monitorInternetConnection(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => NotificationsCubit(
              RepositoryProvider.of<NotificationRepository>(context),
              BlocProvider.of<InternetCubit>(context),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => CategoryCubit(
              RepositoryProvider.of<CategoryRepository>(context),
              BlocProvider.of<InternetCubit>(context),
            )..getAppText(context),
          ),
          BlocProvider(
            create: (context) => OrdersCubit(
              RepositoryProvider.of<OrdersRepository>(context),
              BlocProvider.of<InternetCubit>(context),
            )..getOrders(),
          ),
          BlocProvider(
            create: (context) => FirebaseAuthBloc(
              RepositoryProvider.of<FirebaseRepository>(context),
              BlocProvider.of<InternetCubit>(context),
              RepositoryProvider.of<UserRepository>(context),
              BlocProvider.of<NotificationsCubit>(context),
              BlocProvider.of<OrdersCubit>(context),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerCubit(
              RepositoryProvider.of<UserRepository>(context),
              BlocProvider.of<InternetCubit>(context),
            ),
          ),
          BlocProvider(
            create: (context) => InformationCubit(
              RepositoryProvider.of<InformationRepository>(context),
              BlocProvider.of<InternetCubit>(context),
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          builder: (_, __) => MyApp(),
        ),
      ),
    );
  }
}
