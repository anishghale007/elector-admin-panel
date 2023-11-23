import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/ongoingElection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddOngoingElectionPage extends StatefulWidget {
  @override
  State<AddOngoingElectionPage> createState() => _AddOngoingElectionPageState();
}

class _AddOngoingElectionPageState extends State<AddOngoingElectionPage> {
  final candidateController = TextEditingController();
  final startDateController = DateRangePickerController();
  final endDateController = DateRangePickerController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String _selectedDate1 = '';
  String _selectedDate2 = '';
  String _selectedElection = "";

  var election = ['Federal Election', 'Provincial Election'];

  var firstDate;
  var secondDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        firstDate = args.value;
        _selectedDate1 = DateFormat("MMM d, yyyy").format(firstDate);
      }
    });
  }

  void _onSelectionChanged2(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        secondDate = args.value;
        _selectedDate2 = DateFormat("MMM d, yyyy").format(secondDate);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimeController.text = "";
    endTimeController.text = "";
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
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(24),
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
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Ongoing Election Form",
                            style: GoogleFonts.roboto(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
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
                      const SizedBox(
                        height: 40,
                      ),
                      DropdownButtonFormField(
                          value: _selectedElection.isNotEmpty
                              ? _selectedElection
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select election type';
                            }
                            return null;
                          },
                          hint: const Text(
                            "Select Election Type",
                          ),
                          decoration: InputDecoration(
                            fillColor: bgColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          items: election.map((String election) {
                            return DropdownMenuItem(
                              child: Text(election),
                              value: election,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedElection = "$newValue";
                            });
                          }),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: candidateController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Name is required';
                          }
                          if (val.isAlphabetOnly) {
                            return 'Please provide Number only';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Candidates",
                            hintText: "Total No. of candidates",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Starting Date",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                        controller: startDateController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Ending Date",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged2,
                        selectionMode: DateRangePickerSelectionMode.single,
                        controller: endDateController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: startTimeController, //
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please select the time';
                          }
                          return null;
                        }, // edi// ting controller of this TextField
                        decoration: const InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Start Time" //label text of field
                            ),
                        readOnly:
                            true, //se// t it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (pickedTime != null) {
                            //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            //output 1970-01-01 22:53:00.000
                            String formattedTime =
                                DateFormat('HH:mm:ss a').format(parsedTime);
                            //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                            setState(() {
                              startTimeController.text = formattedTime; //
                              // set the value of text field.
                            });
                          } else {}
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: endTimeController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please select the time';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            icon: Icon(Icons.timer),
                            labelText: "Enter End Time"),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (pickedTime != null) {
                            //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            //output 1970-01-01 22:53:00.000
                            String formattedTime =
                                DateFormat('HH:mm:ss a').format(parsedTime);
                            //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                            setState(() {
                              endTimeController.text =
                                  formattedTime; //set the value of text field.
                            });
                          } else {}
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final response = await ref
                                .read(ongoingProvider)
                                .addOngoingElectionPost(
                                  electionType: _selectedElection,
                                  candidates:
                                      candidateController.text.toString(),
                                  startDate: _selectedDate1,
                                  endDate: _selectedDate2,
                                  startTime:
                                      startTimeController.text.toString(),
                                  endTime: endTimeController.text.toString(),
                                );
                            if (response == 'Success') {
                              Navigator.of(context).pop();
                            } else {
                              Get.showSnackbar(GetSnackBar(
                                duration: const Duration(seconds: 5),
                                title: 'Some error occurred',
                                message: response,
                              ));
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C19C0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "Add Ongoing Election",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
