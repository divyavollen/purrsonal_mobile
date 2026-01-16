import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/pet_tile.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  int _prevCount = 0;
  late Box<Pet> _petBox;

  @override
  void initState() {
    super.initState();
    _petBox = Hive.box<Pet>('pets');
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
    _petBox.listenable().addListener(_handleDatabaseChange);
    _prevCount = _petBox.length;
  }

  @override
  void dispose() {
    _petBox.listenable().removeListener(_handleDatabaseChange);
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
            valueListenable: _petBox.listenable(),
            builder: (BuildContext context, Box<Pet> box, Widget? child) {
              final currentPets = box.values.toList();

              return PetTile(
                petList: currentPets,
                scrollController: _scrollController,
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleDatabaseChange() {
    final int newCount = _petBox.length;

    if (newCount > _prevCount) {
      _prevCount = newCount;
      scrollToEnd();
    } else {
      _prevCount = newCount;
    }
  }

  void scrollToEnd() {
    if (!mounted || !_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          final double target = _scrollController.position.maxScrollExtent;

          _scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        }
      });
    });
  }
}
