import 'package:flutter/material.dart';


import '../../../functions/colors.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import 'send.dart';


class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
              child: Column(
            children: [
              Container(
                height: 15,
              ),
              CustomText(
                "GESTION DE MESSAGE",
                tex: 1.25,
                color: gris(),
                fontWeight: FontWeight.w600,
              ),
              Container(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                  ),
                  Expanded(
                    child: Divider(
                      color: gris(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.person,
                      color: gris(),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: gris(),
                    ),
                  ),
                  Container(
                    width: 40,
                  ),
                ],
              ),
              
              Container(
                height: 50,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardMenu(
                          "assets/images/nt.png",
                          "Envoi de Note",
                          const EnvoiPage(
                            x: 0,
                          )),
                      cardMenu(
                          "assets/images/calendar.png",
                          "Emploi du temps",
                          const EnvoiPage(
                            x: 1,
                          )),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardMenu(
                          "assets/images/invitation.png",
                          "Envoi de Convocation",
                          const EnvoiPage(
                            x: 2,
                          )),
                      cardMenu(
                          "assets/images/await.png",
                          "Retards & Absences",
                          const EnvoiPage(
                            x: 3,
                          )),
                    ],
                  )
                ],
              )
            ],
          ))),
    );
  }

  cardMenu(String chemin, String option, Widget x) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
          );
        },
        child: Column(
          children: [
            Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Image.asset(chemin,color: noir(),),
              ),
            ),
            CustomText(
              option,
              tex: 1.1,
              color: noir(),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
