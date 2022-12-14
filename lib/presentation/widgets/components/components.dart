import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/page_model.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/inbox_tab.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/loading_image_container.dart';
import 'package:allin1/presentation/widgets/notificationCount/notification_count.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

void customSnackBar(
    {required BuildContext context,
    required String message,
    Color color = Colors.red,
    Widget? trailing,
    int durationBySeconds = 4}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              textAlign: trailing != null ? TextAlign.start : TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: durationBySeconds),
    ),
  );
}

Future<bool?> showWarningDialog(BuildContext context,
    {String? content,
    String? title,
    String? lfButtonTxt,
    String? rtButtonTxt}) {
  return showCupertinoDialog<bool?>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title ?? Languages.of(context).error,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: Text(
          content ?? Languages.of(context).connectYourDevice,
          style: Theme.of(context).textTheme.caption,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              lfButtonTxt ?? Languages.of(context).exitTxt,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              rtButtonTxt ?? Languages.of(context).tryAgain,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({
    Key? key,
    required this.isArabic,
  }) : super(key: key);

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InboxTab(),
          )),
      borderRadius: BorderRadius.circular(largeRadius * 2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hSmallPadding),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(
              ETagerIcons.bell,
              size: 20.w,
              color: iconGreyColor,
            ),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final newNotifications =
                    NotificationsCubit.get(context).notificationCount;
                if (newNotifications > 0) {
                  return Positioned.directional(
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    top: vSmallPadding * 1.5,
                    end: -hVerySmallPadding * 2.2,
                    child: OvalNotifyCount(count: newNotifications),
                  );
                } else {
                  return const Offstage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

AppBar buildDefaultAppBar(BuildContext context, {String? title}) {
  return AppBar(
    leadingWidth: 0,
    toolbarHeight: 70.w,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
        vertical: hSmallPadding,
      ).copyWith(
        right: hVerySmallPadding,
        left: ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
      ),
      child: title != null
          ? Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            )
          : Row(
              children: [
                Image.asset(
                  'assets/images/Basita.png',
                  fit: BoxFit.contain,
                  width: 100.w,
                  height: 50.w,
                  color: primarySwatch,
                ),
              ],
            ),
    ),
    titleSpacing: hMediumPadding,
  );
}

AppBar buildDefaultAppBarTablet(BuildContext context) {
  return AppBar(
    leadingWidth: 0,
    toolbarHeight: ScreenUtil().screenWidth > 800 ? 80 : 70,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().screenWidth > 800
            ? hLargePaddingTab
            : hMediumPaddingTab,
        vertical: hSmallPaddingTab,
      ).copyWith(
        right: hVerySmallPaddingTab,
        left: ScreenUtil().screenWidth > 800
            ? hLargePaddingTab
            : hMediumPaddingTab,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            width: 70,
            height: 40,
          ),
          const SizedBox(width: hVerySmallPaddingTab * 0.8),
          Text(
            'Glori Safari',
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: const Color(0xff4B4B4B),
                  fontFamily: 'Roboto',
                  height: 2,
                  fontSize: 10.sp,
                ),
          ),
        ],
      ),
    ),
    titleSpacing: 0,
    actions: [
      InkWell(
        onTap: () => Navigator.pushNamed(context, AppRouter.notifications),
        borderRadius: BorderRadius.circular(largeRadius * 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hSmallPaddingTab),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                ETagerIcons.bell,
                size: 20,
                color: iconGreyColor,
              ),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  final newNotifications =
                      NotificationsCubit.get(context).notificationCount;
                  if (newNotifications > 0) {
                    return Positioned.directional(
                      textDirection: TextDirection.ltr,
                      top: vSmallPadding * 1.5,
                      end: -hVerySmallPaddingTab * 2.2,
                      child: OvalNotifyCount(count: newNotifications),
                    );
                  } else {
                    return const Offstage();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      SizedBox(
          width: ScreenUtil().screenWidth > 800
              ? hMediumPaddingTab
              : hSmallPaddingTab),
    ],
  );
}

Future showLoadingDialog(BuildContext context, {String? title}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    useSafeArea: true,
    builder: (context) => AlertDialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius)),
      clipBehavior: Clip.antiAlias,
      contentPadding: EdgeInsets.all(hMediumPadding),
      title: title != null
          ? Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            )
          : null,
      content: Padding(
        padding: EdgeInsets.symmetric(
            vertical: vMediumPadding, horizontal: hMediumPadding),
        child: SizedBox(
          height: 5.w,
          child: const Center(
            child: LinearProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<dynamic> buildPolicyBottomSheet(BuildContext context,
    {required String title, required PageModel policyModel}) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAlias,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: 0.75.sh,
        padding: EdgeInsets.symmetric(
          horizontal:
              ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
          vertical: vMediumPadding,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(largeRadius),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Scrollbar(
          radius: Radius.circular(mediumRadius),
          thumbVisibility: true,
          thickness: hSmallPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 50),
                    Expanded(
                      child: Center(
                        child: SmallHeadline(title: title),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: mediumRadius,
                        backgroundColor: authBackgroundColor,
                        child: Icon(
                          Icons.close,
                          size: 18.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: hSmallPadding),
                  ],
                ),
                SizedBox(height: vVerySmallPadding),
                Container(
                  height: 7.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(smallRadius),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: vMediumPadding),
                if (policyModel.image != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: hMediumPadding),
                    child: CachedNetworkImage(
                      imageUrl: policyModel.image!.url,
                      height: 0.18.sh,
                      width: 0.85.sw,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => LoadingImageContainer(
                        height: 0.18.sh,
                        width: 0.85.sw,
                      ),
                      errorWidget: (context, url, error) =>
                          LoadingImageContainer(
                        height: 0.18.sh,
                        width: 0.85.sw,
                        repeat: false,
                      ),
                    ),
                  ),
                SizedBox(height: vMediumPadding),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: hMediumPadding),
                  child: Text(
                    policyModel.content,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Container buildOrderItem(
  BuildContext context, {
  required String title,
  String? value,
  Widget? valueWidget,
  Color? color,
  Color? textColor,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: vVerySmallPadding),
    color: color,
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: hSmallPadding,
          vertical: color != null ? vSmallPadding : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: textColor,
                ),
          ),
          if (value != null)
            Text(
              value,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: textColor,
                  ),
            )
          else if (valueWidget != null)
            valueWidget,
        ],
      ),
    ),
  );
}

Color getColorByValue(String nasaColor) {
  final colorHex = nasaColor.split('#').last;
  final colorValue = int.parse('0xff$colorHex');
  final color = Color(colorValue);

  return color;
}

Color getColorByName(String colorName) {
  late Color color;
  if (colorName.toLowerCase() == 'white' || colorName.toLowerCase() == 'أبيض') {
    color = Colors.white;
  } else if (colorName.toLowerCase() == 'black' ||
      colorName.toLowerCase() == 'أسود') {
    color = Colors.black;
  } else if (colorName.toLowerCase() == 'blue' ||
      colorName.toLowerCase() == 'أزرق') {
    color = const Color(0xff0040f2);
  } else if (colorName.toLowerCase() == 'brown' ||
      colorName.toLowerCase() == 'بني') {
    color = const Color(0xff590000);
  } else if (colorName.toLowerCase() == 'burgundy' ||
      colorName.toLowerCase() == 'بني') {
    color = const Color(0xff800020);
  } else if (colorName.toLowerCase() == 'cyan' ||
      colorName.toLowerCase() == 'لبني') {
    color = Colors.cyan;
  } else if (colorName.toLowerCase() == 'orange' ||
      colorName.toLowerCase() == 'برتقالي') {
    color = Colors.orange;
  } else if (colorName.toLowerCase() == 'green' ||
      colorName.toLowerCase() == 'أخضر') {
    color = const Color(0xff009e02);
  } else if (colorName.toLowerCase() == 'grey' ||
      colorName.toLowerCase() == 'gray' ||
      colorName.toLowerCase() == 'رمادي') {
    color = const Color(0xff727272);
  } else if (colorName.toLowerCase() == 'indigo' ||
      colorName.toLowerCase() == 'نيلي') {
    color = Colors.indigo;
  } else if (colorName.toLowerCase() == 'lime' ||
      colorName.toLowerCase() == 'لموني') {
    color = Colors.lime;
  } else if (colorName.toLowerCase() == 'pink' ||
      colorName.toLowerCase() == 'زهري') {
    color = Colors.pink;
  } else if (colorName.toLowerCase() == 'violet' ||
      colorName.toLowerCase() == 'بنفسجي') {
    color = const Color(0xff8F00FF);
  } else if (colorName.toLowerCase() == 'red' ||
      colorName.toLowerCase() == 'أحمر') {
    color = const Color(0xffdd0000);
  } else if (colorName.toLowerCase() == 'yellow' ||
      colorName.toLowerCase() == 'أصفر') {
    color = const Color(0xfff2ea00);
  } else if (colorName.toLowerCase() == 'beige' ||
      colorName.toLowerCase() == 'nude' ||
      colorName.toLowerCase() == 'بيج') {
    color = const Color(0xfff5f5dc);
  } else if (colorName.toLowerCase() == 'nude' ||
      colorName.toLowerCase() == 'بيج') {
    color = const Color(0xfff5f5dc);
  } else if (colorName.toLowerCase() == 'rose' ||
      colorName.toLowerCase() == 'روز') {
    color = const Color(0xffff007f);
  } else if (colorName.toLowerCase() == 'purple' ||
      colorName.toLowerCase() == 'move' ||
      colorName.toLowerCase() == 'موف') {
    color = Colors.purple;
  } else if (colorName.toLowerCase() == 'Cashmere' ||
      colorName.toLowerCase() == 'كاشمير') {
    color = const Color(0xffD1B399);
  } else if (colorName.toLowerCase() == 'simone' ||
      colorName.toLowerCase() == 'سيموني') {
    color = const Color(0xffabad8f);
  } else if (colorName.toLowerCase() == 'fushia' ||
      colorName.toLowerCase() == 'فوشيا') {
    color = const Color(0xfff400a7);
  } else if (colorName.toLowerCase() == 'navy' ||
      colorName.toLowerCase() == 'كحلي') {
    color = const Color(0xff000080);
  } else if (colorName.toLowerCase() == 'gold' ||
      colorName.toLowerCase() == 'ذهبي') {
    color = const Color(0xffefc932);
  } else if (colorName.toLowerCase() == 'camel' ||
      colorName.toLowerCase() == 'camal' ||
      colorName.toLowerCase() == 'جملي') {
    color = const Color(0xffc6710f);
  } else if (colorName.toLowerCase() == 'caffe' ||
      colorName.toLowerCase() == 'coffe') {
    color = const Color(0xffd3a489);
  } else if (colorName.toLowerCase() == 'off-white' ||
      colorName.toLowerCase() == 'أوف-وايت') {
    color = const Color(0xffe9d6cd);
  } else {
    color = Colors.black12;
  }
  return color;
}
