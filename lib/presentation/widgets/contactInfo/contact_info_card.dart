import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({
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
        padding: EdgeInsets.symmetric(
          horizontal: hVerySmallPadding,
          vertical: vSmallPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
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
                vertical: vSmallPadding,
              ),
              child: Container(
                padding: EdgeInsets.all(hSmallPadding * 1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: icon,
              ),
            ),
            SizedBox(height: vSmallPadding),
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
