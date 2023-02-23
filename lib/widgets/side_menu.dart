import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/elector_logo2.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Transaction",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Task",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Documents",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Store",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Notification",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Profile",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
          DrawerListTile(
            title: "Settings",
            icon: Icon(
              Icons.dashboard,
              color: Colors.white54,
              size: 16,
            ),
            onPress: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final Widget icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      horizontalTitleGap: 0.0,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
