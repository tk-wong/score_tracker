import 'package:flutter/material.dart';
import 'package:score_app/models/score_reason.dart';

class DeleteReasonDialog extends StatelessWidget {
  const DeleteReasonDialog({
    super.key,
    required this.reason,
    required this.deltaString,
  });

  final ScoreReason reason;
  final String deltaString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete reason'),
      content: Text(
        'Are you sure you want to delete ${reason.label} with score $deltaString?',
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(true),
          child: Text('Delete'),
        ),
      ],
    );
  }
}