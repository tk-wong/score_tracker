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
  final TextEditingController _customScoreController = TextEditingController();
  final List<(ScoreChangeType, Icon)> icons = <(ScoreChangeType, Icon)>[
    (ScoreChangeType.increase, Icon(Icons.add)),
    (ScoreChangeType.decrease, Icon(Icons.remove)),
  ];
  Set<ScoreChangeType> selectedIcons = <ScoreChangeType>{
    ScoreChangeType.increase,
  };
  bool _fieldEmpty = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _customReasonController.addListener(_isAllFieldsNotEmpty);
    _customScoreController.addListener(_isAllFieldsNotEmpty);
  }

  void _isAllFieldsNotEmpty() {
    setState(() {
      _fieldEmpty =
          !(_customReasonController.text.trim().isNotEmpty &&
              _customScoreController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _customScoreController.removeListener(_isAllFieldsNotEmpty);
    _customReasonController.removeListener(_isAllFieldsNotEmpty);
    _customReasonController.dispose();
    _customScoreController.dispose();
    super.dispose();
  }

  void _onSubmitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final int? customScore = int.tryParse(_customScoreController.text.trim());
    final String customReason = _customReasonController.text.trim();
    if (customReason.isEmpty || customScore == null) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a default reason and a valid score.'),
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


    Navigator.of(context).pop(
      ScoreReason(
        label: customReason,
        delta: selectedIcons.first == ScoreChangeType.increase
            ? customScore
            : -customScore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("add new default reason"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _customReasonController,
              maxLength: 60,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter default reason';
                } else if (value.trim().length > 60) {
                  return 'Reason must be at most 60 characters';
                }
                return null;
              },

              decoration: InputDecoration(
                labelText: 'New reason',
                hintText: 'Example: "Won a game"',
                // labelStyle: TextStyle(
                //   color: _isEmptyWhenSubmit && !_focus.hasFocus
                //       ? Colors.red
                //       : Colors.grey,
                // ), // Switches color dynamically
                // enabledBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(
                //     color: _isEmptyWhenSubmit
                //         ? Colors.red
                //         : Colors.grey, // Switches color dynamically
                //   ),
                // ),
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _customScoreController,
              decoration: InputDecoration(
                labelText: 'New score',
                hintText: 'Example: 2',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a score';
                } else if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
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
          onPressed:
              checkValidForm()
              ? _onSubmitForm
              : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  bool checkValidForm() {
    return !_fieldEmpty &&
                _formKey.currentState != null &&
                _formKey.currentState!.validate();
  }
}
