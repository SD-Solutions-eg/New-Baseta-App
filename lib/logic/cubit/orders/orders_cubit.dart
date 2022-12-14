import 'dart:convert';
import 'dart:developer';

import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/payment_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/services/local_notifications.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:equatable/equatable.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository ordersRepo;
  final InternetCubit connection;
  OrdersCubit(
    this.ordersRepo,
    this.connection,
  ) : super(OrdersInitial());

  static OrdersCubit get(BuildContext context) => BlocProvider.of(context);

  List<OrderModel> orders = [];
  List<PaymentModel> paymentGateways = [];
  List<OrderModel> newDeliveryAssignedOrders = [];
  List<OrderModel> newCustomerProcessingOrders = [];
  OrderModel? createdOrder;
  int activeStep = 1;
  int discount = 0;
  UserModel? delivery;
  bool paymentExecuteSuccess = false;

  Future<void> getOrders() async {
    emit(OrdersGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(OrdersGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final customer = FirebaseAuthBloc.currentUser;
        if (customer != null) {
          orders = await ordersRepo.getOrders(
            customerId: customer.id,
            isDelivery: customer.role == UserType.delivery,
          );
          emit(OrdersGetSuccess());
        } else {
          emit(OrdersGetSuccess());
        }
      } catch (e) {
        log(e.toString());
        emit(OrdersGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> getPaymentGateways() async {
    emit(PaymentGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(PaymentGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        paymentGateways = await ordersRepo.getPaymentGateways();
        log('Payment Gateways are: $paymentGateways');
        emit(PaymentGetSuccess());
      } catch (e) {
        log('Payment Gateways failed: $e');
        emit(PaymentGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> refreshOrders() async {
    emit(OrdersGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(OrdersGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final customer = FirebaseAuthBloc.currentUser;
        if (customer != null) {
          final lastNewOrders = await ordersRepo.getOrders(
            customerId: customer.id,
            isDelivery: customer.role == UserType.delivery,
            perPage: 6,
          );
          if (customer.role == UserType.delivery) {
            log('Refresh Orders for delivery');
            final hasReadyOrders = lastNewOrders
                .any((element) => element.status == OrderStatus.onWay);
            if (hasReadyOrders) {
              final order = lastNewOrders
                  .firstWhere((element) => element.status == OrderStatus.onWay);
              log('Sending notification');
              await sendDeliveryNotification(order: order, isNewOrder: false);
            }
            final hasNewOrders = lastNewOrders.any(
                (element) => element.status == OrderStatus.assigningDelivery);
            log('has assigning order: $hasNewOrders');
            if (hasNewOrders) {
              final order = lastNewOrders.firstWhere(
                  (element) => element.status == OrderStatus.assigningDelivery);
              log('Sending notification');
              await sendDeliveryNotification(order: order);
            }
            newDeliveryAssignedOrders.clear();
            for (final order in lastNewOrders) {
              if (order.status == OrderStatus.assigningDelivery ||
                  order.status == OrderStatus.pendingPayment ||
                  order.status == OrderStatus.onWay ||
                  order.status == OrderStatus.waiting) {
                newDeliveryAssignedOrders.add(order);
              }
            }
          } else if (customer.role == UserType.customer) {
            log('Refresh Customer Orders');
            final hasProcessingOrders = lastNewOrders
                .any((element) => element.status == OrderStatus.pendingPayment);
            log('has processing order: $hasProcessingOrders');
            if (hasProcessingOrders) {
              final order = lastNewOrders.firstWhere(
                  (element) => element.status == OrderStatus.pendingPayment);
              log('Sending notification $order');
              await sendCustomerNotification(order: order);
            }
            newCustomerProcessingOrders.clear();
            log('Old Customer Orders: $newCustomerProcessingOrders');

            for (final order in lastNewOrders) {
              if (order.status == OrderStatus.pendingReview ||
                  order.status == OrderStatus.assigningDelivery ||
                  order.status == OrderStatus.pendingPayment ||
                  order.status == OrderStatus.onWay ||
                  order.status == OrderStatus.waiting) {
                newCustomerProcessingOrders.add(order);
              }
            }
            log('New Customer Orders: $newCustomerProcessingOrders');
          }
        }
        emit(OrdersGetSuccess());
      } catch (e) {
        log('Refresh Order Failed: $e');
        emit(OrdersGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> sendDeliveryNotification(
      {required OrderModel order, bool isNewOrder = true}) async {
    await showNotification(
      isNewOrder
          ? '${CategoryCubit.appText!.newOrder} #${order.orderId}'
          : '#${order.orderId} ready for delivery',
      order.partner != null
          ? '${order.partner!.name},${order.orderContent}'
          : order.orderContent,
    );
  }

  Future<void> sendCustomerNotification({required OrderModel order}) async {
    await showNotification(
      '${CategoryCubit.appText!.order} #${order.orderId} pending payment',
      order.orderContent,
    );
  }

  void updatePaymentStatus() {
    emit(PaymentExecuteLoading());
    paymentExecuteSuccess = true;
    emit(PaymentExecuteSuccess());
  }

  Future<void> createOrder(Map<String, dynamic> orderMap) async {
    emit(OrdersCreateLoading());
    if (connection.state is InternetConnectionFail) {
      emit(OrdersCreateFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final user = FirebaseAuthBloc.currentUser;
        if (user != null) {
          createdOrder = await ordersRepo.createOrders(orderMap);
          emit(OrdersCreateSuccess());
          paymentExecuteSuccess = false;
        } else {
          emit(const OrdersCreateFailed(error: 'Failed To Get User Data'));
        }
      } catch (e) {
        log(e.toString());
        emit(OrdersCreateFailed(error: e.toString()));
      }
    }
  }

  Future<void> getDeliveryLocation(int deliveryId) async {
    if (delivery == null) {
      emit(GetDeliveryLocationLoading());
    } else {
      emit(FetchDeliveryLocation());
    }
    if (connection.state is InternetConnectionFail) {
      emit(GetDeliveryLocationFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        delivery ??= await ordersRepo.getDeliveryModel(deliveryId);

        final deliveryDataModel =
            await ordersRepo.getDeliveryLocation(deliveryId);
        log(deliveryDataModel.mainLocation.toString());

        delivery = delivery!.copyWith(userData: deliveryDataModel);

        log('Delivery: $delivery');
        emit(GetDeliveryLocationSuccess());
      } catch (e) {
        log('Get Delivery Location Error: $e');
        emit(GetDeliveryLocationFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateDeliveryLocation(LocationModel newLocation) async {
    emit(UpdateDeliveryLocationLoading());

    if (connection.state is InternetConnectionFail) {
      emit(UpdateDeliveryLocationFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final user = FirebaseAuthBloc.currentUser;
        if (user != null) {
          log('User Data id: ${user.userData.dataId}');
          final updatedDeliveryDataModel =
              await ordersRepo.updateDeliveryLocation(
                  newLocation: newLocation, userDataId: user.userData.dataId);
          FirebaseAuthBloc.currentUser =
              user.copyWith(userData: updatedDeliveryDataModel);
        }

        emit(UpdateDeliveryLocationSuccess());
      } catch (e) {
        log('Update Delivery Location Error: $e');
        emit(UpdateDeliveryLocationFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateOrderStatus(
      {required String status,
      required OrderModel orderModel,
      String? price,
      String? userId}) async {
    emit(ChangeOrderStatusLoading());

    if (connection.state is InternetConnectionFail) {
      emit(ChangeOrderStatusFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final orderMap = {
          "fields": {
            "status": status,
            "cancel_user": userId,
            "price": price,
          },
        };
        final updatedOrder = await ordersRepo.updateOrderStatus(
            orderId: orderModel.orderId, orderMap: orderMap);
        if (updatedOrder.status == OrderStatus.delivered ||
            updatedOrder.status == OrderStatus.cancelled) {
          newDeliveryAssignedOrders.remove(updatedOrder);
        } else {
          final index = newDeliveryAssignedOrders.indexOf(updatedOrder);
          newDeliveryAssignedOrders.removeAt(index);
          newDeliveryAssignedOrders.insert(index, updatedOrder);
        }

        log('New Status is: ${updatedOrder.status}');
        emit(ChangeOrderStatusSuccess());
      } catch (e) {
        log('Update Order Status Error: $e');
        emit(ChangeOrderStatusFailed(error: e.toString()));
      }
    }
  }

  Future<void> confirmOrderPrice(
      {required String status,
      required OrderModel orderModel,
      required int paymentId,
      String? price,
      String? coupon}) async {
    emit(ConfirmPaymentLoading());

    if (connection.state is InternetConnectionFail) {
      emit(ConfirmPaymentFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final orderMap = {
          "coupon": coupon,
          "fields": {
            "status": status,
            "price": price,
            "price_confirmed": true,
            "payment_method": paymentId
          },
        };
        final updatedOrder = await ordersRepo.updateOrderStatus(
            orderId: orderModel.orderId, orderMap: orderMap);
        log('New Status is: ${updatedOrder.status}');
        emit(ConfirmPaymentSuccess());
      } catch (e) {
        log('Update Order Status Error: $e');
        emit(ConfirmPaymentFailed(error: e.toString()));
      }
    }
  }

  Future<void> reviewOrderDelivery(
      {required OrderModel orderModel,
      String? comment,
      required String rating}) async {
    emit(ReviewOrderLoading());

    if (connection.state is InternetConnectionFail) {
      emit(ReviewOrderFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final orderMap = {
          "fields": {
            "review": {"comment": comment, "rating": rating}
          },
        };
        final updatedOrder = await ordersRepo.updateOrderStatus(
            orderId: orderModel.orderId, orderMap: orderMap);
        log('Review Order Success: ${updatedOrder.review}');
        emit(ReviewOrderSuccess());
      } catch (e) {
        log('Review Order Error: $e');
        emit(ReviewOrderFailed(error: e.toString()));
      }
    }
  }

  Future<void> applyCoupon({required String coupon}) async {
    emit(ApplyCouponLoading());
    discount = 0;
    if (connection.state is InternetConnectionFail) {
      emit(
        ApplyCouponFailed(
          error: LanguageAr().connectionFailed,
        ),
      );
    } else {
      emit(ApplyCouponLoading());
      try {
        final responseData = await ordersRepo.applyCoupon(coupon: coupon);
        final valid = (json.decode(responseData)
            as Map<String, dynamic>)['valid'] as bool;
        discount = (json.decode(responseData)
            as Map<String, dynamic>)['percentage'] as int;
        final type = (json.decode(responseData) as Map<String, dynamic>)['type']
            as String;
        if (valid) {
          emit(ApplyCouponSuccess(
            type: type,
          ));
        } else {
          emit(ApplyCouponFailed(error: CategoryCubit.appText!.invalidCoupon));
        }
      } catch (e) {
        emit(ApplyCouponFailed(error: CategoryCubit.appText!.invalidCoupon));
      }
    }
  }

  void changeCheckoutStep(int step) {
    emit(ChangeStepLoading());
    activeStep = step;
    emit(ChangeStepSuccess());
  }

  void clearUserData() {
    orders.clear();
    createdOrder = null;
    newDeliveryAssignedOrders.clear();
    newCustomerProcessingOrders.clear();
  }

  // static String translateStatus({required String status}){
  //   switch (status){
  //     case OrderStatus.pendingReview :
  //       return 'جاري المراجعة';
  //     case OrderStatus.assigningDelivery :
  //       return 'تأكيد السائق';
  //     case OrderStatus.waiting :
  //       return 'جاري المراجعة';
  //     case OrderStatus.pendingPayment :
  //       return 'بانتظار الدفع';
  //     case OrderStatus.onWay :
  //       return 'في الطريق';
  //     case OrderStatus.delivered :
  //       return 'تم التوصيل';
  //     case OrderStatus.cancelled :
  //       return 'تم الالغاء';
  //   }
  // }

}
