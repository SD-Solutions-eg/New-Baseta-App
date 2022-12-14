import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class ScrollableTabViewTablet extends StatelessWidget {
  final String title;
  final Widget? topChild;
  final Widget child;
  final bool roundedBottom;

  const ScrollableTabViewTablet({
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
                              : hMediumPaddingTab,
                          vertical: vMediumPaddingTab,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(hSmallPaddingTab),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: const Icon(Icons.arrow_back_outlined),
                              ),
                            ),
                            const SizedBox(width: hMediumPaddingTab),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                      vertical: vMediumPaddingTab)
                                  .copyWith(top: vSmallPaddingTab),
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.headline5,
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
              const SizedBox(height: vMediumPaddingTab),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadiusDirectional.vertical(
                    top: const Radius.circular(largeRadiusTab),
                    bottom: roundedBottom
                        ? const Radius.circular(largeRadiusTab)
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
