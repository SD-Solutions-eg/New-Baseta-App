import 'dart:developer';
import 'dart:math' show min;

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/core/utilities/debouncer.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/loadingViewsClasses/loading_views.dart';
import 'package:allin1/presentation/widgets/partner_card.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';

class SearchMobile extends StatefulWidget {
  @override
  _SearchMobileState createState() => _SearchMobileState();
}

class _SearchMobileState extends State<SearchMobile> {
  final _searchCtrl = TextEditingController();
  late final ProductsCubit _productsCubit;
  bool _isInit = false;
  int pageNumber = 1;
  int pages = 1;
  int pageIndex = 0;
  String searchValue = '';
  final debouncer = Debounces();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      _productsCubit = ProductsCubit.get(context);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.w,
        // title: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
        //   child: Text(
        //     CategoryCubit.appText!.search,
        //     style: Theme.of(context).textTheme.headline3!.copyWith(
        //           fontWeight: FontWeight.bold,
        //         ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: hMediumPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(verySmallRadius),
                color: authBackgroundColor,
              ),
              child: Row(
                children: [
                  buildSearchBar(),
                ],
              ),
            ),
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is! SearchPartnersLoading) {
                  final searchPartners = _productsCubit.searchPartners;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().screenWidth > 800
                          ? hLargePadding
                          : hMediumPadding,
                      vertical: vMediumPadding,
                    ),
                    child: searchPartners.isNotEmpty
                        ? Column(
                            children: [
                              ...List.generate(
                                searchPartners.length,
                                (index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: vSmallPadding),
                                  child: PartnerCard(
                                    section: searchPartners[index].section!,
                                    partner: searchPartners[index],
                                  ),
                                ),
                              ),
                              SizedBox(height: vMediumPadding),
                              if (pages > 1)
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (pageIndex > 1) buildFirstPageButton(),
                                      ...buildPagesButtonsNumber(),
                                      if (pageIndex < pages - 2)
                                        buildLastPageButton(isDark: isDark),
                                    ],
                                  ),
                                ),
                              SizedBox(height: vLargePadding),
                            ],
                          )
                        : Center(
                            child: Column(
                              children: [
                                SizedBox(height: vVeryLargeMargin),
                                SvgPicture.asset(
                                  'assets/images/Search-bro.svg',
                                  width: 150.w,
                                  height: 150.w,
                                ),
                                SizedBox(height: vLargePadding),
                                Text(
                                  CategoryCubit.appText!.emptySearchHistory,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                  );
                } else {
                  return Container(
                    height: 0.9.sh,
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
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Expanded(
      child: FilledTextFieldWithLabel(
        height: 50.w,
        hintText: CategoryCubit.appText!.search,
        controller: _searchCtrl,
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        filled: true,
        prefixIcon: Icon(
          IconlyLight.search,
          size: 22.w,
          color: Theme.of(context).colorScheme.primary,
        ),
        inputAction: TextInputAction.search,
        onChange: (value) async {
          if (_searchCtrl.text.isNotEmpty && _searchCtrl.text != searchValue) {
            debouncer.run(() async {
              log('Send Search text');
              searchValue = _searchCtrl.text;
              final pageHeaderModel = await _productsCubit
                  .searchForPartners(context, name: _searchCtrl.text.trim());
              if (pageHeaderModel != null) {
                pages = pageHeaderModel.pages;
              }
            });
          }
        },
      ),
    );
  }

  InkWell buildFirstPageButton() {
    return InkWell(
      onTap: () async {
        pageNumber = 1;
        final pageHeaderModel = await _productsCubit.searchForPartners(
          context,
          page: pageNumber,
          name: searchValue,
        );
        if (pageHeaderModel != null) {
          pages = pageHeaderModel.pages;
        }

        setState(() => pageIndex = 0);
      },
      child: Container(
        height: 45.h,
        width: 50.w,
        padding: EdgeInsets.symmetric(
          horizontal: hVerySmallMargin,
          vertical: vSmallPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).highlightColor,
            width: 0.5,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: const Center(
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }

  List<Widget> buildPagesButtonsNumber() {
    return List.generate(
      min(5, pages),
      (index) {
        late final int updatedIndex;
        if (pages > 5 && pageIndex > 2 && pageIndex + 2 <= pages - 1) {
          updatedIndex = pageIndex - 2 + index;
        } else if (pages <= 5) {
          updatedIndex = index;
        } else if (pageIndex + 1 >= pages) {
          updatedIndex = pageIndex - 4 + index;
        } else if (pageIndex + 2 >= pages) {
          updatedIndex = pageIndex - 3 + index;
        } else {
          updatedIndex = index;
        }
        return InkWell(
          onTap: () async {
            if (pageIndex == updatedIndex) {
              return;
            }
            pageNumber = updatedIndex + 1;
            final pagesHeaderModel = await _productsCubit.searchForPartners(
              context,
              name: searchValue,
              page: pageNumber,
            );
            if (pagesHeaderModel != null) {
              pages = pagesHeaderModel.pages;
            }
            setState(() => pageIndex = updatedIndex);
          },
          child: Container(
            height: 45.h,
            width: 50.w,
            padding: EdgeInsets.symmetric(
              horizontal: hVerySmallMargin,
              vertical: vSmallPadding,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).highlightColor,
                width: 0.5,
              ),
              color: pageIndex == updatedIndex
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: Text(
                '${updatedIndex + 1}',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(),
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell buildLastPageButton({required bool isDark}) {
    return InkWell(
      onTap: () async {
        pageNumber = pages;
        final pageHeaderModel = await _productsCubit.searchForPartners(
          context,
          name: searchValue,
          page: pageNumber,
        );
        if (pageHeaderModel != null) {
          pages = pageHeaderModel.pages;
        }
        setState(() => pageIndex = pages - 1);
      },
      child: Container(
        height: 45.h,
        width: 50.w,
        padding: EdgeInsets.symmetric(
          horizontal: hVerySmallMargin,
          vertical: vSmallPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).highlightColor,
            width: 0.5,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward_rounded,
            color: isDark ? lightWhite : darkWhite,
          ),
        ),
      ),
    );
  }
}
