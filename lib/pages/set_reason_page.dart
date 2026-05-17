import 'package:flutter/material.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/main.dart';
import 'package:score_app/widgets/change_reason_dialog.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(context: context, builder: (BuildContext context){
            return ChangeReasonDialog();
          },
          );
        },
        child: const Icon(Icons.add),
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
                subtitle: Text("score: ${reason.delta.toString()}", style: TextStyle(
                  fontSize: 16,
                  color: reason.delta >= 0 ? Colors.green : Colors.red,
                ),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit reason
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirmDelete = await showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Delete reason'),
                            content: Text('Are you sure you want to delete ${reason.label} with score ${reason.delta}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                        );
                          if(confirmDelete == true) {
                            _reasonController.deleteReason(reason.id);
                          }
                        },
                    ),
                  ],
                ),
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