import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/page/edit_category_page.dart';
import 'package:money_manager/page/edit_payment_page.dart';

import '../database/category.dart';
import '../database/payment_database.dart';

class CategoryDetailPage extends StatefulWidget {
  final int categoryId;

  const CategoryDetailPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Category cat;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshCategory();
  }

  Future refreshCategory() async {
    setState(() => isLoading = true);

    this.cat = await PaymentDatabase.instance.readCategory(widget.categoryId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      cat.category,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cat.color.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditCategoryPage(category: cat),
        ));

        refreshCategory();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await PaymentDatabase.instance.deleteCategory(widget.categoryId);

          Navigator.of(context).pop();
        },
      );
}
