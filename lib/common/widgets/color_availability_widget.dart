// color_selection_widget.dart
// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class ColorSelectionWidget extends StatefulWidget {
  final Function(List<String>) onColorsSelected;

  const ColorSelectionWidget({Key? key, required this.onColorsSelected}) : super(key: key);

  @override
  _ColorSelectionWidgetState createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<ColorSelectionWidget> {
  List<String> selectedColors = [];

  final List<String> colors = ['Red', 'Blue', 'Green', 'Custom RAL colors','Yellow', 'Black', 'White','Chambagne','Silver','Bronze',
  'Grey','Brown','Gold','Wood grain finishes',];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Colors:',style: AppTextStyles.body(context),),
        SizedBox(height: 8,),
        Wrap(
          spacing: 8.0,
          children: colors.map((color) => FilterChip(
            label: Text(color),
            selected: selectedColors.contains(color),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedColors.add(color);
                } else {
                  selectedColors.remove(color);
                }
              });
              widget.onColorsSelected(selectedColors);
            },
          )).toList(),
        ),
      ],
    );
  }
}