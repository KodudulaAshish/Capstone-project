import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



var db = FirebaseFirestore.instance;
var userName = FirebaseAuth.instance.currentUser?.email!;

class Task
{
  String name;
  bool done;
  bool imp;
  Timestamp? finished;
  Task({required this.name,required this.done,required this.imp, required this.finished});
}

Map<String, dynamic> toMap(Task x)
{
   Map<String, dynamic> k = {
     'name':x.name,
      'status':x.done.toString(),
     'important':x.imp.toString(),
     'time':x.finished,
   };
   return k;
}

Task toTask(Map<String, dynamic> m)
{
  return Task(
    name: m['name'],
    done: m['status']=="true" ? true : false,
    imp: m['important']=="true" ? true : false,
    finished: m['time'],
  );
}

class FireStore {
  add(String type, Task name) async {
    var newTask = toMap(name);
    await db.collection(userName!).doc('customTasks').collection(type).doc(
        name.name).set(newTask);
  }

}