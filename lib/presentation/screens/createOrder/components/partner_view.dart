import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/presentation/widgets/my_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnerView extends StatelessWidget {
  const PartnerView({
    Key? key,
    required this.partner,
  }) : super(key: key);

  final PartnerModel? partner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: vMediumPadding),
        Row(
          children: [
            SizedBox(width: hMediumPadding),
            if (partner!.avatarUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(veryLargeRadius * 10),
                child: MyNetworkImage(
                  image: partner!.avatarUrl!,
                  width: 55.w,
                  height: 55.w,
                ),
              ),
            SizedBox(width: hMediumPadding),
            Text(
              partner!.name,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        SizedBox(height: vMediumPadding),
      ],
    );
  }
}
