import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';

class FilterDrawerMobile extends StatefulWidget {
  const FilterDrawerMobile({
    Key? key,
    this.isFilterScreen = false,
  }) : super(key: key);
  final bool isFilterScreen;

  @override
  State<FilterDrawerMobile> createState() => _FilterDrawerMobileState();
}

class _FilterDrawerMobileState extends State<FilterDrawerMobile>
    with AutomaticKeepAliveClientMixin {
  int selectedSection = -1;
  int selectedSize = -1;
  int selectedColor = -1;
  bool isLoading = false;
  late final CategoryCubit categoryCubit;

  @override
  void initState() {
    super.initState();
    categoryCubit = CategoryCubit.get(context);
    categoryCubit.clearFilter();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: 0.85.sw,
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.horizontal(
            end: Radius.circular(mediumRadius),
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hMediumPadding,
                vertical: vMediumPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeadline(title: CategoryCubit.appText!.filterBy),
                  SizedBox(height: vVeryLargePadding),
                  SmallHeadline(title: CategoryCubit.appText!.byCategory),
                  SizedBox(height: vMediumPadding),
                  buildCategoryView(),
                  Divider(
                    height: vVeryLargeMargin,
                    thickness: 1,
                  ),
                  SizedBox(height: vVeryLargeMargin),
                  DefaultButton(
                    width: 0.45.sw,
                    height: 55.h,
                    isLoading: isLoading,
                    text: CategoryCubit.appText!.applyFilter,
                    onPressed: applyFilter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildPartnerView() {
  //   return BlocBuilder<CategoryCubit, CategoryState>(
  //     builder: (context, state) {
  //       final categoryCubit = CategoryCubit.get(context);

  //       return Wrap(
  //         runSpacing: vSmallPadding,
  //         spacing: hSmallPadding,
  //         children: List.generate(
  //           categoryCubit.allPartners.length,
  //           (index) {
  //             final category = categoryCubit.allPartners[index];
  //             return OutlineContainer(
  //               title: category.firstName,
  //               isSelected: selectedCategory == index,
  //               onSelected: () => setState(() => selectedCategory = index),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget buildCategoryView() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categoryCubit = CategoryCubit.get(context);

        return Wrap(
          runSpacing: vSmallPadding,
          spacing: hSmallPadding,
          children: List.generate(
            categoryCubit.allSections.length,
            (index) {
              final category = categoryCubit.allSections[index];
              return OutlineContainer(
                title: category.title,
                isSelected: selectedSection == index,
                onSelected: () => setState(() => selectedSection = index),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> applyFilter() async {
    setState(() => isLoading = true);

    SectionModel? sectionModel;

    if (selectedSection != -1) {
      sectionModel = CategoryCubit.get(context).allSections[selectedSection];
    }
    sectionModel = sectionModel;

    // setState(() => isLoading = false);
    if (widget.isFilterScreen) {
      Navigator.of(context)
        ..pop()
        ..pushReplacementNamed(
          AppRouter.section,
          arguments: sectionModel,
        );
    } else {
      Navigator.of(context)
        ..pop()
        ..pushNamed(AppRouter.section, arguments: sectionModel);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class OutlineContainer extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool square;
  final VoidCallback onSelected;
  const OutlineContainer({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onSelected,
    this.square = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(smallRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: square ? hSmallPadding * 1.4.w : hMediumPadding,
          vertical: vSmallPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.25),
          ),
          borderRadius: BorderRadius.circular(verySmallRadius),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: isSelected ? Colors.white : null,
                fontSize: square ? 16.sp : null,
                fontWeight: square ? FontWeight.w500 : null,
                fontFamily: square ? 'Roboto' : null,
              ),
        ),
      ),
    );
  }
}
