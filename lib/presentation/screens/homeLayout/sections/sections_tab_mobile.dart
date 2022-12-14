import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/category_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/loading_image_container.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SectionsTabMobile extends StatefulWidget {
  const SectionsTabMobile({Key? key}) : super(key: key);

  @override
  State<SectionsTabMobile> createState() => _SectionsTabMobileState();
}

class _SectionsTabMobileState extends State<SectionsTabMobile> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      CategoryCubit.get(context).getAllSections();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.orderNow),
        titleSpacing: hMediumPadding,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen: (previous, current) {
          if (previous is GetSectionsLoading ||
              current is GetSectionsLoading ||
              current is GetSectionsSuccess) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          final categoryCubit = CategoryCubit.get(context);

          if (state is! GetSectionsLoading &&
              categoryCubit.allSections.isNotEmpty) {
            final allSections = categoryCubit.allSections;

            return GridView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: hSmallPadding, vertical: vMediumPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil().screenWidth > 800 ? 3 : 2,
                childAspectRatio: 4.4 / 5,
                crossAxisSpacing: hVerySmallPadding,
                mainAxisSpacing: vSmallPadding,
              ),
              itemCount: allSections.length,
              itemBuilder: (context, index) {
                final section = allSections[index];
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRouter.section,
                      arguments: section),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(smallRadius),
                        child: CachedNetworkImage(
                          imageUrl: section.fullImage,
                          placeholder: (context, url) => LoadingImageContainer(
                            width: ScreenUtil().screenWidth > 800
                                ? 0.3.sw
                                : 0.45.sw,
                            height: ScreenUtil().screenWidth > 800
                                ? 0.3.sw
                                : 0.45.sw,
                          ),
                          errorWidget: (context, url, error) =>
                              LoadingImageContainer(
                            width: ScreenUtil().screenWidth > 800
                                ? 0.3.sw
                                : 0.45.sw,
                            height: ScreenUtil().screenWidth > 800
                                ? 0.3.sw
                                : 0.45.sw,
                          ),
                          width:
                              ScreenUtil().screenWidth > 800 ? 0.3.sw : 0.45.sw,
                          height:
                              ScreenUtil().screenWidth > 800 ? 0.3.sw : 0.45.sw,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: vSmallPadding),
                      Text(
                        section.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: hSmallPadding, vertical: vMediumPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil().screenWidth > 800 ? 3 : 2,
                childAspectRatio: 4.4 / 5,
                crossAxisSpacing: hVerySmallPadding,
                mainAxisSpacing: vSmallPadding,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(smallRadius),
                      child: LoadingImageContainer(
                        width:
                            ScreenUtil().screenWidth > 800 ? 0.3.sw : 0.45.sw,
                        height:
                            ScreenUtil().screenWidth > 800 ? 0.3.sw : 0.45.sw,
                      ),
                    ),
                    SizedBox(height: vVerySmallPadding),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CategoriesLoadingView extends StatelessWidget {
  const CategoriesLoadingView({
    Key? key,
    required this.mainCategories,
  }) : super(key: key);
  final List<CategoryModel>? mainCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        mainCategories != null ? mainCategories!.length : 3,
        (index) {
          final categoryTitle =
              mainCategories != null ? mainCategories![index].name : '';
          return Column(
            children: [
              SizedBox(height: vMediumPadding),
              CategoryLoadingItem(
                category: categoryTitle,
                subcategory: '',
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryLoadingItem extends StatelessWidget {
  const CategoryLoadingItem({
    Key? key,
    required this.category,
    required this.subcategory,
  }) : super(key: key);
  final String category;
  final String subcategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80.h,
          padding: EdgeInsets.symmetric(
            horizontal:
                ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
          ),
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(smallRadius),
            color: authBackgroundColor,
          ),
          child: MainHeadline(title: category),
        ),
        SizedBox(height: vSmallPadding),
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: hVerySmallPadding),
                    child: LoadingImageContainer(
                      width: double.infinity,
                      height: 90.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: vMediumPadding),
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: hVerySmallPadding),
                    child: LoadingImageContainer(
                      width: double.infinity,
                      height: 90.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
