import 'dart:convert';

final String tableCategories = 'categories';

class CategoryFields {
  static final String id = '_id';
  static final String category = 'category';
  static final String color = 'color';

  static var values = [id, category, color];
}

class Category {
  final int? id;
  final String category;
  final int color;

  Category({
    this.id,
    required this.category,
    required this.color,
  });

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.category: category,
        CategoryFields.color: color,
      };

  Category copy({
    int? id,
    String? category,
    int? color,
  }) =>
      Category(
        id: id ?? this.id,
        category: category ?? this.category,
        color: color ?? this.color,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        category: json[CategoryFields.category] as String,
        color: json[CategoryFields.color] as int,
      );
}
