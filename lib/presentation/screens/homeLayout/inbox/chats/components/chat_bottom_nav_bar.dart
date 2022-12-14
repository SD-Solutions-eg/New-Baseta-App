import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/customer/customer_cubit.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBottomNavBar extends StatefulWidget {
  final InformationCubit infoCubit;

  const ChatBottomNavBar({
    Key? key,
    required this.infoCubit,
    required this.messageCtrl,
  }) : super(key: key);

  final TextEditingController messageCtrl;

  @override
  State<ChatBottomNavBar> createState() => _ChatBottomNavBarState();
}

class _ChatBottomNavBarState extends State<ChatBottomNavBar> {
  String statusText = "";
  bool isComplete = false;
  String recordFilePath = '';
  int i = 0;
  File? _pickedFile;
  bool uploadingImage = false;
  bool uploadingVoice = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: authBackgroundColor,
          blurRadius: 1,
          spreadRadius: 1,
          offset: Offset(0, -3),
        ),
      ]),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(hVerySmallPadding).copyWith(right: 0),
            child: InkWell(
              onTap: chooseImage,
              borderRadius: BorderRadius.circular(25),
              splashColor: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: EdgeInsets.all(hSmallPadding),
                child: uploadingImage
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 3.w,
                        )),
                      )
                    : Icon(
                        IconlyLight.image,
                        size: 24.w,
                        color: Theme.of(context).iconTheme.color,
                      ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: hSmallPadding),
              child: TextField(
                controller: widget.messageCtrl,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: CategoryCubit.appText!.typeMessage,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: hVerySmallPadding,
                      vertical: vVerySmallPadding),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(hVerySmallPadding).copyWith(left: 0),
          //   child: InkWell(
          //     onTap: () async {
          //       if (statusText == 'Recording') {
          //         stopRecord();
          //       } else {
          //         await startRecording();
          //       }
          //     },
          //     borderRadius: BorderRadius.circular(25),
          //     splashColor: Theme.of(context).colorScheme.secondary,
          //     child: statusText == 'Recording'
          //         ? LottieBuilder.asset(
          //             'assets/animations/mic_record.json',
          //             width: 45.w,
          //             height: 40.w,
          //             fit: BoxFit.cover,
          //             repeat: true,
          //           )
          //         : Padding(
          //             padding: EdgeInsets.all(hSmallPadding),
          //             child: uploadingVoice
          //                 ? SizedBox(
          //                     width: 22.w,
          //                     height: 22.w,
          //                     child: Center(
          //                         child: CircularProgressIndicator(
          //                       strokeWidth: 3.w,
          //                     )),
          //                   )
          //                 : Icon(
          //                     FontAwesomeIconsLight.microphone,
          //                     size: 24.w,
          //                     color: statusText == 'Recording'
          //                         ? Colors.red
          //                         : Theme.of(context).iconTheme.color,
          //                   ),
          //           ),
          //   ),
          // ),
          Padding(
            // padding: EdgeInsets.all(hVerySmallPadding).copyWith(left: 0),
            padding: EdgeInsetsDirectional.fromSTEB(
                0, hVerySmallPadding, hVerySmallPadding, hVerySmallPadding),
            child: InkWell(
              onTap: sendChatMessage,
              borderRadius: BorderRadius.circular(25),
              splashColor: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: EdgeInsets.all(hSmallPadding),
                child: Transform(
                  transform: isArabic
                      ? Matrix4.rotationY(math.pi)
                      : Matrix4.rotationY(0),
                  alignment: Alignment.center,
                  child: Icon(
                    IconlyLight.send,
                    size: 26.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendChatMessage() async {
    if (widget.messageCtrl.text.isEmpty) {
      return;
    }
    ChatModel chatModel = InformationCubit.createdChatModel!;
    final newReply = ReplyModel.create(
      author: FirebaseAuthBloc.currentUser!.id,
      authorName: FirebaseAuthBloc.currentUser!.username,
      content: widget.messageCtrl.text.trim(),
      date: DateTime.now().toString(),
    );
    widget.messageCtrl.clear();
    // log('Chat :  ${chatModel.replies}');

    chatModel = chatModel.copyWith(
      replies: [
        newReply,
        ...chatModel.replies,
      ],
    );
    // log('------------------------------');
    // log('New Chat :  ${chatModel.replies}');

    InformationCubit.createdChatModel = chatModel;
    widget.infoCubit.sendChatMessage(newReply.toMap(chatModel.id));
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      final PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  /* Future<void> startRecording() async {
    final hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      isComplete = false;
      setState(() => statusText = "Recording");
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      // requestPermission();
    }
  }*/
/* 
  void togglePauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      final bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      final bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

 Future<void> stopRecord() async {
    final bool s = RecordMp3.instance.stop();
    setState(() => uploadingVoice = true);
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      setState(() {});
      final customerCubit = CustomerCubit.get(context);
      final file = File(recordFilePath);
      if (file.existsSync()) {
        log('Uploading voice Message...');
        final voiceData = await customerCubit.uploadVoiceMessage(file);
        if (voiceData != null) {
          sendVoiceMessage(voiceData);
        }
      }
    }
    setState(() => uploadingVoice = false);
  }

  void resumeRecord() {
    final bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  Future<void> play() async {
    // final customerCubit = CustomerCubit.get(context);
    final file = File(recordFilePath);
    if (file.existsSync()) {
      final audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
      log('Uploading voice Message...');
      // await customerCubit.uploadVoiceMessage(file);
    }
  }

  Future<String> getFilePath() async {
    final storageDirectory = await getApplicationDocumentsDirectory();
    final String sdPath = "${storageDirectory.path}/record";
    final d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }*/

  Future<void> chooseImage() async {
    setState(() => uploadingImage = true);
    final customerCubit = CustomerCubit.get(context);
    final isGallery = await showWarningDialog(
      context,
      title: CategoryCubit.appText!.pickImage,
      content: CategoryCubit.appText!.chooseImageSentence,
      lfButtonTxt: CategoryCubit.appText!.camera,
      rtButtonTxt: CategoryCubit.appText!.gallery,
    );
    if (isGallery != null) {
      final xFile = await ImagePicker().pickImage(
          source: isGallery ? ImageSource.gallery : ImageSource.camera);
      if (xFile != null) {
        setState(() => _pickedFile = File(xFile.path));
      }
      if (_pickedFile != null) {
        log('Uploading user avatar...');
        final imageData = await customerCubit.uploadImageFile(_pickedFile!);
        if (imageData != null) {
          sendImageMessage(imageData);
        }
      }
    }
    setState(() => uploadingImage = false);
  }

  Future<void> sendImageMessage(Map<String, dynamic> imageData) async {
    ChatModel chatModel = InformationCubit.createdChatModel!;
    final imageId = imageData['id'] as int;
    final image = imageData['image'] as String;
    final newReply = ReplyModel.create(
      author: FirebaseAuthBloc.currentUser!.id,
      authorName: FirebaseAuthBloc.currentUser!.username,
      content: 'iMaGe meSSaGe...',
      date: DateTime.now().toString(),
      image: image,
    );
    widget.messageCtrl.clear();
    // log('Chat :  ${chatModel.replies}');

    chatModel = chatModel.copyWith(
      replies: [
        newReply,
        ...chatModel.replies,
      ],
    );

    InformationCubit.createdChatModel = chatModel;
    widget.infoCubit.sendChatMessage(
      newReply.mediaToMap(
        postId: chatModel.id,
        mediaId: imageId,
        mediaUrl: image,
      ),
    );
    setState(() => uploadingImage = false);
  }

  Future<void> sendVoiceMessage(Map<String, dynamic> voiceData) async {
    ChatModel chatModel = InformationCubit.createdChatModel!;
    final voiceId = voiceData['id'] as int;
    final voice = voiceData['voice'] as String;
    final newReply = ReplyModel.create(
      author: FirebaseAuthBloc.currentUser!.id,
      authorName: FirebaseAuthBloc.currentUser!.username,
      content: 'vOiCe meSSaGe...',
      date: DateTime.now().toString(),
      voice: voice,
    );
    widget.messageCtrl.clear();
    // log('Chat :  ${chatModel.replies}');

    chatModel = chatModel.copyWith(
      replies: [
        newReply,
        ...chatModel.replies,
      ],
    );

    InformationCubit.createdChatModel = chatModel;
    widget.infoCubit.sendChatMessage(
      newReply.mediaToMap(
        postId: chatModel.id,
        mediaId: voiceId,
        mediaUrl: voice,
        isImage: false,
      ),
    );
    setState(() => uploadingVoice = false);
  }
}
