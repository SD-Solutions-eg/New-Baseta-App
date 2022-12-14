import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/logic/cubit/apple/apple_cubit.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/createOrder/create_order_screen.dart';
import 'package:allin1/presentation/screens/delivery/customer_location_screen.dart';
import 'package:allin1/presentation/screens/delivery/delivery_layout.dart';
import 'package:allin1/presentation/screens/delivery/view_only_map.dart';
import 'package:allin1/presentation/screens/deliveryReviews/delivery_reviews_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/chat_details_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/chats_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/notifications/notifications_screen.dart';
import 'package:allin1/presentation/screens/homeLayout/sections/sections_tab_mobile.dart';
import 'package:allin1/presentation/screens/language/language_screen.dart';
import 'package:allin1/presentation/screens/myLocation/map_screen.dart';
import 'package:allin1/presentation/screens/myLocation/my_location_screen.dart';
import 'package:allin1/presentation/screens/newAddress/new_address_screen.dart';
import 'package:allin1/presentation/screens/onBoard/on_board_screen.dart';
import 'package:allin1/presentation/screens/orders/trackOrder/track_order_screen.dart';
import 'package:allin1/presentation/screens/otp/mobile_verification_screen.dart';
import 'package:allin1/presentation/screens/otp/otp_screen.dart';
import 'package:allin1/presentation/screens/otp/verification_success_screen.dart';
import 'package:allin1/presentation/screens/resetPassword/code_and_new_password_screen.dart';
import 'package:allin1/presentation/screens/reviews/reviews_screen.dart';
import 'package:allin1/presentation/screens/section/section_screen.dart';
import 'package:allin1/presentation/widgets/loadingSpinner/loading_spinner.dart';
import 'package:allin1/presentation/widgets/loadingViewsClasses/loading_views.dart';

class AppRouter {
  final InternetCubit connection;
  static final productApiServices = ProductServices();
  static final authApiServices = AuthenticationServices();
  static final infoApiServices = InformationServices();

  final productsRepo = ProductsRepository(productApiServices);
  final infoRepo = InformationRepository(infoApiServices);

  late final ProductsCubit productsCubit;
  late final InformationCubit infoCubit;

  AppRouter(this.connection) {
    productsCubit = ProductsCubit(productsRepo, connection);
    infoCubit = InformationCubit(infoRepo, connection);
  }

  static const language = '/';
  static const splash = '/splash';
  static const onBoard = '/onBoard';
  static const authScreen = '/auth';
  static const loadingScreen = '/loading';
  static const homeLayout = '/homeLayout';
  static const aboutUs = '/aboutUs';
  static const contactUs = '/contactUs';
  static const support = '/support';
  static const imageFullScreen = '/imageFullScreen';
  static const orders = '/orders';
  static const downloads = '/downloads';
  static const accountDetails = '/accountDetails';
  static const section = '/category';
  static const search = '/search';
  static const resetPassword = '/resetPassword';
  static const orderDetails = '/orderDetails';
  static const shimmerLoading = '/shimmerLoading';
  static const otp = '/OTP';
  static const notifications = '/notifications';
  static const mobileVerification = '/mobileVerification';
  static const verificationSuccess = '/verificationsSuccess';
  static const codeAndNewPass = '/codeAndNewPass';
  static const map = '/map';
  static const chat = '/chat';
  static const chatDetails = '/chatDetails';
  static const reviews = '/reviews';
  static const deliveryReviews = '/deliveryReviews';
  static const newAddress = '/newAddress';
  static const myLocation = '/myLocation';
  static const createOrder = '/createOrder';
  static const trackOrder = '/trackOrder';
  static const deliveryLayout = '/deliveryLayout';
  static const categories = '/categories';
  static const customerLocation = '/customerLocation';
  static const viewOnlyMap = '/viewOnlyMap';

  Route onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case authScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => RegistrationCubit(
                  RepositoryProvider.of<UserRepository>(context),
                  RepositoryProvider.of<FirebaseRepository>(context),
                  connection,
                ),
              ),
              BlocProvider(
                create: (context) => LoginCubit(
                  RepositoryProvider.of<UserRepository>(context),
                  connection,
                  RepositoryProvider.of<FirebaseRepository>(context),
                ),
              ),
              BlocProvider(
                create: (context) => FacebookCubit(
                  RepositoryProvider.of<UserRepository>(context),
                  RepositoryProvider.of<FirebaseRepository>(context),
                  connection,
                ),
              ),
              BlocProvider(
                create: (context) => GoogleCubit(
                  RepositoryProvider.of<UserRepository>(context),
                  RepositoryProvider.of<FirebaseRepository>(context),
                  connection,
                ),
              ),
              BlocProvider(
                create: (context) => AppleCubit(
                  RepositoryProvider.of<UserRepository>(context),
                  RepositoryProvider.of<FirebaseRepository>(context),
                  connection,
                ),
                lazy: false,
              ),
            ],
            child: AuthScreen(),
          ),
        );

      case map:
        return MaterialPageRoute(
          builder: (context) => MapScreen(
            locationModel: args as LocationModel?,
          ),
        );
      case viewOnlyMap:
        if (args is LocationModel) {
          return MaterialPageRoute(
            builder: (context) => ViewOnlyMapScreen(
              locationModel: args,
            ),
          );
        } else {
          throw RouteExceptions('no args');
        }
      case categories:
        return MaterialPageRoute(
          builder: (context) => const SectionsTabMobile(),
        );

      case language:
        return MaterialPageRoute(
          builder: (context) => LanguageScreen(),
        );
      case onBoard:
        return MaterialPageRoute(
          builder: (context) => OnBoardingScreen(),
        );
      case reviews:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: infoCubit,
            child: const ReviewsScreen(),
          ),
        );
      case chat:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: infoCubit,
            child: const ChatScreen(),
          ),
        );
      case chatDetails:
        if (args is ChatModel) {
          return MaterialPageRoute(
            builder: (context) => ChatDetailsScreen(chatModel: args),
          );
        } else {
          throw RouteExceptions('Args Not passed');
        }
      case deliveryReviews:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: infoCubit,
            child: const DeliveryReviewsScreen(),
          ),
        );

      case splash:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: productsCubit,
            child: SplashScreen(
              authBloc: FirebaseAuthBloc.get(context)..add(InitialEvent()),
            ),
          ),
        );
      case myLocation:
        return MaterialPageRoute(
          builder: (context) => const MyLocationScreen(),
        );
      case newAddress:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => NewAddressScreen(
              title: args['title'] as String,
              isEditing: args['isEditing'] as bool?,
              fromCart: args['fromCart'] as bool? ?? false,
            ),
          );
        } else {
          throw RouteExceptions('Arguments Not found');
        }
      case loadingScreen:
        return MaterialPageRoute(
          builder: (context) => const LoadingSpinner(),
        );
      case shimmerLoading:
        return MaterialPageRoute(
          builder: (context) => const ShimmerLoading(),
        );
      case aboutUs:
        return MaterialPageRoute(
          builder: (context) => RepositoryProvider(
            create: (context) => InformationRepository(infoApiServices),
            child: BlocProvider(
              create: (context) => InformationCubit(
                RepositoryProvider.of<InformationRepository>(context),
                connection,
              )..getAboutModel(),
              child: AboutUsScreen(),
            ),
          ),
        );
      case contactUs:
        return MaterialPageRoute(
          builder: (context) => RepositoryProvider(
            create: (context) => InformationRepository(infoApiServices),
            child: BlocProvider(
              create: (context) => InformationCubit(
                RepositoryProvider.of<InformationRepository>(context),
                connection,
              )..getContactUsModel(),
              child: ContactUsScreen(),
            ),
          ),
        );
      case support:
        return MaterialPageRoute(
          builder: (context) => RepositoryProvider(
            create: (context) => InformationRepository(infoApiServices),
            child: BlocProvider(
              create: (context) => InformationCubit(
                RepositoryProvider.of<InformationRepository>(context),
                connection,
              ),
              child: SupportScreen(),
            ),
          ),
        );

      case orders:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: OrdersCubit.get(context)..getOrders(),
            child: OrdersScreen(),
          ),
        );

      case accountDetails:
        return MaterialPageRoute(
          builder: (context) => AccountDetailsScreen(),
        );

      case search:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: productsCubit,
            child: SearchScreen(),
          ),
        );

      case resetPassword:
        return MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(),
        );
      case codeAndNewPass:
        return MaterialPageRoute(
          builder: (context) =>
              CodeAndNewPasswordScreen(email: args as String?),
        );
      case notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );

      case mobileVerification:
        return MaterialPageRoute(
          builder: (context) => const MobileVerificationScreen(),
        );
      case otp:
        return MaterialPageRoute(
          builder: (context) => const OTPScreen(smsEgypt: false),
        );
      case verificationSuccess:
        return MaterialPageRoute(
          builder: (context) => const VerificationSuccessScreen(),
        );

      case createOrder:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => CreateOrderScreen(
              section: args['section'] as SectionModel,
              partner: args['partner'] as PartnerModel,
            ),
          );
        } else {
          throw RouteExceptions('Arguments Not Found');
        }
      case orderDetails:
        if (args is OrderModel) {
          return MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderModel: args),
          );
        } else {
          throw RouteExceptions('Arguments Not Found');
        }
      case trackOrder:
        if (args is OrderModel) {
          return MaterialPageRoute(
            builder: (context) => TrackOrderScreen(orderModel: args),
          );
        } else {
          throw RouteExceptions('Arguments Not Found');
        }
      case customerLocation:
        if (args is OrderModel) {
          return MaterialPageRoute(
            builder: (context) => CustomerLocationScreen(orderModel: args),
          );
        } else {
          throw RouteExceptions('Arguments Not Found');
        }
      case homeLayout:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: productsCubit,
              ),
            ],
            child: HomeLayout(reload: args as bool?),
          ),
        );
      case deliveryLayout:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: productsCubit,
              ),
            ],
            child: const DeliveryLayout(),
          ),
        );
      case imageFullScreen:
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => ImageFullScreenView(
              image: args,
            ),
          );
        } else {
          throw RouteExceptions('Argument not found');
        }

      case section:
        if (args is SectionModel) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: productsCubit,
              child: SectionScreen(
                section: args,
              ),
            ),
          );
        } else {
          throw RouteExceptions('Arguments not found');
        }

      default:
        throw RouteExceptions('Route Not Found: ${settings.name}');
    }
  }

  void dispose() {
    productsCubit.close();
  }
}
