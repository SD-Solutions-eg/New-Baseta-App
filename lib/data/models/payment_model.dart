class PaymentModel {
  PaymentModel({
    required this.id,
    required this.description,
    required this.name,
  });
  late final int id;
  late final String description;
  late final String name;

  PaymentModel.fromJson(dynamic json) {
    id = json['id'] as int;
    description = json['description'] as String;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['name'] = name;
    return data;
  }
}
