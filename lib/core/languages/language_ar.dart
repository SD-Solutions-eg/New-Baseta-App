import 'package:allin1/core/languages/languages.dart';

class LanguageAr extends Languages {
  @override
  String get appName => "Allin One";

  @override
  String get start => 'ابدأ';

  @override
  String get connectYourDevice => 'قم بتوصيل جهازك بالانترنت وحاول مرة اخرى';

  @override
  String get error => 'خطأ!';

  @override
  String get exitTxt => 'خروج';

  @override
  String get tryAgain => 'حاول مرة اخرى';
  @override
  String get packageAdded => '';

  @override
  String get connectionFailed => 'فشل الاتصال بالانترنت';

  @override
  String get assigningDelivery => "تعيين سائق";

  @override
  String get cancelled => "تم الالغاء";

  @override
  String get delivered => "تم التوصيل";

  @override
  String get onWay => "في الطريق";

  @override
  String get pendingPayment => "بانتظار الدفع";

  @override
  String get pendingReview => "جاري المراجعة";

  @override
  String get waiting => "في الانتظار";

  @override
  String get rateDelivery => 'تقييم الطيار';

  @override
  String get serviceFee => 'خدمة';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get deleteAccountWarning =>
      'سيتم حذف حسابك وجميع البيانات الخاصة بك من التطبيق. هل أنت متأكد من أنك تريد حذف حسابك؟';
}
