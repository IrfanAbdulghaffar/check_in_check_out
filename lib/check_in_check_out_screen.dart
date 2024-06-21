// check_in_check_out_screen.dart
import 'package:check_in_check_out/common/widget/custom_app_bar.dart';
import 'package:check_in_check_out/services/database_service.dart';
import 'package:check_in_check_out/utils/color_constants.dart';
import 'package:check_in_check_out/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'qr_screen.dart';
import 'records_screen.dart';
import 'login_screen.dart';

class CheckInCheckOutScreen extends StatefulWidget {
  @override
  _CheckInCheckOutScreenState createState() => _CheckInCheckOutScreenState();
}

class _CheckInCheckOutScreenState extends State<CheckInCheckOutScreen> {
  final AuthService _auth = AuthService();
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(onPressed: (){},icon: const Icon(Icons.menu,color: Colors.white,),),
        title: "In / Out",
        actionButton: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () async{
              HelperFunctions.showAlert(
                  context: context,
                  heading: "Are you sure you want to logout?",
                  isMessage: true,
                  btnDoneText: "Sure",
                  btnCancelText: "Cancel",
                  onDone: ()async{
                    await _auth.signOut();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false
                    );
                  },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async{
                var result= await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScreen()),
                );
                DatabaseService.recordAttendance(result,context);
              },
              child: Container(
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                      color:Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius:5,
                            color: ColorConstants.primary.withOpacity(1)
                        )
                      ]
                  ),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Image.asset("assets/images/qr-code-scan.png",height:90,),
                    const SizedBox(height: 10,),
                    Text("Attendance",style: TextStyle(color: ColorConstants.primary,fontWeight: FontWeight.bold,fontSize: 18),),
                    const SizedBox(height: 10,),
                  ],
                )),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordsScreen()),
                );
              },
              child: Container(
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                      color:Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius:5,
                            color: ColorConstants.primary.withOpacity(1)
                        )
                      ]
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Image.asset("assets/images/record.png",height:90,),
                      const SizedBox(height: 10,),
                      Text("Record",style: TextStyle(color: ColorConstants.primary,fontWeight: FontWeight.bold,fontSize: 18),),
                      const SizedBox(height: 10,),
                    ],
                  )),
            ),
            // ElevatedButton(
            //   onPressed: () async{
            //     var result= await Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const QRScreen()),
            //     );
            //     DatabaseService.recordAttendance(result,context);
            //   },
            //   child: const Text('Scan QR Code'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => RecordsScreen()),
            //     );
            //   },
            //   child: const Text('View Records'),
            // ),
          ],
        ),
      ),
    );
  }
}
