// ignore_for_file: deprecated_member_use

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScopeLinksCopyright extends StatelessWidget {
  final String appVersion;
  const ScopeLinksCopyright({
    Key? key,
    required this.appVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => launch('https://scopelinks.com'),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomDivider(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hMediumPadding, vertical: vVerySmallPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Application Made By ',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .color!
                                  .withOpacity(0.8),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                              fontSize: 15.sp,
                              height: 1.5,
                            ),
                        children: [
                          TextSpan(
                            text: 'Scope Links',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color!
                                          .withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      fontSize: 15.sp,
                                      height: 1.5,
                                    ),
                          ),
                          TextSpan(
                            text: ' Team ©',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color!
                                          .withOpacity(0.8),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                      fontSize: 15.sp,
                                      height: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'www.scopelinks.com',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .color!
                                .withOpacity(0.8),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            fontSize: 15.sp,
                            height: 1.5,
                          ),
                    ),
                    if (appVersion.isNotEmpty)
                      SizedBox(height: vVerySmallPadding),
                    if (appVersion.isNotEmpty)
                      Text(
                        'v.$appVersion',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .color!
                                  .withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              height: 1,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
