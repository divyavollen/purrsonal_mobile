import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 10, left: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/paw.png',
                  height: 80,
                ),

                SizedBox(width: 10),

                Text(
                  'Purrsonal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 35.0),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
