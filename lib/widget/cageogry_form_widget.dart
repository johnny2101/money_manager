import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryFormWidget extends StatelessWidget {
  final String? category;
  final int? color;
  final ValueChanged<String?> onChangedCategory;
  final ValueChanged<Color?> onChangedColor;

  int mycolor = Colors.red.value;

  CategoryFormWidget({
    Key? key,
    this.category = "",
    required this.onChangedCategory,
    required this.onChangedColor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = TextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Category',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    onChanged: onChangedCategory,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(mycolor))),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: Color(mycolor), //default color
                          onColorChanged: onChangedColor,
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('DONE'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); //dismiss the color picker
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Default Color Picker"),
            ),
          ],
        ),
      ),
    );
  }
}
