import 'package:capstone/Pages/graph.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './tasks.dart';
import '../APIs/apis.dart';
import 'graph.dart';

class Lists extends StatelessWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[50]),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Just do it',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.blue[800],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              const DefaultLists(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Text(
                  'My Lists',
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: Colors.blue[800]),
                ),
              ),
              CustomLists(),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultLists extends StatelessWidget {
  const DefaultLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  // padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(0, 0),
                            blurRadius: 1),
                      ]),
                  child: const ListTile(
                    trailing: Icon(
                      Icons.all_inclusive,
                      color: Colors.black,
                    ),
                    title: Text(
                      'All tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  // padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(0, 0),
                            blurRadius: 1),
                      ]),
                  child: const ListTile(
                    trailing: Icon(
                      Icons.priority_high_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Important',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, offset: Offset(0, 0), blurRadius: 1),
                ]),
            child: const ListTile(
              trailing: Icon(
                Icons.done_all_rounded,
                color: Colors.green,
              ),
              title: Text(
                'Completed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLists extends StatefulWidget {
  var newTaskController = TextEditingController();
  CustomLists({Key? key}) : super(key: key);

  @override
  State<CustomLists> createState() => _CustomListsState();
}

class _CustomListsState extends State<CustomLists> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.white, offset: Offset(0, 0), blurRadius: 1),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder(
                  stream:
                      db.collection(userName!).doc('customTasks').snapshots(),
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
                      List list;
                      return FutureBuilder(
                          future: db.collection(userName!).doc('customTasks').get(),
                          builder: (context, snapshot){
                        if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return Center(
                                child: Text(
                                  'Loading..',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                            );
                          }
                        else if(snapshot.hasError)
                          {
                            return Center(
                              child: Text(
                                'Something went wrong',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                        else
                          {
                            List list = snapshot.data!.data()!['Tasks'];
                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskList(type: list[i])));
                                  },
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.list,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      list[i],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: ()async{
                                        list.remove(list[i]);
                                        await db
                                            .collection(userName!)
                                            .doc('customTasks')
                                            .update({'Tasks': list});
                                      },
                                    ),
                                  ),

                                );
                              },
                            );
                          }
                      });
                    }
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.library_books_rounded,
                      color: Colors.blue,
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.push((context),
                      MaterialPageRoute(builder: (context)=>Productivity()));
                    }, child: Text('Analyze Productivity')),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      widget.newTaskController.text = text;
                                    });
                                  },
                                  controller: widget.newTaskController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add a new list',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white,)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue,)
                                    ),
                                  ),
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () async {
                                        setState(() {});
                                        var data;
                                        await db
                                            .collection(userName!)
                                            .doc('customTasks')
                                            .get()
                                            .then((doc) {
                                          data = doc.data();
                                          return data;
                                        }).then((data) => data['Tasks'].add(
                                                widget.newTaskController.text));

                                        await db
                                            .collection(userName!)
                                            .doc('customTasks')
                                            .update({'Tasks': data['Tasks']});

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'))
                                ],
                              ));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
