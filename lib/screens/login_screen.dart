import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/providers/auth_provider.dart';
import 'package:kikis_app/services/login_service.dart';
import 'package:kikis_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(children: [const LeftPart(), RightPart()]),
    );
  }
}

class LeftPart extends StatelessWidget {
  const LeftPart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Stack(fit: StackFit.expand, children: [
        CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/inventario-24e0c.appspot.com/o/background.jpg?alt=media&token=379049c9-046e-4e05-afa8-cdb5b24baf48',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(145, 33, 149, 243),
            Color.fromARGB(95, 68, 137, 255)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
        Center(
          child: Text(
            'Bienvenido\na\nInventario',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 100),
          ),
        )
      ]),
    );
  }
}

class RightPart extends StatelessWidget {
  RightPart({
    Key? key,
  }) : super(key: key);

  final PageController _pageController = PageController();
  final LoginService _loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color.fromARGB(146, 0, 62, 121),
            child: PageView(
              controller: _pageController,
              children: [
                PageOne(
                  pageController: _pageController,
                  loginService: _loginService,
                  authProvider: authProvider,
                ),
                PageTwo(
                  pageController: _pageController,
                  loginService: _loginService,
                  authProvider: authProvider,
                )
              ],
            ),
          ),
          if (authProvider.inLoad)
            Container(
                color: const Color.fromARGB(100, 255, 255, 255),
                child: const Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  PageOne(
      {Key? key,
      required this.pageController,
      required this.loginService,
      required this.authProvider})
      : super(key: key);

  final PageController pageController;
  final LoginService loginService;
  final AuthProvider authProvider;
  final List<TextEditingController> controllers = List.generate(2, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextFormFieldProvider(
        hintText: 'Correo electrónico',
        iconData: Icons.email,
        controller: controllers[0],
      ),
      TextFormFieldProvider(
        hintText: 'Contraseña',
        iconData: FontAwesomeIcons.lock,
        controller: controllers[1],
        obscureText: true,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButtonProvider(
                    text: 'Iniciar sesión',
                    function: context.watch<AuthProvider>().inLoad
                        ? null
                        : () async {
                            authProvider.cleanErrorBag();
                            authProvider.changeLoad(true);
                            loginService
                                .login(controllers[0].text, controllers[1].text)
                                .then((value) {
                              var map = value;
                              if (map['success'] == true) {
                                authProvider.auth = map['auth'];
                                adminProvider.refreshUsers();
                                adminProvider.refreshProducts();
                                Navigator.pushReplacementNamed(
                                    context, 'admin');
                              } else {
                                authProvider.errorBag.add(map['msg']);
                                authProvider.changeLoad(false);
                              }
                            });
                          },
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButtonProvider(
                  text: 'Registrarse',
                  backgroundColor: Colors.blueGrey,
                  function: () {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ))
              ],
            ),
            DisplayErrors(authProvider: authProvider)
          ],
        ),
      )
    ]);
  }
}

class PageTwo extends StatelessWidget {
  PageTwo(
      {Key? key,
      required this.pageController,
      required this.loginService,
      required this.authProvider})
      : super(key: key);

  final PageController pageController;
  final LoginService loginService;
  final AuthProvider authProvider;
  final List<TextEditingController> controllers = List.generate(4, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextFormFieldProvider(
        hintText: 'Nombre',
        iconData: FontAwesomeIcons.user,
        controller: controllers[0],
      ),
      TextFormFieldProvider(
        hintText: 'Correo electrónico',
        iconData: Icons.email,
        controller: controllers[1],
      ),
      TextFormFieldProvider(
        hintText: 'Contraseña',
        iconData: FontAwesomeIcons.lock,
        obscureText: true,
        controller: controllers[2],
      ),
      TextFormFieldProvider(
        hintText: 'Confirmar Contraseña',
        iconData: FontAwesomeIcons.lock,
        obscureText: true,
        controller: controllers[3],
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButtonProvider(
                    text: 'Registrarce',
                    function: context.watch<AuthProvider>().inLoad
                        ? null
                        : () {
                            authProvider.cleanErrorBag();
                            authProvider.changeLoad(true);
                            if (controllers[2].text != controllers[3].text &&
                                controllers[2].text != '') {
                              authProvider.errorBag
                                  .add('Las contraseñas no coinciden.');
                              authProvider.changeLoad(false);
                            } else {
                              User user = User(
                                  name: controllers[0].text,
                                  email: controllers[1].text,
                                  status: false);
                              loginService
                                  .register(user, controllers[2].text)
                                  .then((value) {
                                var map = value;
                                if (map['success'] == true) {
                                  Alert(
                                    context: context,
                                    title: "Se ha registrado con éxito",
                                    desc:
                                        "Debe esperar a que se confirme su identidad para poder acceder al sistema.",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                        child: const Text(
                                          "Cerrar",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ).show();
                                  authProvider.changeLoad(false);
                                } else {
                                  authProvider.errorBag.add(map['msg']);
                                  authProvider.changeLoad(false);
                                }
                              });
                            }
                          },
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButtonProvider(
                  text: 'Tengo una cuenta',
                  backgroundColor: Colors.blueGrey,
                  function: () {
                    pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ))
              ],
            ),
            DisplayErrors(authProvider: authProvider)
          ],
        ),
      )
    ]);
  }
}

class DisplayErrors extends StatelessWidget {
  const DisplayErrors({
    Key? key,
    required this.authProvider,
  }) : super(key: key);

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: context.watch<AuthProvider>().errorBag.isNotEmpty ? 200 : 0,
      decoration: BoxDecoration(
          color: const Color.fromARGB(50, 255, 255, 255),
          border:
              Border.all(color: const Color.fromARGB(255, 121, 4, 4), width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: authProvider.errorBag
            .map((error) => Text(
                  "* $error",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 121, 4, 4)),
                ))
            .toList(),
      )),
    );
  }
}
