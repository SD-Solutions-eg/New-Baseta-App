import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class ScrollableTabView extends StatelessWidget {
  final String title;
  final Widget? topChild;
  final Widget child;
  final bool roundedBottom;

  const ScrollableTabView({
    Key? key,
    required this.title,
    this.topChild,
    this.roundedBottom = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ColoredBox(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().screenWidth > 800
                              ? hLargePadding
                              : hMediumPadding,
                          vertical: vMediumPadding,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(hSmallPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: const Icon(Icons.arrow_back_outlined),
                              ),
                            ),
                            SizedBox(width: hMediumPadding),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: vMediumPadding)
                                      .copyWith(top: vSmallPadding),
                              child: Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (topChild != null) topChild!,
                  ],
                ),
              ),
              SizedBox(height: vMediumPadding),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadiusDirectional.vertical(
                    top: Radius.circular(largeRadius),
                    bottom: roundedBottom
                        ? Radius.circular(largeRadius)
                        : Radius.zero,
                  ),
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
