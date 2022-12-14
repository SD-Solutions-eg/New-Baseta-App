import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/core/utilities/debouncer.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/loadingViewsClasses/loading_views.dart';
import 'package:allin1/presentation/widgets/partner_card.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:iconly/iconly.dart';

class SectionMobile extends StatefulWidget {
  final SectionModel section;
  const SectionMobile({
    Key? key,
    required this.section,
  }) : super(key: key);

  @override
  _SectionMobileState createState() => _SectionMobileState();
}

class _SectionMobileState extends State<SectionMobile> {
  late final CategoryCubit categoryCubit;
  int partnersPageNumber = 1;
  bool _isInit = false;
  final _searchCtrl = TextEditingController();
  final debouncer = Debounces();
  String searchValue = '';
  int pageNumber = 1;
  int pages = 1;
  int pageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      categoryCubit = CategoryCubit.get(context);
      categoryCubit.getPartnersBySection(widget.section.id);
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.section.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final partners = categoryCubit.allPartners;

          if (state is! GetAllPartnersLoading) {
            // final pages = categoryCubit.pages;
            // final total = _productsCubit.productsTotal;
            // final previousProductsCount =
            //     _productsCubit.pageIndex * _productsCubit.perPage;
            if (partners.isNotEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
                    child: buildSearchBar(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: partners.length,
                      padding: EdgeInsets.symmetric(
                          vertical: vMediumPadding, horizontal: hMediumPadding),
                      itemBuilder: (context, index) {
                        // if (index == partners.length - 1 &&
                        //     state is! MoreProductsLoading &&
                        //     pages > partnersPageNumber) {
                        //   partnersPageNumber++;
                        //   _productsCubit.loadMoreCategoryProducts(
                        //       context, widget.id, partnersPageNumber);
                        // }
                        return Column(
                          children: [
                            PartnerCard(
                                section: widget.section,
                                partner: partners[index]),
                            if (index == partners.length - 1 &&
                                state is MoreProductsLoading) ...[
                              SizedBox(height: vMediumPadding),
                              SizedBox(
                                width: 15.w,
                                height: 15.w,
                                child: const CircularProgressIndicator(
                                  color: iconGreyColor,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const EmptyScreenView();
            }
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 800
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vMediumPadding,
              ),
              child: const ShimmerLoading(),
            );
          }
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return FilledTextFieldWithLabel(
      hintText: CategoryCubit.appText!.search,
      height: 45.w,
      readOnly: true,
      onTap: () {
        Navigator.pushNamed(context, AppRouter.search);
        // Navigator.pop(context);
      },
      prefixIcon: Icon(
        IconlyLight.search,
        size: 20.w,
      ),
    );
  }
}
