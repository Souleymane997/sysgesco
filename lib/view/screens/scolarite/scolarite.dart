import 'package:flutter/material.dart';
import 'package:sysgesco/functions/colors.dart';

import '../../../functions/fonctions.dart';
import 'config_sms.dart';
import 'rappel.dart';

class ScolaritePage extends StatefulWidget {
  const ScolaritePage({super.key});

  @override
  State<ScolaritePage> createState() => _ScolaritePageState();
}

class _ScolaritePageState extends State<ScolaritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scolarite"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardMenuRound("Configuration de la Messagerie", Icons.sms,
                    amberFone(), const ConfigSmsPage(), context),
                cardMenuRound("Rappel de la Scolarité", Icons.money, teal(),
                    const RappelPage(), context),
              ],
            ),
            Container(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
