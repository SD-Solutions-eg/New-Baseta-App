// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/homeLayout/inbox/chats/components/message_bubble.dart';
import 'package:allin1/presentation/screens/myLocation/components/small_map_view.dart';
import 'package:allin1/presentation/screens/orders/trackOrder/components/send_message_bar.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:allin1/presentation/widgets/my_network_image.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackOrderScreen extends StatefulWidget {
  final OrderModel orderModel;
  const TrackOrderScreen({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  late OrderModel order;
  late final OrdersCubit ordersCubit;
  bool refresh = false;
  final messageCtrl = TextEditingController();
  Timer? timer;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      ordersCubit.delivery = null;
      order = widget.orderModel;
      ordersCubit.getDeliveryLocation(order.delivery!.id);
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
      await OrdersCubit.get(context).refreshOrders();
    });
  }

  @override
  void dispose() {
    messageCtrl.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.trackOrder),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is! GetDeliveryLocationLoading) {
            final deliverModel = ordersCubit.delivery;
            try {
              order = ordersCubit.newCustomerProcessingOrders
                  .firstWhere((element) => element.orderId == order.orderId);
            } catch (e) {
              print('');
            }
            if (deliverModel != null) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: vVeryLargeMargin * 1.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250.w,
                        width: double.infinity,
                        child: StatefulBuilder(builder: (context, setMapState) {
                          refresh = !refresh;
                          return SmallMapView(
                              order: order,
                              locationModel:
                                  deliverModel.userData.mainLocation ??
                                      const LocationModel.create());
                        }),
                      ),
                      SizedBox(height: vSmallPadding),
                      buildDeliveryRow(deliverModel),
                      SizedBox(height: vSmallPadding),
                      const CustomDivider(),
                      SizedBox(height: vSmallPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: hMediumPadding,
                            vertical: vSmallPadding),
                        child:
                            MainHeadline(title: CategoryCubit.appText!.chats),
                      ),
                      ListView.separated(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: hSmallPadding, vertical: vSmallPadding),
                        itemBuilder: (context, index) =>
                            MessageBubble(message: order.comments[index]),
                        separatorBuilder: (_, __) =>
                            SizedBox(height: vVerySmallPadding),
                        itemCount: order.comments.length,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const EmptyScreenView();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SendMessageBar(
        infoCubit: InformationCubit.get(context),
        messageCtrl: messageCtrl,
        order: order,
      ),
    );
  }

  Widget buildDeliveryRow(UserModel delivery) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(smallRadius),
        child: MyNetworkImage(
          image: delivery.avatarUrl,
          width: 45.w,
          height: 45.w,
        ),
      ),
      title: Text(delivery.firstName.isNotEmpty
          ? '${delivery.firstName} ${delivery.lastName}'
          : delivery.username),
      subtitle: delivery.firstName.isNotEmpty ? Text(delivery.username) : null,
      trailing: GestureDetector(
        onTap: () async {
          launch(
              'tel:${order.deliveryMobile != '' ? order.deliveryMobile : order.delivery?.username}');
        },
        child: CircleAvatar(
          radius: 25.w,
          backgroundColor: primarySwatch,
          child: const Icon(
            FontAwesomeIconsLight.phone,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
