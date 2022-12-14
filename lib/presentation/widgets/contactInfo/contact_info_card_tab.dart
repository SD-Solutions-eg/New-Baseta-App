import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class ContactInfoCardTablet extends StatelessWidget {
  const ContactInfoCardTablet({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.circleColor,
    required this.titleColor,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final VoidCallback onTap;
  final Color circleColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: hVerySmallPaddingTab,
          vertical: vSmallPaddingTab,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(mediumRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              spreadRadius: 4,
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 800
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vSmallPaddingTab,
              ),
              child: Container(
                padding: const EdgeInsets.all(hSmallPaddingTab * 1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: icon,
              ),
            ),
            const SizedBox(height: vSmallPaddingTab),
            FittedBox(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: titleColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
