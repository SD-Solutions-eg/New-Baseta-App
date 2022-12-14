import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final formFieldKey = GlobalKey<FormState>();

  late final InformationCubit infoCubit;
  bool _isInit = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      infoCubit = InformationCubit.get(context);
      infoCubit.getCompanyReviews();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Reviews"),
        actions: [
          BlocConsumer<InformationCubit, InformationState>(
            listener: (context, state) {
              if (state is CreateChatSuccess) {
                infoCubit.getCompanyReviews();
                final reviewModel = infoCubit.companyReviews!;
                log('Review Model: $reviewModel');

                setState(() => isLoading = false);
                Navigator.pop(context);
              } else if (state is CreateChatFailed) {
                setState(() => isLoading = false);
                customSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) => buildAddReviewButton(state),
          ),
          SizedBox(width: hSmallPadding),
        ],
      ),
      body: BlocBuilder<InformationCubit, InformationState>(
        builder: (context, state) {
          if (state is! GetCompanyReviewsLoading) {
            final companyReview = infoCubit.companyReviews;
            if (companyReview != null && companyReview.replies.isNotEmpty) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: hMediumPadding, vertical: vSmallPadding),
                itemBuilder: (context, index) {
                  final review = companyReview.replies[index];
                  return ListTile(
                    title: Text(review.authorName),
                    subtitle: Text(
                      Bidi.stripHtmlIfNeeded(review.content).trim(),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: vSmallPadding),
                itemCount: companyReview.replies.length,
              );
            } else {
              return const EmptyScreenView();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildAddReviewButton(InformationState state) {
    return IconButton(
      onPressed: () => openReviewModalSheet(state),
      icon: Icon(
        Icons.rate_review_outlined,
        size: 24.w,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void openReviewModalSheet(InformationState state) {
    final reviewCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

        return Container(
          height: bottomInsets + 0.3.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: hMediumPadding, vertical: vMediumPadding),
          child: Column(
            children: [
              Text(
                CategoryCubit.appText!.addReview,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: vMediumPadding),
              Form(
                key: formFieldKey,
                child: FilledTextFieldWithLabel(
                  controller: reviewCtrl,
                  labelText: CategoryCubit.appText!.review,
                  hintText: CategoryCubit.appText!.review,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return CategoryCubit.appText!.filedIsRequired;
                    }
                    return null;
                  },
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              DefaultButton(
                text: CategoryCubit.appText!.addReview,
                isLoading: isLoading || state is CreateChatLoading,
                onPressed: () async {
                  setState(() => isLoading = true);
                  if (formFieldKey.currentState != null &&
                      formFieldKey.currentState!.validate()) {
                    ChatModel reviewModel = infoCubit.companyReviews!;
                    final newReply = ReplyModel.create(
                      author: FirebaseAuthBloc.currentUser!.id,
                      authorName: FirebaseAuthBloc.currentUser!.username,
                      content: reviewCtrl.text.trim(),
                      date: DateTime.now().toString(),
                    );
                    reviewModel = reviewModel.copyWith(
                      replies: [
                        newReply,
                        ...reviewModel.replies,
                      ],
                    );
                    await infoCubit.sendChatMessage(newReply.toMap(131));
                  }
                },
              ),
              const Spacer(),
              SizedBox(height: bottomInsets),
            ],
          ),
        );
      },
    );
  }
}
