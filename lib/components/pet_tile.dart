import 'package:flutter/material.dart';
import 'package:workspace/models/pet.dart';

class PetTile extends StatelessWidget {
  final Pet pet;
  const PetTile({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        double parentWidth = constraints.maxWidth;

        return Container(
          margin: const EdgeInsets.only(right: 30, top: 10),
          width: screenWidth * 0.6,
          height: parentWidth * 0.4,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(217, 234, 243, 0.5),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),

                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: pet.sex == 'M'
                          ? const Color.fromARGB(255, 122, 180, 214)
                          : const Color.fromRGBO(225, 115, 140, 1),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      pet.imagePath,
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 12.0),

                child: Row(
                  children: [
                    const SizedBox(width: 5),

                    pet.sex == 'M'
                        ? Icon(
                            Icons.male,
                            color: const Color.fromARGB(255, 122, 180, 214),
                          )
                        : Icon(
                            Icons.female,
                            color: const Color.fromRGBO(225, 115, 140, 1),
                          ),

                    const SizedBox(width: 5),

                    Text(pet.name),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
