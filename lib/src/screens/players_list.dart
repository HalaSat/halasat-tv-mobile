import 'package:flutter/material.dart';

import '../meta/players.dart';
import '../widgets/player_info_card.dart';

class PlayersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
          players.map((playerInfo) => PlayerInfoCard(playerInfo)).toList(),
    );
  }
}
