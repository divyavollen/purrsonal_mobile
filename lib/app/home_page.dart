import 'package:flutter/material.dart';
import 'package:workspace/app/app_body.dart';
import 'package:workspace/app/app_drawer.dart';
import 'package:workspace/pets/pet_form.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<AppBodyState> _appBodyKey = GlobalKey<AppBodyState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('Home'),
      ),

      drawer: AppDrawer(),

      body: AppBody(key: _appBodyKey),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => PetForm(),
            barrierDismissible: false,
            useSafeArea: false,
          );
        },
      ),
    );
  }
}
