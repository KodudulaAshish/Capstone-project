import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../APIs/apis.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  String type;
  TaskList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue[50],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.blue,
                        )),
                    Text(
                      type,
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Tasks(
                type: type,
              ),
              NewTaskField(type: type),
            ],
          )),
    ));
  }
}

class Tasks extends StatefulWidget {
  String type;
  Tasks({Key? key, required this.type}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: StreamBuilder(
          stream: db
              .collection(userName!)
              .doc('customTasks')
              .collection(widget.type)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Loading..',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              );
            } else {
              List myTasks =
                  snapshot.data!.docs.map((e) => toTask(e.data())).toList();
              return ListView.builder(
                  itemCount: myTasks.length,
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 5,
                                offset: Offset(0, 0))
                          ]),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Icon(
                          myTasks[i].imp
                              ? Icons.priority_high_outlined
                              : Icons.task,
                          color: myTasks[i].imp ? Colors.red : Colors.orange,
                        ),
                        title: Text(
                          myTasks[i].name,
                          style: TextStyle(
                            decoration: myTasks[i].done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            db
                                .collection(userName!)
                                .doc('customTasks')
                                .collection(widget.type)
                                .doc(myTasks[i].name)
                                .update(myTasks[i].done ? {"status":"false"} : {"status":"true"});
                            db
                                .collection(userName!)
                                .doc('customTasks')
                                .collection(widget.type)
                                .doc(myTasks[i].name)
                                .update({"time":DateTime.now()});
                            db
                                .collection(userName!)
                                .doc('count of tasks')
                                .update({DateFormat('EEEE').format(myTasks[i].finished.toDate()): FieldValue.increment(1)});
                            db
                                .collection(userName!)
                                .doc('count of tasks')
                                .update({"Total tasks":FieldValue.increment(1)});

                          },
                          onLongPress: (){
                            showDialog(context: context
                                , builder: (context) => AlertDialog(
                                  title: const Text('Do you really want to delete this task?'),
                                  actions: [
                                    OutlinedButton(onPressed: (){
                                      db
                                        .collection(userName!).doc('customTasks').collection(widget.type).doc(myTasks[i].name).delete();
                                      Navigator.pop(context);
                                      db
                                          .collection(userName!)
                                          .doc('count of tasks')
                                          .update({DateFormat('EEEE').format(myTasks[i].finished.toDate()): FieldValue.increment(-1)});
                                      db
                                          .collection(userName!)
                                          .doc('count of tasks')
                                          .update({"Total tasks":FieldValue.increment(-1)});
                                    }, child: const Text('Delete', style: TextStyle(color: Colors.red),)),
                                    OutlinedButton(onPressed:() {Navigator.pop(context);}, child: Text('Cancel'))
                                  ],
                                )
                            );

                          },
                          child: Icon(
                            myTasks[i].done
                                ? Icons.done
                                : Icons.circle_outlined,
                            color: myTasks[i].done ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

class NewTaskField extends StatefulWidget {
  var newTaskController = TextEditingController();
  bool imp = false;
  String type;
  NewTaskField({Key? key, required this.type}) : super(key: key);

  @override
  State<NewTaskField> createState() => _NewTaskFieldState();
}

class _NewTaskFieldState extends State<NewTaskField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: ListTile(
        title: SizedBox(
          width: 70,
          child: TextField(
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Add a new task'),
            controller: widget.newTaskController,
          ),
        ),
        trailing: SizedBox(
          width: 60,
          child: Row(
            children: [
              GestureDetector(
                  child: Icon(Icons.priority_high_outlined,
                      color: widget.imp ? Colors.red : null),
                  onTap: () {
                    setState(() {
                      widget.imp = !widget.imp;
                      print(widget.imp.toString());
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: Icon(Icons.add),
                onTap: () async {
                  await FireStore().add(
                      widget.type,
                      Task(
                          name: widget.newTaskController.text,
                          done: false,
                          imp: widget.imp,
                      finished: null));
                  widget.newTaskController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
