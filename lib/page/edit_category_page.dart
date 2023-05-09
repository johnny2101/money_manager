import 'package:flutter/material.dart';

import '../database/category.dart';
import '../database/payment_database.dart';
import '../widget/cageogry_form_widget.dart';

class AddEditCategoryPage extends StatefulWidget {
  final Category? category;

  const AddEditCategoryPage({
    Key? key,
    this.category,
  }) : super(key: key);
  @override
  _AddEditCategoryPageState createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late String category;
  late int color;

  @override
  void initState() {
    super.initState();

    category = widget.category?.category ?? '';
    color = widget.category?.color ?? 0;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: CategoryFormWidget(
            category: category,
            color: color,
            onChangedCategory: (category) =>
                setState(() => {this.category = category!, print(category)}),
            onChangedColor: (color) =>
                setState(() => {this.color = color!.value, print(color)}),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = category.isNotEmpty /*&& category.isNotEmpty*/;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateCategory,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateCategory() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.category != null;

      if (isUpdating) {
        await updateCategory();
      } else {
        await addCategory();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateCategory() async {
    final cat = widget.category!.copy(
      category: category,
    );

    await PaymentDatabase.instance.updateCategory(cat);
  }

  Future addCategory() async {
    final cat = Category(
      category: category,
      color: color,
    );

    await PaymentDatabase.instance.createCategory(cat);
  }
}
