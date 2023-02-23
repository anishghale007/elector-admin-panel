import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/auth_provider.dart';
import 'package:elector_admin_dashboard/screens/add_candidates_page.dart';
import 'package:elector_admin_dashboard/screens/add_election_page.dart';
import 'package:elector_admin_dashboard/screens/add_voterID_page.dart';
import 'package:elector_admin_dashboard/screens/candidates_page.dart';
import 'package:elector_admin_dashboard/screens/dashboard_page.dart';
import 'package:elector_admin_dashboard/screens/electionStats_page.dart';
import 'package:elector_admin_dashboard/screens/login_screen.dart';
import 'package:elector_admin_dashboard/screens/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              showTooltip: false,
              displayMode: SideMenuDisplayMode.open,
              backgroundColor: secondaryColor,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.grey,
              unselectedTitleTextStyle: const TextStyle(color: Colors.grey),
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/images/elector_logo2.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: Consumer(
              builder: (context, ref, child) {
                return InkWell(
                  onTap: () async {
                    await ref.read(authProvider).signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) => LoginScreen())));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Users',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.account_circle),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Candidates',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Election Stats',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.stacked_bar_chart),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Add Election',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.ballot),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Add Candidates',
                onTap: () {
                  page.jumpToPage(5);
                },
                icon: const Icon(Icons.account_balance),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Add Voter ID',
                icon: Icon(Icons.add),
                onTap: () {
                  page.jumpToPage(6);
                },
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                DashboardPage(),
                UsersPage(),
                CandidatesPage(),
                ElectionStatsPage(),
                AddElectionPage(),
                AddCandidatesPage(),
                AddVoterIDPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
