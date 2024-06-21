// database_service.dart
import 'package:check_in_check_out/utils/helper_functions.dart';
import 'package:check_in_check_out/utils/shared_pref_instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');


  // Function to record check-in or check-out based on action type and student ID
  static Future<void> recordAttendance(String actionType,BuildContext context) async {
    try {

      // Ensure uid is initialized
      String todayDate = DateTime.now().toString().split(' ')[0];


      if (actionType == 'check in') {
        if(SharedPreference.instance.getData("isCheckIn")==todayDate){
          HelperFunctions.showAlert(
              context: context,
              isMessage: true,
              heading: "You have already check In",
              btnDoneText: "Ok",
          );
        }else{
          await _usersCollection.doc(SharedPreference.instance.getData("id")).collection('attendance').add({
            'studentId': SharedPreference.instance.getData("id"),
            'checkIn': FieldValue.serverTimestamp(),
            'date': todayDate,
          });
          HelperFunctions.showAlert(
              context: context,
              isMessage: true,
              heading: "Check in Successfully",
              btnDoneText: "Ok",
          );
        }
        SharedPreference.instance.setData(key: "isCheckIn",value:todayDate);
      } else if (actionType == 'check out') {
        if(SharedPreference.instance.getData("isCheckIn")==todayDate){
          if(SharedPreference.instance.getData("isCheckOnt")==todayDate){
            HelperFunctions.showAlert(
              context: context,
              isMessage: true,
              heading: "Today, you have already checked out.",
              btnDoneText: "Ok",
            );
          }else{
            QuerySnapshot querySnapshot = await _usersCollection
                .doc(SharedPreference.instance.getData("id"))
                .collection('attendance')
                .where('studentId', isEqualTo: SharedPreference.instance.getData("id"))
                .where('date', isEqualTo: todayDate)
                .limit(1) // Limit to 1 document
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              String recordId = querySnapshot.docs.first.id;
              await _usersCollection
                  .doc(SharedPreference.instance.getData("id"))
                  .collection('attendance')
                  .doc(recordId)
                  .update({
                'checkOut': FieldValue.serverTimestamp(),
              });
              SharedPreference.instance.setData(key: "isCheckOnt",value:todayDate);
              HelperFunctions.showAlert(
                context: context,
                isMessage: true,
                heading: "Check out successfully",
                btnDoneText: "Ok",
              );
            }
          }
        }else{
          HelperFunctions.showAlert(
            context: context,
            isMessage: true,
            heading: "Check in first",
            btnDoneText: "Ok",
          );
        }

      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recording attendance: $e');
      }
    }
  }

  // Function to retrieve attendance records
  static Future<List<Map<String, dynamic>>> getAttendanceRecords() async {
    try {  // Ensure uid is initialized
      QuerySnapshot querySnapshot = await _usersCollection
          .doc(SharedPreference.instance.getData("id"))
          .collection('attendance')
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving attendance records: $e');
      }
      return [];
    }
  }
}
