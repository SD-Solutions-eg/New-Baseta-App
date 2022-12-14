import 'dart:developer';
import 'dart:math' show Random;

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/payment_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:allin1/presentation/widgets/widgetsClasses/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

class PaymentMobile extends StatefulWidget {
  const PaymentMobile({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  State<PaymentMobile> createState() => _PaymentMobileState();
}

class _PaymentMobileState extends State<PaymentMobile> {
  final formKey = GlobalKey<FormState>();
  final Map<String, String> cardDetails = {};
  PaymentModel? selectedPaymentModel;
  late final OrdersCubit ordersCubit;
  // late final CartCubit cartCubit;
  int paymentMethodIndex = 0;
  bool isAgree = true;
  bool _isInit = false;
  bool paymentWithPayTabsDone = false;
  double totalCost = 0;
  double discount = 0;
  bool isGiftCoupon = false;
  late final BillingDetails billingDetails;
  late final ShippingDetails? shippingDetails;
  final TextEditingController? couponController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      final user = FirebaseAuthBloc.currentUser;
      ordersCubit.getPaymentGateways();
      billingDetails = BillingDetails(
          user!.userData.fullName,
          user.email,
          '+201000000000',
          user.userData.area!.name,
          'eg',
          user.userData.area!.name,
          user.userData.area!.name,
          "23417");

      shippingDetails = ShippingDetails(
          "shipping name",
          "shipping email",
          "shipping phone",
          "address line",
          "country",
          "city",
          "state",
          "zip code");

      if (ordersCubit.paymentGateways.isNotEmpty) {
        selectedPaymentModel = ordersCubit.paymentGateways.first;
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    totalCost = calculateTotal();
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.paymentMethod),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              ScreenUtil().screenWidth > 600 ? hLargePadding : hMediumPadding,
          vertical: vMediumPadding,
        ),
        child: SingleChildScrollView(
          child: BlocConsumer<OrdersCubit, OrdersState>(
            listener: (context, state) {
              if (state is ApplyCouponSuccess) {
                setState(() {
                  if (state.type == 'delivery_discount') {
                    discount =
                        double.parse(widget.orderModel.area!.deliveryPrice) *
                            (ordersCubit.discount / 100);
                  } else if (state.type == 'total_discount') {
                    discount = double.parse(widget.orderModel.price) *
                        (ordersCubit.discount / 100);
                  } else {
                    isGiftCoupon = true;
                    discount = 0;
                  }
                });
                totalCost = calculateTotal();
              } else if (state is ApplyCouponFailed) {
                discount = 0;
                totalCost = calculateTotal();
                couponController!.clear();
                customSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: FilledTextFieldWithLabel(
                          controller: couponController,
                          height: 45.h,
                          hintText: CategoryCubit.appText!.couponDiscount,
                          inputAction: TextInputAction.done,
                          // requiredField: true,
                          // inputBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(color: primarySwatch,style: BorderStyle.solid,width: 2)
                          // ),
                        ),
                      ),
                      SizedBox(
                        width: hSmallPadding,
                      ),
                      Expanded(
                        child: DefaultButton(
                          onPressed: () {
                            ordersCubit.applyCoupon(
                                coupon: couponController!.text);
                          },
                          isLoading: state is ApplyCouponLoading,
                          height: 45.h,
                          text: CategoryCubit.appText!.applyCoupon,
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  buildOrderItem(
                    context,
                    title: CategoryCubit.appText!.price,
                    value:
                        '${widget.orderModel.price} ${widget.orderModel.currency}',
                  ),
                  const Divider(),
                  buildOrderItem(
                    context,
                    title: CategoryCubit.appText!.shippingFees,
                    value:
                        '+ ${widget.orderModel.area!.deliveryPrice} ${widget.orderModel.currency}',
                  ),
                  const Divider(),
                  buildOrderItem(
                    context,
                    title: Languages.of(context).serviceFee,
                    value:
                        '+ ${widget.orderModel.serviceFee == '' ? 0 : widget.orderModel.serviceFee} ${widget.orderModel.currency}',
                  ),
                  if (!isGiftCoupon) ...[
                    const Divider(),
                    buildOrderItem(
                      context,
                      title: CategoryCubit.appText!.couponDiscount,
                      value:
                          '- ${discount.toStringAsFixed(2)} ${widget.orderModel.currency}',
                    ),
                  ],
                  const Divider(),
                  buildOrderItem(
                    context,
                    title: CategoryCubit.appText!.total,
                    value: '$totalCost ${widget.orderModel.currency}',
                  ),
                  if (isGiftCoupon) ...[const Divider(), const GiftCard()],
                  SizedBox(height: vLargePadding),
                  Text(CategoryCubit.appText!.allTransactionsSecure),
                  SizedBox(height: vSmallPadding),
                  const MyDottedLine(color: iconGreyColor),
                  SizedBox(height: vMediumPadding),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: OrdersCubit.get(context).paymentGateways.length,
                    itemBuilder: (context, index) {
                      final payment =
                          OrdersCubit.get(context).paymentGateways[index];
                      return PaymentMethodCard(
                        paymentMethod: payment.name,
                        description: payment.description,
                        onChange: (value) => setState(() {
                          paymentMethodIndex = value as int;
                          selectedPaymentModel =
                              ordersCubit.paymentGateways[value];
                        }),
                        selectedMethod: paymentMethodIndex,
                        value: index,
                        trailing: payment.id.toString() == 'ppcp-gateway' ||
                                payment.id.toString() == 'woocommerce_payments'
                            ? Image.asset(
                                'assets/images/payment_methods.png',
                                height: 40.h,
                                width: 120.w,
                              )
                            : null,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: vMediumPadding),
                  ),
                  // SizedBox(height: vLargePadding),
                  // Text(
                  //   CategoryCubit.appText!.yourPersonalDataSentence,
                  //   style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  //         height: 1.8,
                  //       ),
                  // ),
                  SizedBox(height: vMediumPadding),
                  const MyDottedLine(color: iconGreyColor),
                  SizedBox(height: vVeryLargeMargin),
                  BlocConsumer<OrdersCubit, OrdersState>(
                    listener: (context, state) async {
                      if (state is OrdersCreateSuccess) {
                        // final cartCubit = CartCubit.get(context);
                        // cartCubit.cartItems.addAll([...cartCubit.cartModel!.items]);
                        // cartCubit.clearCartItems();
                        OrdersCubit.get(context).changeCheckoutStep(3);
                      } else if (state is OrdersCreateFailed) {
                        customSnackBar(
                          context: context,
                          message: CategoryCubit.appText!.failedToCreateOrder,
                        );
                      }
                    },
                    builder: (context, orderState) {
                      return BlocConsumer<OrdersCubit, OrdersState>(
                        listener: (context, state) {
                          if (state is ConfirmPaymentSuccess) {
                            OrdersCubit.get(context).getOrders();
                            AwesomeDialog(
                              context: context,
                              dismissOnBackKeyPress: false,
                              dismissOnTouchOutside: false,
                              autoDismiss: false,
                              onDissmissCallback: (dismissType) {
                                return false;
                              },
                              dialogType: DialogType.SUCCES,
                              title: CategoryCubit.appText!.onTheWay,
                              // desc: CategoryCubit.appText!.orderIsReviewing,
                              btnOkText: CategoryCubit.appText!.ok,
                              btnOkOnPress: () {
                                OrdersCubit.get(context).refreshOrders();
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pop();
                              },
                              // btnOkColor: Theme.of(context).colorScheme.primary,
                            ).show();
                          } else if (state is ConfirmPaymentFailed) {
                            customSnackBar(
                                context: context, message: state.error);
                          }
                        },
                        builder: (context, state) {
                          return DefaultButton(
                            buttonColor: primarySwatch,
                            text: CategoryCubit.appText!.confirm,
                            width: double.infinity,
                            isLoading: state is ConfirmPaymentLoading,
                            onPressed: _confirmPayment,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: vVeryLargeMargin),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double calculateTotal() {
    double totalCost;
    try {
      totalCost = double.parse(widget.orderModel.price) +
          double.parse(widget.orderModel.serviceFee == ''
              ? '0'
              : widget.orderModel.serviceFee) +
          double.parse(widget.orderModel.area!.deliveryPrice) -
          discount;
    } catch (e) {
      totalCost = 0;
      log(e.toString());
    }
    return totalCost;
  }

  Future<void> _confirmPayment() async {
    // if (isAgree) {
    if (selectedPaymentModel!.name == 'Online Payment' ||
        selectedPaymentModel!.name == 'دفع اونلاين') {
      await payWithPayTabs();
      if (paymentWithPayTabsDone) {
        final OrdersCubit ordersCubit = OrdersCubit.get(context);
        ordersCubit.confirmOrderPrice(
            status: 'on_way',
            coupon: couponController?.text,
            price: totalCost.toString(),
            orderModel: widget.orderModel,
            paymentId: selectedPaymentModel!.id);
      }
    } else {
      // final OrdersCubit ordersCubit = OrdersCubit.get(context);
      ordersCubit.confirmOrderPrice(
          status: 'on_way',
          coupon: couponController?.text,
          price: widget.orderModel.price,
          orderModel: widget.orderModel,
          paymentId: selectedPaymentModel!.id);
    }
    // } else {
    //   customSnackBar(
    //     context: context,
    //     message: CategoryCubit.appText!.youMustAgreesToReturn,
    //   );
    // }
  }

  Future<void> payWithPayTabs() async {
    final configuration = _configurePayTabs(billingDetails, shippingDetails);
    await _startPayment(configuration);
  }

  PaymentSdkConfigurationDetails _configurePayTabs(
      BillingDetails billingDetails, ShippingDetails? shippingDetails) {
    final isAr = Languages.of(context) is LanguageAr;
    final configuration = PaymentSdkConfigurationDetails(
      profileId: CategoryCubit.payTabsModel.profileId,
      serverKey: CategoryCubit.payTabsModel.serverKey,
      clientKey: CategoryCubit.payTabsModel.clientKey,
      cartId: Random().nextInt(999999).toString(),
      merchantName: appNameEn,
      screentTitle: isAr ? "ادفع بالبطاقة" : "Pay with Card",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      locale: isAr
          ? PaymentSdkLocale.AR
          : PaymentSdkLocale
              .EN, //PaymentSdkLocale.AR or PaymentSdkLocale.DEFAULT
      amount: totalCost,
      currencyCode: 'EGP',
      merchantCountryCode: "EG",
      hideCardScanner: false,
      // showBillingInfo: true,
    );
    final theme = IOSThemeConfigurations(
      backgroundColor: 'ffffff',
      primaryColor: 'ffffff',
      secondaryColor: '62B22E',
      buttonColor: '62B22E',
      titleFontColor: '000000',
      secondaryFontColor: '1e272e',
      primaryFontColor: '000000',
      strokeColor: '1e272e',
      buttonFontColor: 'ffffff',
    );
    theme.logoImage = 'assets/images/Basita.png';
    theme.secondaryColor = '62B22E';
    configuration.iOSThemeConfigurations = theme;
    return configuration;
  }

  Future<void> _startPayment(
      PaymentSdkConfigurationDetails configuration) async {
    await FlutterPaytabsBridge.startCardPayment(configuration, (event) async {
      if (event["status"] == "success") {
        // Handle transaction details here.
        final transactionDetails = event["data"];
        log('Success: ${transactionDetails.toString()}');
        if (mounted) setState(() => paymentWithPayTabsDone = true);
        // await createOrder();
      } else if (event["status"] == "error") {
        // Handle error here.
        log('Error: ${event["message"]}');
      } else if (event["status"] == "event") {
        // Handle events here.
        log('Event??');
      }
    });
  }

  // Future<void> createOrder() async {
  //   final cartModel = cartCubit.cartModel!;
  //   await ordersCubit.createOrder(cartModel, selectedPaymentModel!);
  // }
}

class GiftCard extends StatelessWidget {
  const GiftCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: vVerySmallPadding,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: hSmallPadding, vertical: vSmallPadding),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.gift,
                color: primarySwatch,
              ),
              SizedBox(
                width: hSmallPadding,
              ),
              Text(
                CategoryCubit.appText!.youWillGetGift,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: primarySwatch,
                    ),
              ),
            ],
          ),
        ));
  }
}

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    Key? key,
    required this.paymentMethod,
    required this.description,
    this.trailing,
    required this.onChange,
    required this.selectedMethod,
    required this.value,
  }) : super(key: key);
  final String paymentMethod;
  final String description;
  final Widget? trailing;
  final ValueSetter onChange;
  final int selectedMethod;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hVerySmallPadding * 0.5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(verySmallRadius),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1BA55C).withOpacity(0.3),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onChange(value),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: hVerySmallPadding,
            end: hMediumPadding,
            top: vVerySmallPadding,
            bottom: vMediumPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                value: value,
                groupValue: selectedMethod,
                fillColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: onChange,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: vSmallPadding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentMethod,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const Spacer(),
                        if (trailing != null)
                          trailing!
                        else
                          SizedBox(height: vMediumPadding),
                      ],
                    ),
                    SizedBox(height: vSmallPadding),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            height: 1.8,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCartInfoRow(BuildContext context,
      {required String title,
      String? subtitle,
      required Widget value,
      bool bold = false,
      double? size}) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: vVerySmallPadding),
          child: RichText(
            text: TextSpan(
              text: title,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: bold ? FontWeight.w500 : FontWeight.normal,
                    fontSize: size ?? 18.sp,
                  ),
              children: [
                TextSpan(
                  text: subtitle,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
        ),
        const Spacer(),
        value,
      ],
    );
  }
}
