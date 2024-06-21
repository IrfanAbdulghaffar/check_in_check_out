import 'package:check_in_check_out/common/widget/custom_app_bar.dart';
import 'package:check_in_check_out/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RecordsScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance Records',
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('attendance')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Group records by student ID and date
          Map<String, Map<String, DocumentSnapshot>> records = {};

          snapshot.data!.docs.forEach((record) {
            String studentId = record['studentId'];
            String date = record['date'];

            if (!records.containsKey(studentId)) {
              records[studentId] = {};
            }
            records[studentId]![date] = record;
          });

          // Flatten the records for the ListView
          List<Map<String, dynamic>> flattenedRecords = [];
          records.forEach((studentId, dates) {
            dates.forEach((date, record) {
              var recordData = record.data() as Map<String, dynamic>;
              flattenedRecords.add({
                'studentId': studentId,
                'date': date,
                'checkIn': recordData['checkIn'],
                'checkOut': recordData.containsKey('checkOut') ? recordData['checkOut'] : null,
              });
            });
          });

          // Display records
          return ListView.builder(
            itemCount: flattenedRecords.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> record = flattenedRecords[index];
              String studentId = record['studentId'];
              String date = record['date'];
              DateTime checkInTime = (record['checkIn'] as Timestamp).toDate();
              DateTime? checkOutTime = record['checkOut'] != null ? (record['checkOut'] as Timestamp).toDate() : null;
              Duration? duration = checkOutTime != null ? checkOutTime.difference(checkInTime) : null;

              String formattedCheckInTime = DateFormat('h:mm a').format(checkInTime);
              String? formattedCheckOutTime = checkOutTime != null ? DateFormat('h:mm a').format(checkOutTime) : null;
              String? formattedDuration = duration != null ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}m' : null;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.primary),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  title: Text('Date: $date',style: TextStyle(color: ColorConstants.primary,fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in: $formattedCheckInTime'),
                      if (formattedCheckOutTime != null) Text('Check-out: $formattedCheckOutTime'),
                      if (formattedDuration != null) Text('Duration: $formattedDuration'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
