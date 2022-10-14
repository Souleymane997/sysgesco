import 'package:flutter/material.dart';
import '../../../functions/custom_text.dart';
import '../../../functions/slidepage.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isHidden = true;
  late int choix;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal.shade100,
        body: SafeArea(
          child: SingleChildScrollView(child: loginContainer()),
        ),
      ),
    );
  }

  Widget loginContainer() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7.5,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain,
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: CustomText(
                ' SYSGESCO ',
                tex: TailleText(context).titre * 1.8,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          onChanged: (value) {},
                          controller: userController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return " entrer un identifiant !! ";
                            }
                            return null;
                          },
                          maxLines: 1,
                          onSaved: (onSavedval) {
                            userController.text = onSavedval!;
                          },
                          style: const TextStyle(color: Colors.teal),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0))),
                              hintText: "identifiant",
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.teal,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0)))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLines: 1,
                          controller: passwordController,
                          onSaved: (onSavedval) {
                            passwordController.text = onSavedval!;
                          },
                          obscureText: isHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'entrer votre mot de passe SVP !!';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0))),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.teal,
                              ),
                              hintText: 'Mot de passe',
                              suffixIcon: IconButton(
                                color:
                                    (isHidden) ? Colors.blueGrey : Colors.teal,
                                icon: Icon(isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isHidden = !isHidden;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70.0)))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shadowColor: Colors.blueGrey,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            SlideRightRoute(
                                child: const HomePage(),
                                page: const HomePage(),
                                direction: AxisDirection.left),
                          );
                        },
                        child: CustomText("Se connecter",
                            color: Colors.white,
                            tex: TailleText(context).soustitre)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  //* verifie les champs de saisie

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
