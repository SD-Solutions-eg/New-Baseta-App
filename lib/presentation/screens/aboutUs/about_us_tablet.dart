import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/presentation/widgets/MainTabView/main_tab_view_tab.dart';
import 'package:allin1/presentation/widgets/loadingSpinner/loading_spinner_tab.dart';
import 'package:allin1/presentation/widgets/loading_image_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InformationCubit, InformationState>(
        builder: (context, state) {
          final infoCubit = InformationCubit.get(context);
          final aboutModel = infoCubit.aboutModel;
          final aboutText = infoCubit.aboutText;

          if (state is! AboutLoading && aboutModel != null ||
              aboutText != null) {
            return MainTabViewTablet(
              title: CategoryCubit.appText!.aboutUs,
              leading: true,
              showTrailing: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (aboutModel != null && aboutModel.image != null)
                      CachedNetworkImage(
                        imageUrl: aboutModel.image!.url,
                        width: double.infinity,
                        height: 0.25.sh,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => LoadingImageContainer(
                          width: double.infinity,
                          height: 0.25.sh,
                        ),
                        errorWidget: (context, url, error) =>
                            LoadingImageContainer(
                          width: double.infinity,
                          height: 0.25.sh,
                          repeat: false,
                        ),
                      ),
                    SizedBox(height: vMediumPadding),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().screenWidth > 800
                            ? hLargePadding
                            : hMediumPadding,
                        vertical: vMediumMargin,
                      ).copyWith(top: 0),
                      child: Text(
                        aboutModel?.content ?? aboutText!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              height: 2,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is! AboutLoading &&
              aboutModel == null &&
              aboutText == null) {
            return MainTabViewTablet(
              title: CategoryCubit.appText!.about,
              leading: true,
              showTrailing: true,
              child: Column(),
            );
          } else {
            return const LoadingSpinnerTablet();
          }
        },
      ),
    );
  }
}
