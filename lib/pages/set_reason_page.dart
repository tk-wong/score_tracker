import 'package:flutter/material.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/main.dart';

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
      appBar: AppBar(
        title: Text('Set Default Reasons'),
      ),
      body: StreamBuilder(stream: _reasonController.getAllReasons(), builder: (context, snapshot) {
        if (snapshot.hasData) {
          final reasons = snapshot.data!;
          return ListView.builder(
            itemCount: reasons.length,
            itemBuilder: (context, index) {
              final reason = reasons[index];
              return ListTile(
                title: Text(reason.label),
                // subtitle: Text(reason.delta.toString()),
                trailing: Text(reason.delta.toString(), style: TextStyle(
                  fontSize: 16,
                  color: reason.delta >= 0 ? Colors.green : Colors.red,
                ),),
                
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      })
    );
  }
}