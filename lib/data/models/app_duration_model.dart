class AppDurationModel {
  final int deliveryOrdersDuration;
  final int customerOrdersDuration;
  final int updateLocationDuration;
  final int updateChatDuration;

  const AppDurationModel(
      {required this.deliveryOrdersDuration,
      required this.customerOrdersDuration,
      required this.updateLocationDuration,
      required this.updateChatDuration});
  const AppDurationModel.init({
    this.deliveryOrdersDuration = 5,
    this.customerOrdersDuration = 5,
    this.updateLocationDuration = 5,
    this.updateChatDuration = 5,
  });

  factory AppDurationModel.fromMap(Map<String, dynamic> map) {
    return AppDurationModel(
      deliveryOrdersDuration: map['app_orders_duration'] is String
          ? int.parse(map['app_orders_duration'] as String)
          : 5,
      customerOrdersDuration: map['app_customer_order_duration'] is String
          ? int.parse(map['app_customer_order_duration'] as String)
          : 5,
      updateLocationDuration: map['app_location_duration'] is String
          ? int.parse(map['app_location_duration'] as String)
          : 10,
      updateChatDuration: map['app_chat_duration'] is String
          ? int.parse(map['app_chat_duration'] as String)
          : 10,
    );
  }
}
