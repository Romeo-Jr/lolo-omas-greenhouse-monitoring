
import 'package:flutter/material.dart';
import 'package:lo_omas_app/widget/main_page/table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key,});
  
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
      final Stream<QuerySnapshot> _conditionsStream = FirebaseFirestore.instance
                                                        .collection('conditions')
                                                        .orderBy('date_time', descending: true)
                                                        .limit(1)
                                                        .snapshots();

    return Column(
      children: <Widget>[
        const ConditionsTableData(),
        StreamBuilder<QuerySnapshot>(
          stream: _conditionsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LinearProgressIndicator(),
              );
            }

            return SizedBox(
              height: 300,
              child: 
                ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    DateFormat dateFormat = DateFormat("EEEE, MMMM d, yyyy");
                    DateFormat timeFormat = DateFormat('h:mm a');

                    Timestamp documentTimestamp = data['date_time'];
                    DateTime toDate = documentTimestamp.toDate();
                    
                    String formattedDate = dateFormat.format(toDate);
                    String formattedTime = timeFormat.format(toDate);

                  
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Text(formattedTime, style: GoogleFonts.poppins(fontSize: 20),),
                          Text(formattedDate, style: GoogleFonts.poppins(fontSize: 20),),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget> [
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:  const EdgeInsets.symmetric(vertical: 10),
                                      child: Text("Soil Moisture",
                                        style: GoogleFonts.poppins(fontSize: 15,)
                                        ),
                                    ),

                                    Text('${data['soil_moisture'].toString()} %',
                                      style: GoogleFonts.poppins(fontSize: 25),  
                                    ),
                                ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:  const EdgeInsets.symmetric(vertical: 10),
                                      child: Text("Temperature",
                                        style: GoogleFonts.poppins(fontSize: 15,)
                                        ),
                                    ),

                                    Text('${data['temperature'].toString()} °C',
                                      style: GoogleFonts.poppins(fontSize: 25),
                                    ),
                                ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget> [
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:  const EdgeInsets.symmetric(vertical: 10),
                                      child: Text("Humidity",
                                        style: GoogleFonts.poppins(fontSize: 15,)
                                        ),
                                    ),

                                    Text('${data['humidity'].toString()} %',
                                      style: GoogleFonts.poppins(fontSize: 25),
                                    ),
                                ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:  const EdgeInsets.symmetric(vertical: 10),
                                      child: Text("Ph",
                                        style: GoogleFonts.poppins(fontSize: 15,)
                                        ),
                                    ),

                                    Text(data['ph'].toString(),
                                      style: GoogleFonts.poppins(fontSize: 25),
                                    ),
                                ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),   
                    );
                  })
                  .toList()
                  .cast(),
                ),
            );
          },
        ),
      ],
    );
  }
}
