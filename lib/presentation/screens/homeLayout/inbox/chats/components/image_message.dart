import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/my_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ReplyModel message;

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
                      horizontal: hVerySmallPadding,
                      vertical: vVerySmallPadding,
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(smallRadius),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.imageFullScreen,
                        arguments: message.image,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.55,
                          minWidth: hVerySmallPadding,
                        ),
                        child: Container(
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
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Hero(
                            tag: message.image!,
                            child: MyNetworkImage(
                              image: message.image!,
                              width: 0.55.sw,
                              fit: BoxFit.contain,
                            ),
                          ),
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
