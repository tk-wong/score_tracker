import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_app/models/score_reason.dart';

class ChangeReasonDialog extends StatefulWidget {
  const ChangeReasonDialog({super.key});

  @override
  State<ChangeReasonDialog> createState() => _ChangeReasonDialogState();
}

enum ScoreChangeType { increase, decrease }
class _ChangeReasonDialogState extends State<ChangeReasonDialog> {
  final TextEditingController _customReasonController = TextEditingController();
  final TextEditingController _customDeltaController = TextEditingController();
  final List<bool> _selectedWeather = <bool>[false, false, true];
  final List<(ScoreChangeType, Icon)> icons = <(ScoreChangeType, Icon)> [
    (ScoreChangeType.increase, Icon(Icons.add)),
    (ScoreChangeType.decrease, Icon(Icons.remove)),
  ];
  Set<ScoreChangeType> selectedIcons = <ScoreChangeType>{ScoreChangeType.increase};
  ScoreReason? _selectedDefault;
  @override
  void dispose() {
    _customReasonController.dispose();
    _customDeltaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("add new default reason"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SizedBox(height: 8),
            TextField(
              controller: _customReasonController,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: 'New reason',
                hintText: 'Example: "Won a game"',
              ),
              onChanged: (String value) {
                if (_selectedDefault != null) {
                  setState(() {
                    _selectedDefault = null;
                  });
                }
              },
            ),
            SegmentedButton<ScoreChangeType>(
              segments: icons
                  .map(
                    (icon) =>
                        ButtonSegment(value: icon.$1, icon: icon.$2),
                  )
                  .toList(),
              // direction: vertical ? Axis.vertical : Axis.horizontal,
              onSelectionChanged: (Set<ScoreChangeType> newSelection) {
              setState(() {
                selectedIcons = newSelection;
              });
              },
              showSelectedIcon: false,
              selected: selectedIcons.isEmpty ? {ScoreChangeType.increase} : {selectedIcons.first},
            ),
            TextField(
              controller: _customDeltaController,
              decoration: InputDecoration(
                labelText: 'New score',
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
          onPressed: null, // TODO: implement submit logic
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
