import 'package:flutter/material.dart';
import 'package:workspace/models/hive/pet.dart';

class PetDetail extends StatelessWidget {
  final List<Pet> pets;
  final int index;

  const PetDetail({super.key, required this.pets, required this.index});

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // height: screenHeight * petDetailHeightMult,
      // width: screenWidth * 0.9,
      // alignment: Alignment.center,
      // padding: EdgeInsets.only(left: 8),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).scaffoldBackgroundColor,

      //   borderRadius: brMedium,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.2),
      //       blurRadius: 10,
      //       spreadRadius: 1,
      //       offset: Offset(0, 0),
      //       blurStyle: BlurStyle.outer,
      //     ),
      //   ],
      // ),
      // child: Row(
      //   children: [
      //     Text(
      //       pets[index].name,
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ],
      // ),
    );
  }
}
