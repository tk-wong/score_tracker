import 'package:flutter/material.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/main.dart';
import 'package:score_app/models/score_reason.dart';
import 'package:score_app/widgets/default_reason_setting/change_reason_dialog.dart';
import 'package:score_app/widgets/default_reason_setting/delete_reason_dialog.dart';

class SetReasonPage extends StatefulWidget {
  const SetReasonPage({super.key});

  @override
  State<SetReasonPage> createState() => _SetReasonPageState();
}

class _SetReasonPageState extends State<SetReasonPage> {
  late final ScoreReasonController _reasonController;
  @override
  void initState() {
    super.initState();
    _reasonController = ScoreReasonController.create(objectBox.store);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Default Reasons')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _handleScoreReason(context: context);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _reasonController.getAllReasons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _formatDefaultReason(snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListView _formatDefaultReason(AsyncSnapshot<List<ScoreReason>> snapshot) {
    final reasons = snapshot.data!;
    return ListView.builder(
      itemCount: reasons.length,
      itemBuilder: (context, index) {
        final reason = reasons[index];
        bool isPositive = reason.delta >= 0;
        final deltaString = isPositive
            ? '+${reason.delta}'
            : reason.delta.toString();
        return ListTile(
          title: Text(reason.label),
          // subtitle: Text(reason.delta.toString()),
          subtitle: Text(
            "score: $deltaString",
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await _handleScoreReason(
                    context: context,
                    reason: reason,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _onDeleteReason(context, reason, deltaString);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onDeleteReason(
    BuildContext context,
    ScoreReason reason,
    String deltaString,
  ) async {
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteReasonDialog(reason: reason, deltaString: deltaString);
      },
    );
    if (confirmDelete == true) {
      _reasonController.deleteReason(reason.id);
    }
  }

  Future<void> _handleScoreReason({
    required BuildContext context,
    ScoreReason? reason,
  }) async {
    final scoreReason = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeReasonDialog(reason: reason);
      },
    );
    if (scoreReason != null) {
      _reasonController.addOrUpdateReason(scoreReason);
    }
  }
}
