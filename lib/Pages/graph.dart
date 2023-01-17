import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone/APIs/apis.dart';

Map<String, dynamic>? count;
var countRef = db.collection(userName!).doc('count of tasks').get();

class Productivity extends StatelessWidget {
  const Productivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: Colors.white, offset: Offset(0, 0), blurRadius: 1),
              ]),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.blue[800],
                        )),
                    Text(
                      'Productivity',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 300,),
                FutureBuilder(
                    future: countRef, builder: (context, snapshot) {
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
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('The tasks ratio on Mondays: ${snapshot.data!.data()!['Monday']}/${snapshot.data!.data()!['Total tasks']}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.blue[800]
                                ),),
                                Text('The tasks ratio on Tuesdays: ${snapshot.data!.data()!['Tuesday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                                Text('The tasks ratio on Wednesdays: ${snapshot.data!.data()!['Wednesday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                                Text('The tasks ratio on Thursdays: ${snapshot.data!.data()!['Thursday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                                Text('The tasks ratio on Fridays: ${snapshot.data!.data()!['Friday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                                Text('The tasks ratio on Saturdays: ${snapshot.data!.data()!['Saturday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                                Text('The tasks ratio on Sundays: ${snapshot.data!.data()!['Sunday']}/${snapshot.data!.data()!['Total tasks']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.blue[800]
                                  ),),
                              ],
                            ),
                          );
                        }
                }),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
