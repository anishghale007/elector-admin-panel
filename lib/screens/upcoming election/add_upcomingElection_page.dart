// ignore_for_file: use_build_context_synchronously

import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/upcoming_election_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddUpcomingElectionPage extends StatefulWidget {
  const AddUpcomingElectionPage({super.key});

  @override
  State<AddUpcomingElectionPage> createState() =>
      _AddUpcomingElectionPageState();
}

class _AddUpcomingElectionPageState extends State<AddUpcomingElectionPage> {
  final candidateController = TextEditingController();
  final startTimeController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String _selectedElection = "";
  String _selectedMonth = "";
  String _selectedDay = "";

  var election = ['Federal Election', 'Provincial Election'];
  var month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var day = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  var firstDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        firstDate = args.value;
        _selectedDate = DateFormat("MMM d, yyyy").format(firstDate);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimeController.text = "";
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
                          SizedBox(
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
                            "Upcoming Election Form",
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
                              value: election,
                              child: Text(election),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedElection = "$newValue";
                            });
                          }),
                      const SizedBox(height: 15),
                      DropdownButtonFormField(
                          value:
                              _selectedMonth.isNotEmpty ? _selectedMonth : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select the month';
                            }
                            return null;
                          },
                          hint: const Text(
                            "Select Month",
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
                          items: month.map((String election) {
                            return DropdownMenuItem(
                              value: election,
                              child: Text(election),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedMonth = "$newValue";
                            });
                          }),
                      const SizedBox(height: 15),
                      DropdownButtonFormField(
                          value: _selectedDay.isNotEmpty ? _selectedDay : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select the day';
                            }
                            return null;
                          },
                          hint: const Text(
                            "Select Day",
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
                          items: day.map((String election) {
                            return DropdownMenuItem(
                              value: election,
                              child: Text(election),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDay = "$newValue";
                            });
                          }),
                      const SizedBox(
                        height: 20,
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
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final response = await ref
                                .read(upcomingProvider)
                                .addUpcomingElectionPost(
                                  electionType: _selectedElection,
                                  startDate: _selectedDate,
                                  startTime: startTimeController.text,
                                  month: _selectedMonth,
                                  day: _selectedDay,
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
                            "Add Upcoming Election",
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
