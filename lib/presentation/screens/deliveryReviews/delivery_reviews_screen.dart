// ignore_for_file: unused_element

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/rating_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/rating_bar.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

class DeliveryReviewsScreen extends StatefulWidget {
  const DeliveryReviewsScreen({Key? key}) : super(key: key);
  @override
  _DeliveryReviewsScreenState createState() => _DeliveryReviewsScreenState();
}

class _DeliveryReviewsScreenState extends State<DeliveryReviewsScreen> {
  final formFieldKey = GlobalKey<FormState>();
  late final CategoryCubit categoryCubit;
  final reviewCtrl = TextEditingController();
  double yourRating = 0;
  late final bool isSupervisor;

  late final InformationCubit infoCubit;
  bool _isInit = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      infoCubit = InformationCubit.get(context);
      categoryCubit = CategoryCubit.get(context);

      _isInit = true;
    }
  }

  @override
  void dispose() {
    reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Reviews"),
      ),
      body: BlocBuilder<InformationCubit, InformationState>(
        builder: (context, state) {
          if (state is! GetDeliveryReviewsLoading) {
            final captainOrSupervisorReviews = infoCubit.deliveryReviews;
            if (captainOrSupervisorReviews.isNotEmpty) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: hMediumPadding, vertical: vSmallPadding),
                itemBuilder: (context, index) {
                  final review = captainOrSupervisorReviews[index];
                  return Column(
                    children: [
                      if (index == 0) buildAddReviewView(state),
                      if (index == 0)
                        Divider(
                          color: iconGreyColor,
                          thickness: 0.5,
                          height: vVeryLargePadding,
                        ),
                      SizedBox(height: vMediumPadding),
                      DottedBorder(
                        padding: EdgeInsets.symmetric(
                            horizontal: hSmallPadding, vertical: vSmallPadding),
                        color: iconGreyColor,
                        child: ListTile(
                          title: Text(review.review.trim()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: vSmallPadding),
                              ProductRatingBar(
                                initialRating: review.rating.toDouble(),
                              ),
                              SizedBox(height: vSmallPadding),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(review.date),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: vSmallPadding),
                itemCount: captainOrSupervisorReviews.length,
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hMediumPadding, vertical: vMediumPadding),
                child: buildAddReviewView(state),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Column buildAddReviewView(InformationState state) {
    return Column(
      children: [
        Text(
          ' ',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: vSmallPadding),
        Form(
          key: formFieldKey,
          child: FilledTextFieldWithLabel(
            controller: reviewCtrl,
            labelText: CategoryCubit.appText!.review,
            hintText: CategoryCubit.appText!.yourReview,
            inputAction: TextInputAction.done,
            maxLines: 3,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return CategoryCubit.appText!.filedIsRequired;
              }
              return null;
            },
          ),
        ),
        SizedBox(height: vMediumPadding),
        Row(
          children: [
            Text(CategoryCubit.appText!.yourRating),
            SizedBox(width: hSmallPadding),
            ProductRatingBar(
              initialRating: yourRating,
              readOnly: false,
              onRating: (rating) => setState(() => yourRating = rating),
            ),
          ],
        ),
        SizedBox(height: vLargePadding),
        Row(
          children: [
            DefaultButton(
              text: CategoryCubit.appText!.addReview,
              width: 140.w,
              height: 40.h,
              isLoading: state is RatingDeliveryLoading,
              onPressed: () async {
                //TODO:
              },
            ),
          ],
        ),
        SizedBox(height: vMediumPadding),
      ],
    );
  }

  Future<void> _addReview(int captainOrSupervisorId,
      {bool isSupervisor = false}) async {
    FocusScope.of(context).unfocus();
    if (formFieldKey.currentState != null &&
        formFieldKey.currentState!.validate()) {
      if (yourRating == 0) {
        customSnackBar(
            context: context,
            message: CategoryCubit.appText!.pleaseSelectYourRating);
      } else {
        final newReview = RatingModel.upload(
          review: reviewCtrl.text.trim(),
          captainId: captainOrSupervisorId,
          rating: yourRating.toInt(),
        );
        await infoCubit.createRating(newReview.toMap(),
            isSupervisor: isSupervisor);

        if (mounted) {
          reviewCtrl.clear();
          setState(() => yourRating = 0);
        }
      }
    }
  }
}
