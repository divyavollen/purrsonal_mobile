import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workspace/app/components/app_dimensions.dart';
import 'package:workspace/util/provider/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
                    fontSize: headerFontSize,
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

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SwitchListTile(
              value: themeProvider.isDarkMode,

              title: Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  const SizedBox(
                    width: 14.0,
                  ),
                  Text('Theme'),
                ],
              ),
              onChanged: (value) =>
                  context.read<ThemeProvider>().updateTheme(value),
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
