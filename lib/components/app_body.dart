import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workspace/components/pet_tile.dart';
import 'package:workspace/models/pet.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10),

                Text(
                  'Your Pets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                SizedBox(width: 8),

                Icon(FontAwesomeIcons.paw, size: 18),
              ],
            ),

            SizedBox(height: 10),

            SizedBox(
              height: screenHeight * 0.28,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 10),
                itemBuilder: (context, index) {
                  return PetTile(
                    pet: Pet(
                      name: 'Pixie',
                      birthday: DateTime(2019, 5, 20),
                      sex: 'M',
                      imagePath: 'assets/images/pexels.jpg',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
