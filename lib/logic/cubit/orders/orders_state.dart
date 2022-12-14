part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersGetLoading extends OrdersState {}

class OrdersRefreshLoading extends OrdersState {}

class OrdersGetSuccess extends OrdersState {}

class OrdersGetFailed extends OrdersState {
  final String error;
  const OrdersGetFailed({
    required this.error,
  });
}

class PaymentExecuteLoading extends OrdersState {}

class PaymentExecuteSuccess extends OrdersState {}

class PaymentGetLoading extends OrdersState {}

class PaymentGetSuccess extends OrdersState {}

class PaymentGetFailed extends OrdersState {
  final String error;
  const PaymentGetFailed({
    required this.error,
  });
}

class OrdersCreateLoading extends OrdersState {}

class OrdersCreateSuccess extends OrdersState {}

class OrdersCreateFailed extends OrdersState {
  final String error;
  const OrdersCreateFailed({
    required this.error,
  });
}

class OrdersThankYouLoading extends OrdersState {}

class OrdersThankYouSuccess extends OrdersState {}

class OrdersThankYouFailed extends OrdersState {
  final String error;
  const OrdersThankYouFailed({
    required this.error,
  });
}

class ChangeStepLoading extends OrdersState {}

class ChangeStepSuccess extends OrdersState {}

class GetDeliveryLocationLoading extends OrdersState {}

class GetDeliveryLocationSuccess extends OrdersState {}

class FetchDeliveryLocation extends OrdersState {}

class GetDeliveryLocationFailed extends OrdersState {
  final String error;
  const GetDeliveryLocationFailed({
    required this.error,
  });
}

class UpdateDeliveryLocationLoading extends OrdersState {}

class UpdateDeliveryLocationSuccess extends OrdersState {}

class UpdateDeliveryLocationFailed extends OrdersState {
  final String error;
  const UpdateDeliveryLocationFailed({
    required this.error,
  });
}

class ChangeOrderStatusLoading extends OrdersState {}

class ChangeOrderStatusSuccess extends OrdersState {}

class ChangeOrderStatusFailed extends OrdersState {
  final String error;
  const ChangeOrderStatusFailed({
    required this.error,
  });
}

class ConfirmPaymentLoading extends OrdersState {}

class ConfirmPaymentSuccess extends OrdersState {}

class ConfirmPaymentFailed extends OrdersState {
  final String error;
  const ConfirmPaymentFailed({
    required this.error,
  });
}

class ApplyCouponLoading extends OrdersState {}

class ApplyCouponSuccess extends OrdersState {
  final String type;
  const ApplyCouponSuccess({
    required this.type,
  });
}

class ApplyCouponFailed extends OrdersState {
  final String error;
  const ApplyCouponFailed({
    required this.error,
  });
}

class ReviewOrderLoading extends OrdersState {}

class ReviewOrderSuccess extends OrdersState {}

class ReviewOrderFailed extends OrdersState {
  final String error;
  const ReviewOrderFailed({
    required this.error,
  });
}
