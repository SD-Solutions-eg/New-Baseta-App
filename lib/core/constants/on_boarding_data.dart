class OnBoardingData {
  static const title1 = 'أسهل وسائل الدفع';
  static const title2 = 'سرعة لن تتخيلها';
  static const title3 = 'معاك 24 ساعة';

  // static const description1 = 'تسوق عبر التطبيق الخاص بنا';
  // static const description2 = 'استخدام اّمن للتطبيق';
  // static const description3 = 'توصيل حتى باب المنزل';
  //
  static const title1en = 'أسهل وسائل الدفع';
  static const title2en = 'سرعة لن تتخيلها';
  static const title3en = 'معاك 24 ساعة';

  // static const description1en = 'Shop through our app';
  // static const description2en = 'Safe use of the application';
  // static const description3en = 'Delivery to the door of the house';

  static const image1 = imageMaster1;
  static const image2 = imageMaster2;
  static const image3 = imageMaster3;

  static const imageMaster1 = 'assets/images/OnBoarding #1.png';
  static const imageMaster2 = 'assets/images/OnBoarding #2.png';
  static const imageMaster3 = 'assets/images/OnBoarding #3.png';



  static const List<Map<String, dynamic>> data = [
    {
      'image': image1,
      'title': title1,
      // 'description': description1,
    },
    {
      'image': image2,
      'title': title2,
      // 'description': description2,
    },
    {
      'image': image3,
      'title': title3,
      // 'description': description3,
    },
  ];

  static const List<Map<String, dynamic>> dataEn = [
    {
      'image': image1,
      'title': title1en,
      // 'description': description1en,
    },
    {
      'image': image2,
      'title': title2en,
      // 'description': description2en,
    },
    {
      'image': image3,
      'title': title3en,
      // 'description': description3en,
    },
  ];
}
