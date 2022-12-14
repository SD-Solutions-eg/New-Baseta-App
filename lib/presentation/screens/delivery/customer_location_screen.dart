import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/myLocation/components/small_map_view.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CustomerLocationScreen extends StatefulWidget {
  final OrderModel orderModel;
  const CustomerLocationScreen({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  @override
  _CustomerLocationScreenState createState() => _CustomerLocationScreenState();
}

class _CustomerLocationScreenState extends State<CustomerLocationScreen> {
  late final OrderModel order;
  late final OrdersCubit ordersCubit;
  bool refresh = false;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      ordersCubit.emit(OrdersGetSuccess());
      ordersCubit.delivery = null;
      order = widget.orderModel;
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.location),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is ChangeOrderStatusSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final customerLocation = order.customerLocation;
          if (customerLocation != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250.w,
                  width: double.infinity,
                  child: StatefulBuilder(builder: (context, setMapState) {
                    refresh = !refresh;
                    return SmallMapView(
                      order: order,
                      locationModel: order.customerLocation!,
                      isDelivery: true,
                    );
                  }),
                ),
                SizedBox(height: vSmallPadding),
                if (order.customer != null) buildDeliveryRow(order.customer!),
                SizedBox(height: vSmallPadding),
                const CustomDivider(),
                SizedBox(height: vSmallPadding),
                if (order.comments.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: hMediumPadding, vertical: vSmallPadding),
                    child: MainHeadline(title: CategoryCubit.appText!.status),
                  ),
                // Expanded(
                //   child: ListView.separated(
                //     physics: const BouncingScrollPhysics(),
                //     reverse: true,
                //     shrinkWrap: order.comments.length < 4,
                //     itemBuilder: (context, index) =>
                //         MessageBubble(message: order.comments[index]),
                //     separatorBuilder: (_, __) =>
                //         SizedBox(height: vVerySmallPadding),
                //     itemCount: order.comments.length,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding, vertical: vMediumPadding),
                  child: DefaultButton(
                    text: order.status == OrderStatus.delivered
                        ? CategoryCubit.appText!.finish
                        : '${CategoryCubit.appText!.delivered} ?',
                    width: double.infinity,
                    isLoading: state is ChangeOrderStatusLoading,
                    buttonColor: order.status == OrderStatus.delivered
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        title:
                            '${CategoryCubit.appText!.orderDeliveredSuccess}?',
                        btnOkText: CategoryCubit.appText!.yes,
                        btnCancelText: CategoryCubit.appText!.cancel,
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async => ordersCubit.updateOrderStatus(
                          status: 'completed',
                          orderModel: order,
                        ),
                      ).show();
                    },
                  ),
                ),
              ],
            );
          } else {
            return EmptyScreenView(
              subtitle: CategoryCubit.appText!.error,
              icon: FontAwesomeIconsLight.info,
            );
          }
        },
      ),
    );
  }

  Widget buildDeliveryRow(OrderUserModel customer) {
    return ListTile(
      title: Text(customer.name),
      subtitle: customer.username.isNotEmpty &&
              customer.username.toLowerCase() != customer.name.toLowerCase()
          ? Text(customer.username)
          : null,
    );
  }
}
