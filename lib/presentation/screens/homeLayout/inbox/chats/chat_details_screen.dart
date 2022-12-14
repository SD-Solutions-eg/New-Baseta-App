import 'dart:async';
import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/components/chat_bottom_nav_bar.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/components/image_message.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/components/message_bubble.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/components/voice_message_view.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:iconly/iconly.dart';

class ChatDetailsScreen extends StatefulWidget {
  final ChatModel chatModel;
  const ChatDetailsScreen({
    Key? key,
    required this.chatModel,
  }) : super(key: key);
  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  late final InformationCubit infoCubit;
  late final ChatModel chatModel;
  bool _isInit = false;
  final messageCtrl = TextEditingController();
  int pageNumber = 2;

  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      infoCubit = InformationCubit.get(context);
      chatModel = widget.chatModel;
      infoCubit.getMoreMessages(
          chatId: chatModel.id, firstCall: true, pageNumber: 1);
      startTimer();
      _isInit = true;
    }
  }

  Future<void> startTimer() async {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    timer = Timer.periodic(
        Duration(seconds: CategoryCubit.appDurations.updateChatDuration),
        (timer) async {
      await infoCubit.getMoreMessages(
          chatId: chatModel.id, pageNumber: 1, firstCall: true, perPage: 20);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        infoCubit.getAllChats(refresh: true);
        await Future.delayed(const Duration(milliseconds: 200));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(chatModel.title),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 2,
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/chat_background.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            BlocBuilder<InformationCubit, InformationState>(
              builder: (context, state) {
                final chatModel = InformationCubit.createdChatModel!;
                if (chatModel.replies.isNotEmpty) {
                  log(chatModel.replies.length.toString());
                  return Padding(
                    padding: EdgeInsets.only(bottom: vVeryLargeMargin * 1.1),
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: chatModel.replies.length < 15,
                      padding: EdgeInsets.symmetric(
                          horizontal: hSmallPadding, vertical: vSmallPadding),
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatModel.replies.length,
                      itemBuilder: (context, index) {
                        final chatPages = infoCubit.chatPages;
                        final reply = chatModel.replies[index];
                        if (index == (chatModel.replies.length - 1) &&
                            chatModel.replies.length >= 10 &&
                            pageNumber <= chatPages &&
                            state is! GetMoreMessagesLoading) {
                          infoCubit.getMoreMessages(
                              chatId: chatModel.id, pageNumber: pageNumber);
                          pageNumber++;
                        }
                        return Column(
                          children: [
                            if (state is GetMoreMessagesLoading &&
                                index == (chatModel.replies.length - 1))
                              const SizedBox(),
                            if ((reply.image != null &&
                                    reply.image!.isNotEmpty) ||
                                reply.content == 'iMaGe meSSaGe...')
                              ImageMessage(
                                message: reply,
                              )
                            else if (reply.voice != null &&
                                reply.voice!.isNotEmpty)
                              VoiceMessageView(
                                voiceMessage: reply,
                              )
                            else
                              MessageBubble(
                                message: reply,
                              ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return EmptyScreenView(
                    subtitle: CategoryCubit.appText!.sendYourFirstMsg,
                    icon: IconlyBold.send,
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ChatBottomNavBar(
          messageCtrl: messageCtrl,
          infoCubit: infoCubit,
        ),
      ),
    );
  }
}
