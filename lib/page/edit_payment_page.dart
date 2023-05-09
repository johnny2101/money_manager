import 'package:flutter/material.dart';
import 'package:money_manager/database/category.dart';
import 'package:money_manager/widget/payment_form_widget.dart';

import '../database/payment.dart';
import '../database/payment_database.dart';

class AddEditPaymentPage extends StatefulWidget {
  final Payment? payment;

  final List<Category> categories;

  const AddEditPaymentPage({
    Key? key,
    this.payment,
    required this.categories,
  }) : super(key: key);
  @override
  _AddEditPaymentPageState createState() => _AddEditPaymentPageState();
}

class _AddEditPaymentPageState extends State<AddEditPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  late String type;
  late double import;
  late String title;
  late String description;
  late List<DropdownMenuItem<String>> categories;

  late List<DropdownMenuItem<String>> l = [];

  Future refreshCategoies() async {
    List<Category> nl = await PaymentDatabase.instance.readAllCategories();

    l = nl
        .map((e) => e.category)
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    categories = widget.categories
        .map((e) => e.category)
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
        .toList();
    type = widget.payment?.type ?? categories.first.value!;
    import = widget.payment?.import ?? 0.00;
    title = widget.payment?.title ?? '';
    description = widget.payment?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: PaymentFormWidget(
            type: type,
            import: import,
            title: title,
            list: categories,
            description: description,
            onChangedType: (type) =>
                setState(() => {this.type = type!, print(type)}),
            onChangedImport: (import) =>
                setState(() => this.import = double.parse(import)),
            onChangedTitle: (title) =>
                setState(() => {this.title = title, print(title)}),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && import.isNaN /*&& type.isNotEmpty*/;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdatePayment,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdatePayment() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.payment != null;

      if (isUpdating) {
        await updatePayment();
      } else {
        await addPayment();
      }

      Navigator.of(context).pop();
    }
  }

  Future updatePayment() async {
    final payment = widget.payment!.copy(
      type: type,
      import: import,
      title: title,
      description: description,
    );

    await PaymentDatabase.instance.update(payment);
  }

  Future addPayment() async {
    final payment = Payment(
      title: title,
      type: type,
      import: import,
      description: description,
      createdTime: DateTime.now(),
    );

    await PaymentDatabase.instance.create(payment);
  }
}
