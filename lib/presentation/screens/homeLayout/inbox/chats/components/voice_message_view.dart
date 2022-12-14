import 'dart:async';
import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

class VoiceMessageView extends StatefulWidget {
  final ReplyModel voiceMessage;
  const VoiceMessageView({
    Key? key,
    required this.voiceMessage,
  }) : super(key: key);

  @override
  State<VoiceMessageView> createState() => VoiceMessageViewState();
}

class VoiceMessageViewState extends State<VoiceMessageView> {
  late final ReplyModel message;
  final audioPlayer = AudioPlayer();
  StreamSubscription? streamSubscription;
  bool isPlaying = false;
  bool isLoading = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      message = widget.voiceMessage;
      setAudioPlayer();
      _isInit = true;
    }
  }

  Future<void> setAudioPlayer() async {
    setState(() => isLoading = true);
    final assn = await audioPlayer.setUrl(message.voice!);
    log('Set Url: $assn ');
    final onCompletionStream = audioPlayer.onPlayerCompletion;
    streamSubscription = onCompletionStream.listen((_) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    });
    streamSubscription = audioPlayer.onAudioPositionChanged.listen((duration) {
      if (mounted) {
        setState(() => currentDuration = duration);
      }
    });
    streamSubscription = audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => totalDuration = duration);
      }
    });
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Languages.of(context) is LanguageAr;
    final time = intl.DateFormat.jm(isAr ? 'ar' : 'en')
        .format(DateTime.parse(message.date));
    final isMe = message.author == FirebaseAuthBloc.currentUser!.id;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: hSmallPadding, vertical: vVerySmallPadding),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsetsDirectional.only(end: hSmallPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(smallRadius),
                child: Image.asset(
                  'assets/images/Icon.png',
                  width: 35.w,
                  height: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: isMe
                        ? AlignmentDirectional.topStart
                        : AlignmentDirectional.topEnd,
                    padding: EdgeInsets.symmetric(
                      horizontal: hSmallPadding,
                      vertical: vSmallPadding,
                    ),
                    margin: EdgeInsetsDirectional.only(
                      end: isMe ? 0 : hLargePadding,
                      start: !isMe ? 0 : hLargePadding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: isMe
                          ? BorderRadiusDirectional.only(
                              topStart: Radius.circular(smallRadius),
                              bottomStart: Radius.circular(smallRadius),
                              bottomEnd: Radius.circular(smallRadius),
                            )
                          : BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(smallRadius),
                              topEnd: Radius.circular(smallRadius),
                              bottomStart: Radius.circular(smallRadius),
                            ),
                      color: isMe
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.lightGreen.shade100.withOpacity(0.6),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.65,
                        minWidth: hVerySmallPadding,
                      ),
                      child: isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: hSmallPadding,
                                  vertical: vSmallPadding),
                              child: LinearProgressIndicator(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            )
                          : Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    borderRadius:
                                        BorderRadius.circular(veryLargeRadius),
                                    onTap: () {
                                      if (isPlaying) {
                                        audioPlayer.pause();
                                        setState(() => isPlaying = false);
                                      } else {
                                        audioPlayer.play(message.voice!);
                                        setState(() => isPlaying = true);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          hVerySmallPadding * 1.3),
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color:
                                            !isMe ? Colors.black : Colors.white,
                                        size: 24.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.55.sw,
                                    height: 30.w,
                                    child: ProgressBar(
                                      barHeight: 1.w,
                                      progress: currentDuration,
                                      total: totalDuration,
                                      timeLabelLocation:
                                          TimeLabelLocation.sides,
                                      onSeek: (duration) {
                                        setState(() => isPlaying = true);
                                        audioPlayer.play(message.voice!,
                                            position: duration);
                                      },
                                      thumbRadius: 10.w,
                                      thumbGlowRadius: 16.w,
                                      timeLabelTextStyle: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: !isMe
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 10.sp,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: vVerySmallPadding),
              if (isMe)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(width: hVerySmallPadding),
                    Icon(
                      IconlyLight.tick_square,
                      size: 14.w,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
