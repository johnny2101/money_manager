import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:money_manager/database/category.dart';
import 'package:money_manager/database/payment_database.dart';
import 'package:money_manager/page/category_detail_page.dart';
import 'package:money_manager/page/edit_category_page.dart';
import 'package:money_manager/page/edit_payment_page.dart';
import 'package:money_manager/page/payment_detail_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../database/payment.dart';
import '../widget/payment_card_widget.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late List<Category> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("inited");

    refreshCategories();
  }

  @override
  void dispose() {
    PaymentDatabase.instance.close();

    super.dispose();
  }

  Future refreshCategories() async {
    setState(() => isLoading = true);

    this.categories = await PaymentDatabase.instance.readAllCategories();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Categorie',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close)),
            SizedBox(width: 12)
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Expanded(
              child: ListView(
                children: buildCategories(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditCategoryPage()),
            );

            refreshCategories();
          },
        ),
      );
  List<Widget> buildCategories() {
    List<Widget> list;

    return this
        .categories
        .map(
          (item) => new ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(item.color))),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoryDetailPage(categoryId: item.id!),
              ));

              refreshCategories();
            },
            child: Text(
              item.category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        )
        .toList();
  }
}
