import 'package:provider/provider.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/Auth%20Pages/login_page.dart';
import 'package:keralatour/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keralatour/pallete.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool checkedValue = false;
  bool register = true;
  List textfieldsStrings = [
    "", //firstName
    "", //lastName
    "", //email
    "", //password
    "", //confirmPassword
  ];
  // final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _firstnamekey = GlobalKey<FormState>();
  final _lastNamekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  //TextEditingController  _addressController = TextEditingController();

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
                            'Sign ',
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: size.height * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'up',
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
                            'Create an Account',
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
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                      ),
                      buildTextField(
                        "First Name",
                        Icons.person_outlined,
                        false,
                        size,
                        (valuename) {
                          if (valuename.length <= 2) {
                            buildSnackError(
                              'Invalid Name',
                              context,
                              size,
                            );
                            return '';
                          }
                          if (!RegExp(r"^[a-zA-Z]").hasMatch(valuename)) {
                            buildSnackError(
                              'Invalid Name',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        },
                        _firstnamekey,
                        0,
                        _nameController,
                        isDarkMode,
                      ),
                      buildTextField(
                        "Last Name",
                        Icons.person_outlined,
                        false,
                        size,
                        (valuesurname) {
                          if (valuesurname.length <= 2) {
                            buildSnackError(
                              'Invalid last name',
                              context,
                              size,
                            );
                            return '';
                          }
                          if (!RegExp(r"^[a-zA-Z]").hasMatch(valuesurname)) {
                            buildSnackError(
                              'Invalid last name',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        },
                        _lastNamekey,
                        1,
                        _lastController,
                        isDarkMode,
                      ),
                      Form(
                        child: buildTextField(
                          "Email",
                          Icons.email_outlined,
                          false,
                          size,
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
                          },
                          _emailKey,
                          2,
                          _emailController,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Passsword",
                          Icons.lock_outline,
                          true,
                          size,
                          (valuepassword) {
                            if (valuepassword.length < 6) {
                              buildSnackError(
                                'Invalid password',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _passwordKey,
                          3,
                          _passwordController,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Confirm Passsword",
                          Icons.lock_outline,
                          true,
                          size,
                          (valuepassword) {
                            if (valuepassword != textfieldsStrings[3]) {
                              buildSnackError(
                                'Passwords must match',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _confirmPasswordKey,
                          4,
                          _confirmpasswordController,
                          isDarkMode,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.01,
                        ),
                        child: CheckboxListTile(
                          title: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "By creating an account, you agree to our ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // ignore: avoid_print
                                      print('Conditions of Use');
                                    },
                                    child: Text(
                                      "Conditions of Use",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration: TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // ignore: avoid_print
                                      print('Privacy Notice');
                                    },
                                    child: Text(
                                      "Privacy Notice",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration: TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          activeColor: Pallete.green,
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: ButtonWidget(
                            text: "Register",
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
                              if (_firstnamekey.currentState!.validate()) {
                                if (_lastNamekey.currentState!.validate()) {
                                  if (_emailKey.currentState!.validate()) {
                                    print(_emailKey.toString());
                                    if (_passwordKey.currentState!.validate()) {
                                      if (_confirmPasswordKey.currentState!
                                          .validate()) {
                                        if (checkedValue == false) {
                                          buildSnackError(
                                              'Accept our Privacy Policy and Term Of Use',
                                              context,
                                              size);
                                        } else {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .userRegistration(
                                                  email: _emailController.text,
                                                  name: _nameController.text,
                                                  lastName:
                                                      _lastController.text,
                                                  password:
                                                      _passwordController.text,
                                                  context: context);
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
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
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  }),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Color(0xffEEA4CE),
                                            Color(0xffC58BF2),
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                            0.0,
                                            0.0,
                                            200.0,
                                            70.0,
                                          ),
                                        ),
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
    TextEditingController controller,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.09,
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
              onChanged: (value) {
                setState(() {
                  textfieldsStrings[stringToEdit] = value;
                });
              },
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
