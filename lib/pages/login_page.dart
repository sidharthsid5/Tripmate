import 'package:provider/provider.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/forgot_password_page.dart';
import 'package:keralatour/pages/register_page.dart';
import 'package:keralatour/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keralatour/pallete.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkedValue = false;
  bool register = true;
  List textfieldsStrings = [
    "", //email
    "", //password
  ];

  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  late final TextEditingController _emailController, _passwordController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign',
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: size.height * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' in',
                            style: GoogleFonts.poppins(
                              color: Pallete.green,
                              fontSize: size.height * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: Align(
                          child: Text(
                            ' ',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff1D1617),
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        child: buildTextField(
                            "Email", Icons.email_outlined, false, size,
                            (valuemail) {
                          if (valuemail.length < 5) {
                            buildSnackError(
                              'Invalid email',
                              context,
                              size,
                            );
                            return '';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                              .hasMatch(valuemail)) {
                            buildSnackError(
                              'Invalid email',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        }, _emailKey, 2, isDarkMode, _emailController),
                      ),
                      Form(
                        child: buildTextField(
                            "Passsword", Icons.lock_outline, true, size,
                            (valuepassword) {
                          if (valuepassword.length < 6) {
                            buildSnackError(
                              // Perform logout logic here
                              // For demonstration purposes, I'll just print a message
                              // print('Logout confirmed');
                              'Invalid password',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        }, _passwordKey, 3, isDarkMode, _passwordController),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.015,
                            vertical: size.height * 0.025,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 143, 134, 135),
                                decoration: TextDecoration.underline,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          )),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                          text: "Login",
                          backColor: isDarkMode
                              ? [
                                  Colors.black,
                                  Colors.black,
                                ]
                              : const [Pallete.green, Pallete.green],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (register) {
                              //validation for login
                              if (_emailKey.currentState!.validate()) {
                                if (_passwordKey.currentState!.validate()) {
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .login(
                                          context: context,
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                }
                              }
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don’t have an account yet? ",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xff1D1617),
                                  fontSize: size.height * 0.018,
                                ),
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () => setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  }),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Color(0xffEEA4CE),
                                            Color(0xffC58BF2),
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                              0.0, 0.0, 200.0, 70.0),
                                        ),
                                      // color: const Color(0xffC58BF2),
                                      fontSize: size.height * 0.018,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool pwVisible = false;
  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    Key key,
    int stringToEdit,
    bool isDarkMode,
    TextEditingController controller,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.1,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Form(
            key: key,
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                  color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
              // onChanged: (value) {
              //   setState(() {
              //     textfieldsStrings[stringToEdit] = value;
              //   });
              // },
              validator: validator,
              textInputAction: TextInputAction.next,
              obscureText: password ? !pwVisible : false,
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0),
                hintStyle: const TextStyle(
                  color: Color(0xffADA4A5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Pallete.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Pallete.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Pallete.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.only(
                  top: size.height * 0.012,
                ),
                hintText: hintText,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.005,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xff7B6F72),
                  ),
                ),
                suffixIcon: password
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pwVisible = !pwVisible;
                            });
                          },
                          child: pwVisible
                              ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Color.fromARGB(255, 80, 72, 72),
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  color: Color.fromARGB(255, 80, 72, 72),
                                ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
