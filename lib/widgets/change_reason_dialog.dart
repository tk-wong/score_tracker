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
  final List<(ScoreChangeType, Icon)> icons = <(ScoreChangeType, Icon)>[
    (ScoreChangeType.increase, Icon(Icons.add)),
    (ScoreChangeType.decrease, Icon(Icons.remove)),
  ];
  Set<ScoreChangeType> selectedIcons = <ScoreChangeType>{
    ScoreChangeType.increase,
  };
  ScoreReason? _selectedDefault;
  bool _isEmptyWhenSubmit = false;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _onFocusChange();
  }

  void _onFocusChange() {
    _focus.addListener(() {
      setState(() {}); // Trigger rebuild to update the UI based on focus change
    });
  }

  @override
  void dispose() {
    _customReasonController.dispose();
    _customDeltaController.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  void _onSubmitForm() async {
    final int customDelta = _customDeltaController.text.trim().isEmpty
        ? 1
        : int.parse(_customDeltaController.text.trim());
    final String customReason = _customReasonController.text.trim();
    if (_selectedDefault == null && customReason.isEmpty) {
      setState(() {
        _isEmptyWhenSubmit = true;
      });
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a default reason.'),
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
        delta: selectedIcons.first == ScoreChangeType.increase
            ? customDelta
            : -customDelta,
      ),
    );
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
              focusNode: _focus,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: 'New reason',
                hintText: 'Example: "Won a game"',
                labelStyle: TextStyle(
                  color: _isEmptyWhenSubmit && !_focus.hasFocus
                      ? Colors.red
                      : Colors.grey,
                ), // Switches color dynamically
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmptyWhenSubmit
                        ? Colors.red
                        : Colors.grey, // Switches color dynamically
                  ),
                ),
              ),
              onChanged: (String value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _isEmptyWhenSubmit =
                        false; // Reset error state when user types
                  });
                }
              },
            ),
            SegmentedButton<ScoreChangeType>(
              segments: icons
                  .map((icon) => ButtonSegment(value: icon.$1, icon: icon.$2))
                  .toList(),
              // direction: vertical ? Axis.vertical : Axis.horizontal,
              onSelectionChanged: (Set<ScoreChangeType> newSelection) {
                setState(() {
                  selectedIcons = newSelection;
                });
              },
              showSelectedIcon: false,
              selected: selectedIcons.isEmpty
                  ? {ScoreChangeType.increase}
                  : {selectedIcons.first},
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
          onPressed: _onSubmitForm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
