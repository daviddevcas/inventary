import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kikis_app/models/auth.dart';
import 'package:kikis_app/providers/auth_provider.dart';
import 'package:kikis_app/services/login_service.dart';
import 'package:kikis_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://as1.ftcdn.net/v2/jpg/04/89/52/56/1000_F_489525623_IIJHFNGgs9iepLpIBRqky7ketVqDuCvZ.jpg'))),
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
    return Expanded(
      child: Container(
        color: const Color.fromARGB(100, 0, 0, 0),
        child: PageView(
          controller: _pageController,
          children: [
            PageOne(
              pageController: _pageController,
              loginService: _loginService,
            ),
            PageTwo(
              pageController: _pageController,
              loginService: _loginService,
            )
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  PageOne({Key? key, required this.pageController, required this.loginService})
      : super(key: key);

  final PageController pageController;
  final LoginService loginService;
  final List<TextEditingController> controllers = List.generate(2, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                        : () {
                            authProvider.changeLoad(true);
                            // loginService
                            //     .login(controllers[0].text, controllers[1].text)
                            //     .then((value) {
                            //   var map = value;
                            //   if (map['succes'] == true) {
                            //     authProvider.auth = map['user'] as Auth;
                            //     Navigator.pushReplacementNamed(
                            //         context, 'admin');
                            //   } else {
                            //     authProvider.changeLoad(false);
                            //   }
                            // });
                            Navigator.pushReplacementNamed(context, 'admin');
                          },
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButtonProvider(
                  text: 'Registrarce',
                  backgroundColor: Colors.blueGrey,
                  function: () {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ))
              ],
            )
          ],
        ),
      )
    ]);
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo(
      {Key? key, required this.pageController, required this.loginService})
      : super(key: key);

  final PageController pageController;
  final LoginService loginService;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const TextFormFieldProvider(
        hintText: 'Nombre',
        iconData: FontAwesomeIcons.user,
      ),
      const TextFormFieldProvider(
        hintText: 'Correo electrónico',
        iconData: Icons.email,
      ),
      const TextFormFieldProvider(
        hintText: 'Contraseña',
        iconData: FontAwesomeIcons.lock,
        obscureText: true,
      ),
      const TextFormFieldProvider(
        hintText: 'Confirmar Contraseña',
        iconData: FontAwesomeIcons.lock,
        obscureText: true,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: TextButtonProvider(
                    text: 'Registrarce',
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
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
            )
          ],
        ),
      )
    ]);
  }
}
