import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/score_reason.dart';

class ReasonDialog extends StatefulWidget {
  const ReasonDialog({
    super.key,
    required this.isIncrease,
    required this.defaultReasons,
  });

  final bool isIncrease;
  final List<ScoreReason> defaultReasons;

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  final TextEditingController _customReasonController = TextEditingController();
  final TextEditingController _customDeltaController = TextEditingController();
  ScoreReason? _selectedDefault;

  @override
  void dispose() {
    _customReasonController.dispose();
    _customDeltaController.dispose();
    super.dispose();
  }

  void _submit() async {
    final int customDelta = _customDeltaController.text.trim().isEmpty
        ? 1
        : int.parse(_customDeltaController.text.trim());
    final String customReason = _customReasonController.text.trim();
    if (_selectedDefault == null && customReason.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Please select a default reason or enter a custom reason.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_selectedDefault != null) {
      Navigator.of(context).pop(_selectedDefault);
      return;
    }

    Navigator.of(context).pop(
      ScoreReason(
        label: customReason,
        delta: widget.isIncrease ? customDelta : -customDelta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isIncrease ? 'Add score reason' : 'Subtract score reason',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Default reasons',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (widget.defaultReasons.isEmpty)
              const Text('No default reasons available for this action.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.defaultReasons.map((ScoreReason reason) {
                  return ChoiceChip(
                    label: Text(
                      '${reason.label} (${reason.delta > 0 ? '+' : ''}${reason.delta})',
                    ),
                    selected: _selectedDefault == reason,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedDefault = selected ? reason : null;
                        if (selected) {
                          _customReasonController.clear();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            const Divider(height: 24),
            TextField(
              controller: _customReasonController,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: 'Custom reason',
                hintText: widget.isIncrease
                    ? 'Example: Helped another team'
                    : 'Example: Missed deadline',
              ),
              onChanged: (String value) {
                if (_selectedDefault != null) {
                  setState(() {
                    _selectedDefault = null;
                  });
                }
              },
            ),
            TextField(
              controller: _customDeltaController,
              decoration: InputDecoration(
                labelText: 'Custom score',
                hintText: 'Example: 2',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            Text(
              'Default is 1 if left empty',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
