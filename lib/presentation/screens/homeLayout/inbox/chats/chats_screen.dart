import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;
import 'package:random_color/random_color.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final formFieldKey = GlobalKey<FormState>();
  late final InformationCubit infoCubit;
  final _randomColor = RandomColor();
  List<Color> lightColorsList = [];
  List<Color> darkColorsList = [];
  bool isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      infoCubit = InformationCubit.get(context);
      if (InformationCubit.allChats.isEmpty) {
        infoCubit.getAllChats();
      }
      lightColorsList = [
        ...List.generate(
            50,
            (index) => _randomColor
                .randomColor(colorBrightness: ColorBrightness.light)
                .withOpacity(0.4))
      ];
      darkColorsList = [
        ...List.generate(
            50,
            (index) =>
                _randomColor.randomColor(colorBrightness: ColorBrightness.dark))
      ];
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isAr = Languages.of(context) is LanguageAr;
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Scaffold(
          body: BlocBuilder<InformationCubit, InformationState>(
            builder: (context, state) {
              if (state is! GetAllChatsLoading) {
                final chats = InformationCubit.allChats;
                if (chats.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () {
                      infoCubit.getAllChats(refresh: true);
                      return Future.delayed(const Duration(milliseconds: 200));
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: vSmallPadding),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final date = intl.DateFormat(
                                isAr ? 'd MMM' : 'MMM d', isAr ? 'ar' : 'en')
                            .format(DateTime.parse(chat.date));
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: lightColorsList[index],
                            child: Text(
                              chat.title.split('').first.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.headline4!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: darkColorsList[index],
                                        fontFamily: 'Roboto',
                                      ),
                            ),
                          ),
                          title: Text(chat.title),
                          subtitle: chat.replies.isNotEmpty
                              ? Text(
                                  intl.Bidi.stripHtmlIfNeeded(
                                          chat.replies.first.content)
                                      .trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: Column(
                            children: [
                              SizedBox(height: vSmallPadding),
                              Text(
                                date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            InformationCubit.createdChatModel = chat;
                            Navigator.pushNamed(
                              context,
                              AppRouter.chatDetails,
                              arguments: chat,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 1,
                        color: authBackgroundColor,
                      ),
                      itemCount: chats.length,
                    ),
                  );
                } else {
                  return const EmptyScreenView(
                    icon: IconlyLight.chat,
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton:
              BlocConsumer<InformationCubit, InformationState>(
            listener: (context, state) {
              if (state is CreateChatSuccess) {
                final chatModel = InformationCubit.createdChatModel;
                infoCubit.getAllChats();
                if (chatModel != null) {
                  Navigator.pushNamed(context, AppRouter.chatDetails,
                      arguments: chatModel);
                }
              } else if (state is CreateChatFailed) {
                customSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) {
              return FloatingActionButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  if (FirebaseAuthBloc.currentUser != null) {
                    openChatModalSheet(state);
                  } else {
                    customSnackBar(
                        context: context,
                        message: CategoryCubit.appText!.needToLoginFirst);
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRouter.authScreen, (route) => false);
                    tabController = null;
                  }
                },
                mini: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  IconlyLight.chat,
                  size: 24.w,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void openChatModalSheet(InformationState state) {
    final subjectCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

        return StatefulBuilder(builder: (context, sheetSetState) {
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
                // Text(
                //   CategoryCubit.appText!.startChat,
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                SizedBox(height: vMediumPadding),
                Form(
                  key: formFieldKey,
                  child: FilledTextFieldWithLabel(
                    controller: subjectCtrl,
                    labelText: CategoryCubit.appText!.subject,
                    hintText: CategoryCubit.appText!.subject,
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
                  text: CategoryCubit.appText!.startChat,
                  isLoading: isLoading || state is CreateChatLoading,
                  onPressed: () async {
                    sheetSetState(() => isLoading = true);
                    if (formFieldKey.currentState != null &&
                        formFieldKey.currentState!.validate()) {
                      final chatMap =
                          ChatModel.createChat(title: subjectCtrl.text).toMap();
                      log('Chat Map: $chatMap');
                      await infoCubit.createChat(chatMap);
                      Navigator.pop(context);
                    }
                    sheetSetState(() => isLoading = false);
                  },
                ),
                const Spacer(),
                SizedBox(height: bottomInsets),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
