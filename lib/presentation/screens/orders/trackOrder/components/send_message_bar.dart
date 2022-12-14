import 'dart:math' as math;

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/data/models/order_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class SendMessageBar extends StatefulWidget {
  final InformationCubit infoCubit;
  final OrderModel order;

  const SendMessageBar({
    Key? key,
    required this.infoCubit,
    required this.order,
    required this.messageCtrl,
  }) : super(key: key);

  final TextEditingController messageCtrl;

  @override
  State<SendMessageBar> createState() => _SendMessageBarState();
}

class _SendMessageBarState extends State<SendMessageBar> {
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
          Padding(
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
    OrderModel orderModel = widget.order;
    final newReply = ReplyModel.create(
      author: FirebaseAuthBloc.currentUser!.id,
      authorName: FirebaseAuthBloc.currentUser!.username,
      content: widget.messageCtrl.text.trim(),
      date: DateTime.now().toString(),
    );
    widget.messageCtrl.clear();
    // log('Chat :  ${chatModel.replies}');

    orderModel = orderModel.copyWith(
      comments: [
        newReply,
        ...orderModel.comments,
      ],
    );

    final orderCubit = OrdersCubit.get(context);

    final index = orderCubit.newCustomerProcessingOrders.indexOf(orderModel);
    orderCubit.newCustomerProcessingOrders.removeAt(index);
    orderCubit.newCustomerProcessingOrders.insert(index, orderModel);
    orderCubit.emit(OrdersGetLoading());
    orderCubit.emit(OrdersGetSuccess());

    widget.infoCubit.sendChatMessage(newReply.toMap(orderModel.orderId));
  }
}
