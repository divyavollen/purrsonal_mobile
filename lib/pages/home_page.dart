import 'package:flutter/material.dart';
import 'package:workspace/components/add_pet.dart';
import 'package:workspace/components/app_body.dart';
import 'package:workspace/components/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text(
          'Home',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      drawer: AppDrawer(),

      body: AppBody(),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPet();
            },
          );
        },
      ),
    );
  }
}
