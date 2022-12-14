import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/faq_category_model.dart';
import 'package:allin1/data/models/faq_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';

class SupportMobile extends StatefulWidget {
  @override
  _SupportMobileState createState() => _SupportMobileState();
}

class _SupportMobileState extends State<SupportMobile> {
  late final List<FAQModel> allFAQs;
  List<FAQModel> _filteredQuestions = [];
  List<FAQCategoryModel> faqCategories = [];
  late final List<Map<String, String>> questionsCategoriesMaps;
  bool _isInit = false;
  int _selectedFilter = 0;

  Future<void> getAllFAQs() async {
    final isArabic = Languages.of(context) is LanguageAr;
    final infoCubit = InformationCubit.get(context);
    await infoCubit.getFAQs();
    allFAQs = infoCubit.faqs;
    faqCategories = infoCubit.faqCategories;
    faqCategories.insert(
        0, FAQCategoryModel(id: -1, name: isArabic ? 'الكل' : 'All'));
    _filteredQuestions = [...allFAQs];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      getAllFAQs();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
            vertical: ScreenUtil().screenWidth > 600
                ? vMediumPadding
                : vSmallPadding * 1.5,
          ),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50.w,
              height: 50.w,
              padding: EdgeInsets.all(hSmallPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(verySmallRadius),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Icon(
                Icons.arrow_back_outlined,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        leadingWidth: ScreenUtil().screenWidth > 600 ? 100 : 80.w,
        titleSpacing: 0,
        toolbarHeight: ScreenUtil().screenWidth > 600 ? 80 : 70.w,
        title: Text(
          CategoryCubit.appText!.support,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: supportAppBarColor,
        // actions: [
        //   IconButton(
        //     onPressed: () {

        //     },
        //     icon: const Icon(ETagerIcons.share_alt),
        //   ),
        //   SizedBox(width: hSmallPadding),
        // ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<InformationCubit, InformationState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hSmallPadding,
                vertical: vMediumPadding,
              ),
              child: Column(
                children: [
                  buildSearchContainer(),
                  SizedBox(height: vMediumPadding),
                  Text(
                    CategoryCubit.appText!.fAQ,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: vMediumPadding),
                  SizedBox(
                    height: 35.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: faqCategories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: hSmallPadding),
                          child: buildChip(
                            onTap: () {
                              if (index == 0) {
                                setState(() {
                                  _selectedFilter = index;
                                  _filteredQuestions = [...allFAQs];
                                });
                              } else {
                                setState(() {
                                  _selectedFilter = index;
                                  _filteredQuestions.clear();
                                  for (final faq in allFAQs) {
                                    if (faq.categoriesId
                                        .contains(faqCategories[index].id)) {
                                      _filteredQuestions.add(faq);
                                    }
                                  }
                                });
                              }
                            },
                            label: faqCategories[index].name,
                            backgroundColor: _selectedFilter == index
                                ? Theme.of(context).colorScheme.secondary
                                : lightGrey,
                            labelColor: _selectedFilter == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: vSmallPadding),
                  if (state is! FAQsLoading)
                    ...List.generate(_filteredQuestions.length, (index) {
                      return CustomExpansionTile(
                        index: index + 1,
                        question: _filteredQuestions[index].question,
                        answer: _filteredQuestions[index].answer,
                      );
                    })
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildChip({
    required VoidCallback onTap,
    required String label,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(largeRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(largeRadius),
        onTap: onTap,
        child: Container(
          height: 15.h,
          width: 45.w + (7.0.w * label.length),
          padding: EdgeInsets.symmetric(horizontal: hSmallPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(largeRadius),
            color: backgroundColor,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: labelColor),
          ),
        ),
      ),
    );
  }

  Container buildSearchContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
        vertical: vMediumPadding,
      ),
      margin: EdgeInsets.symmetric(horizontal: hSmallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(mediumRadius),
      ),
      child: Column(
        children: [
          Text(
            CategoryCubit.appText!.needHelp,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: vMediumPadding),
          FilledTextFieldWithLabel(
            onChange: (value) {
              if (value.isNotEmpty) {
                _filteredQuestions.clear();
                for (final faq in allFAQs) {
                  if (faq.question
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()) ||
                      faq.answer
                          .toLowerCase()
                          .contains(value.trim().toLowerCase())) {
                    _filteredQuestions.add(faq);
                  }
                }
                setState(() {});
              } else {
                _filteredQuestions = [...allFAQs];
                setState(() {});
              }
            },
            hintText: CategoryCubit.appText!.searchInFAQ,
            hintSize: 14.sp,
            prefixIcon: Icon(
              ETagerIcons.search,
              size: 16.w,
            ),
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final String question;
  final String answer;
  final int index;

  const CustomExpansionTile({
    Key? key,
    required this.question,
    required this.answer,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
        vertical: vVerySmallPadding,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: hSmallPadding,
        vertical: vVerySmallPadding * 1.5,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkWhite : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(smallRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade300,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          textColor: isDark ? Colors.white : Colors.black,
          title: Row(
            children: [
              Material(
                elevation: 2,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: LimitedBox(
                    child: Text(
                      index.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: hMediumPadding),
              Expanded(
                  child: Text(
                question,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      height: 1.3,
                    ),
              )),
            ],
          ),
          children: [
            Divider(
              indent: 2,
              endIndent: 2,
              thickness: 0.2,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade900,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: vSmallPadding),
              child: Text(
                answer.trim(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
