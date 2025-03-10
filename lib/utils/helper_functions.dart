import 'package:flutter/material.dart';
import 'color_constants.dart';

class HelperFunctions {
  static bool isValidPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$';
    RegExp regex = RegExp(pattern);
    if (!(value.contains(regex))) {
      return false;
    } else {
      return true;
    }
  }

  static bool isValidEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

    RegExp regex = RegExp(pattern);
    if (!(value.contains(regex))) {
      return false;
    } else {
      return true;
    }
  }

  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }


  static showAlert({
    required BuildContext context,
    String heading = "",
    String headingString = "",
    String description = "",
    String btnDoneText = "",
    String btnCancelText = "",
    String imageurl = "",
    double headingsize = 0.0,
    bool isMessage = false,
    bool isDissmissOnTapAround = true,
    VoidCallback? onDone,
    VoidCallback? onCancel,
  }) {
    Widget doneButton = btnDoneText == ""
        ? Container()
        : Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if(onDone!=null){
                  onDone();
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.01),
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.0155),
                decoration: BoxDecoration(
                  color: ColorConstants.primary,
                  border: Border.all(
                      color: ColorConstants.primary),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                ),
                child: Text(
                  btnDoneText.toUpperCase(),
                  style: TextStyle(
                    color: ColorConstants.white,
                    fontFamily: 'PoppinsMedium',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );

    Widget cancelButton = btnCancelText == ""
        ? Container()
        : Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if(onCancel!=null){
                  onCancel();
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.01),
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.0155),
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  border: Border.all(
                      color: ColorConstants.primary),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                ),
                child: Text(
                  btnCancelText.toUpperCase(),
                  style: TextStyle(
                    color: ColorConstants.primary,
                    fontFamily: 'PoppinsMedium',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );

    showDialog(
      barrierDismissible: isDissmissOnTapAround,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.width * 0.04),
            ),
          ),
          content: Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.04,
                  horizontal: MediaQuery.of(context).size.width * 0.08),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageurl == ""
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.04),
                          child: Image.asset(
                            imageurl,
                            height: MediaQuery.of(context).size.width * 0.14,
                            width: MediaQuery.of(context).size.width * 0.14,
                          ),
                        ),
                  heading == ""
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Text(
                            heading,
                            style: TextStyle(
                                fontSize: isMessage
                                    ? MediaQuery.of(context).size.width * 0.04
                                    : headingsize == 0.0
                                        ? MediaQuery.of(context).size.width *
                                            0.055
                                        : headingsize,
                                color: ColorConstants.black,
                                fontFamily: headingsize == 0.0
                                    ? 'PoppinsMedium'
                                    : 'PoppinsRegular',
                                fontWeight: headingsize == 0.0
                                    ? FontWeight.w600
                                    : FontWeight.w300),
                            textAlign: TextAlign.center,
                          )),
                  headingString == ""
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Text(
                            headingString,
                            style: TextStyle(
                                fontSize: isMessage
                                    ? MediaQuery.of(context).size.width * 0.04
                                    : headingsize == 0.0
                                        ? MediaQuery.of(context).size.width *
                                            0.055
                                        : headingsize,
                                color: ColorConstants.black,
                                fontFamily: headingsize == 0.0
                                    ? 'PoppinsMedium'
                                    : 'PoppinsRegular',
                                fontWeight: headingsize == 0.0
                                    ? FontWeight.w600
                                    : FontWeight.w300),
                            textAlign: TextAlign.center,
                          )),
                  description == ""
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.05),
                          child: Text(description,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.038,
                                  color: ColorConstants.grey,
                                  fontFamily: 'PoppinsRegular'),
                              textAlign: TextAlign.center),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: btnCancelText == ""
                            ? MediaQuery.of(context).size.width * 0.04
                            : 0.0),
                    child: Row(
                      children: [
                        cancelButton,
                        doneButton,
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }



  static bool isMobileLayout(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 570;
    if (useMobileLayout) {
      return true;
    } else {
      return false;
    }
  }
}
