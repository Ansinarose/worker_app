// work_completion_widget.dart
// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class WorkCompletionWidget extends StatefulWidget {
  final Function(String) onTimeSelected;

  const WorkCompletionWidget({Key? key, required this.onTimeSelected}) : super(key: key);

  @override
  _WorkCompletionWidgetState createState() => _WorkCompletionWidgetState();
}

class _WorkCompletionWidgetState extends State<WorkCompletionWidget> {
  String selectedTime = '';

  final List<String> times = ['Up to 10 days', '10 to 20 days', '1 month', 'More than a month'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estimated Work Completion:',style: AppTextStyles.body(context),),
        SizedBox(height: 8,),
        Wrap(
          spacing: 8.0,
          children: times.map((time) => ChoiceChip(
            label: Text(time),
            selected: selectedTime == time,
            onSelected: (selected) {
              setState(() {
                selectedTime = selected ? time : '';
              });
              widget.onTimeSelected(selectedTime);
            },
          )).toList(),
        ),
      ],
    );
  }
}