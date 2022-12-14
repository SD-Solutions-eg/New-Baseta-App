import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:allin1/presentation/widgets/my_network_image.dart';
import 'package:iconly/iconly.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({
    Key? key,
    required this.section,
    required this.partner,
    this.imageHeight,
  }) : super(key: key);
  final double? imageHeight;
  final SectionModel section;
  final PartnerModel partner;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (FirebaseAuthBloc.currentUser != null) {
          Navigator.pushNamed(context, AppRouter.createOrder, arguments: {
            'section': section,
            'partner': partner,
          });
        } else {
          customSnackBar(
            context: context,
            message: CategoryCubit.appText!.needToLoginFirst,
            color: Theme.of(context).colorScheme.primary,
          );
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.authScreen, (route) => false);
          tabController = null;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vVerySmallPadding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(mediumRadius),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: iconGreyColor.withOpacity(0.8),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              if (partner.avatarUrl != null)
                MyNetworkImage(
                  image: partner.avatarUrl!,
                  width: double.infinity,
                  height: imageHeight ?? 0.43.sw,
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                        horizontal: hVerySmallMargin, vertical: vSmallPadding)
                    .copyWith(bottom: vVerySmallPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(partner.name,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    )),
                      ],
                    ),
                    SizedBox(height: vVerySmallPadding),
                    if (partner.area != null)
                      Row(
                        children: [
                          Icon(
                            IconlyBold.location,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18.w,
                          ),
                          SizedBox(width: hVerySmallPadding),
                          Text(
                            partner.area!.name,
                          ),
                          const Spacer(),
                          Icon(
                            FontAwesomeIconsLight.shopping_bag,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22.w,
                          ),
                        ],
                      ),
                    SizedBox(height: vVerySmallPadding),
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
