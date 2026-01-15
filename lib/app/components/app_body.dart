import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/pet_tile.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  late PetDatabase petDb;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    final Box<Pet> petBox = Hive.box<Pet>('pets');
    petDb = PetDatabase(petBox);
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 18),

              Text(
                'Your Pets',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              SizedBox(width: 8),

              Icon(FontAwesomeIcons.paw, size: 18),
            ],
          ),

          ValueListenableBuilder(
            valueListenable: Hive.box<Pet>('pets').listenable(),
            builder: (BuildContext context, Box<Pet> box, Widget? child) {
              final currentPets = box.values.toList();
              return PetTile(
                petList: currentPets,
                scrollController: _scrollController,
                onLongPress: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }
}
