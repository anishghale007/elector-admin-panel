import 'dart:html';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFederalFPTPCandidates extends StatefulWidget {
  @override
  State<AddFederalFPTPCandidates> createState() =>
      _AddFederalFPTPCandidatesState();
}

class _AddFederalFPTPCandidatesState extends State<AddFederalFPTPCandidates> {
  final candidateController = TextEditingController();

  final partyController = TextEditingController();
  final barColorController = TextEditingController();

  final candidateInfoController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String? candidateUrl;
  String? partyUrl;

  uploadCandidateImage() {
    final imageId = DateTime.now().toString();
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs
            .ref()
            .child('federalCandidateImage/$imageId')
            .putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          candidateUrl = downloadUrl;
          print(candidateUrl);
        });
      });
    });
  }

  uploadPartyImage() {
    final imageId = DateTime.now().toString();
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot =
            await fs.ref().child('federalPartyImage/$imageId').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          partyUrl = downloadUrl;
          print(partyUrl);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Form(
          key: _form,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                "assets/images/elector_logo2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Federal FPTP Form",
                            style: GoogleFonts.roboto(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Please fill out the form",
                            style: TextStyle(
                              color: Color(0xFFA4A6B3),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: candidateController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Candidate Name is required';
                          }
                          if (val.length > 30) {
                            return 'No more than 30 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Candidate Name",
                            hintText: "Full Name of the candidate",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: partyController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Name is required';
                          }
                          if (val.length > 30) {
                            return 'No more than 30 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Name",
                            hintText: "Party Name of the candidate",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Bar Color is required';
                          }
                          if (val.length > 15) {
                            return 'No more than 15 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Bar Color (Hex Value)",
                            hintText: "Color Hex Value (eg. 0xFF078787)",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: TextFormField(
                          controller: candidateInfoController,
                          expands: true,
                          maxLines: null,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Candidate Info is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Candidate Info",
                              hintText: "Personal Info of the candidate",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Candidate Profile Picture",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          uploadCandidateImage();
                        },
                        child: Container(
                          height: 300,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: candidateUrl == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please upload the candidate profile picture',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 280,
                                        width: 400,
                                        child: Image.network(
                                          candidateUrl!,
                                          fit: BoxFit.contain,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Candidate Party Picture",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          uploadPartyImage();
                        },
                        child: Container(
                          height: 300,
                          width: 800,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: partyUrl == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please upload the candidate party picture',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 280,
                                        width: 400,
                                        child: Image.network(
                                          partyUrl!,
                                          fit: BoxFit.contain,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final response = await ref
                                .read(federalProvider)
                                .addFPTPPost(
                                  candidateName:
                                      candidateController.text.toString(),
                                  partyName: partyController.text.toString(),
                                  barColor: barColorController.text.toString(),
                                  candidateInfo:
                                      candidateInfoController.text.toString(),
                                  imageUrl: candidateUrl!,
                                  partyUrl: partyUrl!,
                                );
                            if (response == 'Success') {
                              Navigator.of(context).pop();
                            } else if (response ==
                                'Barcolor is already taken') {
                              Get.dialog(AlertDialog(
                                title: Text('Bar Color already taken'),
                                content: Text(
                                    'Enter new bar color to avoid any confusion'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close')),
                                ],
                              ));
                            } else {
                              Get.showSnackbar(GetSnackBar(
                                duration: Duration(seconds: 5),
                                title: 'Some error occurred',
                                message: response,
                              ));
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF3C19C0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "Add Candidate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
