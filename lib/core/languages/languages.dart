import 'package:allin1/core/languages/language_ar.dart';
import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages) ?? LanguageAr();
  }

  String get appName;
  String get start;
  String get connectionFailed;
  String get serviceFee;
  String get error;
  String get connectYourDevice;
  String get tryAgain;
  String get exitTxt;
  String get packageAdded;
  String get pendingReview;
  String get assigningDelivery;
  String get waiting;
  String get pendingPayment;
  String get onWay;
  String get delivered;
  String get cancelled;
  String get rateDelivery;
  String get deleteAccount;
  String get areYouSure;
  String get deleteAccountWarning;
}
