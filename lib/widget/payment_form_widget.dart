import 'package:flutter/material.dart';
import 'package:money_manager/database/category.dart';
import 'package:money_manager/database/payment_database.dart';

class PaymentFormWidget extends StatelessWidget {
  final String? type;
  final double? import;
  final String? title;
  final String? description;
  final ValueChanged<String?>? onChangedType;
  final ValueChanged<String> onChangedImport;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  final List<DropdownMenuItem<String>>? list;

  final String dropdownValue = "One";

  PaymentFormWidget({
    Key? key,
    this.type = "",
    this.import = 0,
    this.title = '',
    this.description = '',
    this.list,
    required this.onChangedType,
    required this.onChangedImport,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  Future<List<DropdownMenuItem<String>>> RefreshCategory() async {
    List<Category> l = await PaymentDatabase.instance.readAllCategories();

    return l
        .map((e) => e.category)
        .toList()
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 8),
              Row(
                children: [
                  DropdownButton<String>(
                    dropdownColor: Color(0xFF191822),
                    value: type == "" ? list!.first.value : type,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    underline: Container(
                      height: 2,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onChanged: onChangedType,
                    items:
                        list /* list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList() */
                    ,
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Import',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: onChangedImport,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              buildDescription(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        onChanged: onChangedDescription,
      );
}
