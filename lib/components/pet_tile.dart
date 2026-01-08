import 'package:flutter/material.dart';
import 'package:workspace/models/pet.dart';

class PetTile extends StatelessWidget {
  final Pet? pet;
  final int? index;
  final Function(int)? onDelete;
  final bool isEmpty;

  const PetTile({
    super.key,
    required this.pet,
    required this.index,
    required this.onDelete,
  }) : isEmpty = false;

  const PetTile.empty({super.key})
    : pet = null,
      index = null,
      onDelete = null,
      isEmpty = true;

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

          child: isEmpty ? _buildEmptyState() : _buildPetState(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ImageIcon(
            AssetImage('assets/images/pets.png'),
            size: 50,
            color: Color.fromARGB(255, 122, 180, 214),
          ),
          const SizedBox(height: 15),
          const Text(
            "No furry friends yet!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add your first pet to see them here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetState() {
    bool hasNoImage = pet!.imagePath == null || pet!.imagePath!.trim().isEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: pet?.gender == 'M'
                    ? const Color.fromARGB(255, 122, 180, 214)
                    : const Color.fromRGBO(225, 115, 140, 1),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(100),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: hasNoImage
                      ? Color.fromARGB(255, 222, 229, 233)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: hasNoImage
                    ? const Icon(
                        Icons.image_not_supported,
                        size: 90,
                        color: Color.fromARGB(255, 122, 180, 214),
                      )
                    : Image.asset(
                        pet!.imagePath!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          child: Row(
            children: [
              pet?.gender == 'M'
                  ? Icon(
                      Icons.male,
                      color: const Color.fromARGB(255, 122, 180, 214),
                    )
                  : Icon(
                      Icons.female,
                      color: const Color.fromRGBO(225, 115, 140, 1),
                    ),

              const SizedBox(width: 3),

              Text(pet!.name),

              Spacer(),

              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 199, 78, 78),
                ),
                onPressed: () {
                  onDelete?.call(index!);
                },
                splashColor: const Color.fromARGB(255, 163, 59, 59),
                hoverColor: const Color.fromARGB(255, 163, 59, 59),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
