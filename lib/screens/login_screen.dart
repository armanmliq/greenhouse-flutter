import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/screens/home_screen.dart';
import '../anmition/fadeanimation.dart';
import 'register_screen.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

enum Gender {
  Email,
  password,
}
enum AuthMode { Login, Signup }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Color enabled = const Color(0xFF827F8A);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  Gender? selected;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('an error occured'),
        content: Text(message),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Okay'))
        ],
      ),
    );
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    print(_authData['email']);
    setState(
      () {
        _isLoading = true;
      },
    );

    try {
      print('pass validate');
      // Log user in
      final response = await AuthService()
          .signIn(_emailController.text, _passwordController.text);
      if (response!.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          PageTransition(
            child: HomeScreen(),
            type: PageTransitionType.leftToRight,
            duration: const Duration(microseconds: 200),
          ),
        );
      }
    } on FirebaseException catch (error) {
      var errorMessage = 'authenticate failed';
      if (error.toString().contains('EMAIL_EXIST')) {
        errorMessage = 'this email already in use';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'this password is to weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'couldnt found the email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'the passwod is invalid';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFF0F0A1F),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            child: SizedBox(
              width: we,
              height: he,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: he * 0.07,
                    ),
                    FadeAnimation(
                      delay: 0.8,
                      child: Image.asset(
                        'assets/images/login_logo.jpg',
                        width: we * 0.8,
                        height: he * 0.25,
                      ),
                    ),
                    SizedBox(
                      height: he * 0.01,
                    ),
                    FadeAnimation(
                      delay: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Agriculture Tech",
                          style: GoogleFonts.heebo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: he * 0.06,
                    ),

                    FadeAnimation(
                      delay: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 230.0),
                        child: Text(
                          "Login",
                          style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: he * 0.002,
                    ),
                    FadeAnimation(
                      delay: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 150.0),
                        child: Text(
                          "Please sign in to continue",
                          style: GoogleFonts.heebo(
                              color: Colors.grey, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: he * 0.04,
                    ),
                    FadeAnimation(
                      delay: 1,
                      child: Container(
                        width: we * 0.9,
                        height: he * 0.071,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(constant.borderRadius),
                          color: selected == Gender.Email
                              ? enabled
                              : backgroundColor,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            print('get value email $value');
                            _authData['email'] = value!;
                          },
                          onTap: () {
                            setState(() {
                              selected = Gender.Email;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 11, right: 3, top: 14, bottom: 14),
                            errorStyle:
                                const TextStyle(fontSize: 9, height: 0.2),
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: selected == Gender.Email
                                  ? enabledtxt
                                  : deaible,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: selected == Gender.Email
                                  ? enabledtxt
                                  : deaible,
                            ),
                          ),
                          style: TextStyle(
                              color: selected == Gender.Email
                                  ? enabledtxt
                                  : deaible,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: he * 0.02,
                    ),
                    FadeAnimation(
                      delay: 1,
                      child: Container(
                        width: we * 0.9,
                        height: he * 0.071,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(constant.borderRadius),
                            color: selected == Gender.password
                                ? enabled
                                : backgroundColor),
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value!;
                          },
                          onTap: () {
                            setState(() {
                              selected = Gender.password;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 11, right: 3, top: 14, bottom: 14),
                              errorStyle:
                                  const TextStyle(fontSize: 9, height: 0.2),
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock_open_outlined,
                                color: selected == Gender.password
                                    ? enabledtxt
                                    : deaible,
                              ),
                              suffixIcon: IconButton(
                                icon: ispasswordev
                                    ? Icon(
                                        Icons.visibility_off,
                                        color: selected == Gender.password
                                            ? enabledtxt
                                            : deaible,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        color: selected == Gender.password
                                            ? enabledtxt
                                            : deaible,
                                      ),
                                onPressed: () => setState(
                                    () => ispasswordev = !ispasswordev),
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: selected == Gender.password
                                      ? enabledtxt
                                      : deaible)),
                          obscureText: ispasswordev,
                          style: TextStyle(
                              color: selected == Gender.password
                                  ? enabledtxt
                                  : deaible,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: he * 0.02,
                    ),
                    FadeAnimation(
                      delay: 1,
                      child: TextButton.icon(
                        onPressed: () {
                          _submit();
                        },
                        label: Text(
                          "Login",
                          style: GoogleFonts.heebo(
                            color: Colors.black,
                            letterSpacing: 0.5,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: constant.bgColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 80),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(constant.borderRadius),
                          ),
                        ),
                        icon: _isLoading
                            ? CircularProgressIndicator(color: Colors.black)
                            : Icon(
                                Icons.login,
                                color: Color.fromARGB(255, 1, 68, 64),
                              ),
                      ),
                    ),

                    // FadeAnimation(
                    //   delay: 1,
                    //   child: Text("Forgot password?",
                    //       style: GoogleFonts.heebo(
                    //         color: const Color(0xFF0DF5E4).withOpacity(0.9),
                    //         letterSpacing: 0.5,
                    //       )),
                    // ),
                    SizedBox(height: he * 0.05),
                    FadeAnimation(
                      delay: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: GoogleFonts.heebo(
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const Singup();
                              }));
                            },
                            child: Text("sign up",
                                style: GoogleFonts.heebo(
                                  color: Color.fromARGB(255, 22, 97, 92)
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
