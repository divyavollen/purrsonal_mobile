import 'package:flutter/material.dart';
import 'package:workspace/app/components/app_body.dart';
import 'package:workspace/app/components/app_drawer.dart';
import 'package:workspace/pets/add_pet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('Home'),
      ),

      drawer: AppDrawer(),

      body: AppBody(),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddPet(),
            barrierDismissible: false,
            useSafeArea: false,
          );
        },
      ),
    );
  }
}
