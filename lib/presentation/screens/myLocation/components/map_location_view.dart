import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class MapLocationView extends StatelessWidget {
  final LocationModel location;
  final bool hasColor;
  const MapLocationView({
    Key? key,
    required this.location,
    required this.hasColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(
          context,
          AppRouter.map,
          arguments: location,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: hSmallPadding, vertical: vVerySmallMargin),
        color: hasColor ? authBackgroundColor.withOpacity(0.5) : null,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(smallRadius),
              child: Image.asset(
                'assets/images/map.png',
                width: 120.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: hSmallPadding),
            Expanded(
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.city,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(hSmallPadding),
                            child: Icon(
                              IconlyLight.edit_square,
                              size: 24.w,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: vVerySmallPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              location.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
