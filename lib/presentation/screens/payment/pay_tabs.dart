// import 'dart:developer';

// import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
// import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
// import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

// Future<bool> payWithPayTabs() async {
//   final billingDetails = BillingDetails("John Smith", "email@domain.com",
//       "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
//   final shippingDetails = ShippingDetails("John Smith", "email@domain.com",
//       "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
//   final configuration = _configurePayTabs(billingDetails, shippingDetails);
//   final paymentDone = await _startPayment(configuration);
//   return paymentDone;
// }

// PaymentSdkConfigurationDetails _configurePayTabs(
//     BillingDetails billingDetails, ShippingDetails? shippingDetails) {
//   final configuration = PaymentSdkConfigurationDetails(
//     profileId: "84942",
//     serverKey: "SGJNB69RHB-J29JB6WZRH-6MDDRTZHTK",
//     clientKey: "CQKMP7-M9GR6M-P62GV9-TB2K67",
//     cartId: "1234515234",
//     cartDescription: "cart desc",
//     merchantName: "NAAS",
//     screentTitle: "Pay with Card",
//     billingDetails: billingDetails,
//     shippingDetails: shippingDetails,
//     locale:
//         PaymentSdkLocale.EN, //PaymentSdkLocale.AR or PaymentSdkLocale.DEFAULT
//     amount: 100.0,
//     currencyCode: "EGP",
//     merchantCountryCode: "EG",
//   );
//   final theme = IOSThemeConfigurations();
//   theme.logoImage = 'assets/images/logo.png';
//   configuration.iOSThemeConfigurations = theme;
//   return configuration;
// }

// Future<bool> _startPayment(PaymentSdkConfigurationDetails configuration) async {
//   bool paymentDone = false;
//   FlutterPaytabsBridge.startCardPayment(configuration, (event) {
//     if (event["status"] == "success") {
//       // Handle transaction details here.
//       var transactionDetails = event["data"];
//       log(transactionDetails.toString());
//       paymentDone = true;
//     } else if (event["status"] == "error") {
//       // Handle error here.
//       log('Error: ${event["data"]}');
//     } else if (event["status"] == "event") {
//       // Handle events here.
//     }
//   });

//   return paymentDone;
// }
