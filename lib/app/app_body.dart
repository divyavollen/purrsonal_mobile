import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workspace/pets/pet_tile.dart';
import 'package:workspace/provider/pet_provider.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  int _prevCount = 0;

  @override
  void initState() {
    super.initState();
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

          Consumer<PetProvider>(
            builder: (context, value, child) {
              if (value.count > _prevCount) {
                scrollToEnd();
              }
              _prevCount = value.count;

              return PetTile(scrollController: _scrollController);
            },
          ),
        ],
      ),
    );
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
