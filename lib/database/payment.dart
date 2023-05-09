import 'dart:convert';

final String tablePayments = 'payments';

class PaymentFields {
  static final String id = '_id';
  static final String type = 'type';
  static final String import = 'import';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';

  static var values = [id, type, import, title, description, createdTime];
}

class Payment {
  final int? id;
  final String type;
  final double import;
  final String title;
  final String description;
  final DateTime createdTime;

  Payment(
      {this.id,
      required this.type,
      required this.import,
      required this.title,
      required this.description,
      required this.createdTime});

  Map<String, Object?> toJson() => {
        PaymentFields.id: id,
        PaymentFields.title: title,
        PaymentFields.import: import,
        PaymentFields.type: type,
        PaymentFields.description: description,
        PaymentFields.createdTime: createdTime.toIso8601String()
      };

  Payment copy(
          {int? id,
          String? type,
          double? import,
          String? title,
          String? description,
          DateTime? createdTime}) =>
      Payment(
          id: id ?? this.id,
          type: type ?? this.type,
          import: import ?? this.import,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);

  static Payment fromJson(Map<String, Object?> json) => Payment(
      id: json[PaymentFields.id] as int?,
      type: json[PaymentFields.type] as String,
      import: json[PaymentFields.import] as double,
      title: json[PaymentFields.title] as String,
      description: json[PaymentFields.description] as String,
      createdTime: DateTime.parse(json[PaymentFields.createdTime] as String));
}
