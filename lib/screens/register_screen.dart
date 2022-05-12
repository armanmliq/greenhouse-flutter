import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/screens/login_screen.dart';
import 'package:greenhouse/services/auth.dart';
import '../anmition/fadeanimation.dart';
import 'package:provider/provider.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

enum Gender { fullname, Email, password, confirmpassword, phone }

class Singup extends StatefulWidget {
  const Singup({Key? key}) : super(key: key);

  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  void _showSuccessDialog(BuildContext context) {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _usernameController.clear();
    Navigator.of(context).pop(true);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Success'),
        content: const Text('Your Account Already Registered'),
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

  Color enabled = const Color(0xFF827F8A);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  bool isConfirmPasswordev = true;
  bool _isLoading = false;
  Gender? selected;
  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
  };
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    //check pasword with confirm password
    if (_passwordController.text != _passwordController.text) {
      return;
    }

    //save
    _formKey.currentState!.save();

    //store from controller to variable
    _authData['username'] = _usernameController.text;
    _authData['email'] = _emailController.text;
    _authData['password'] = _passwordController.text;
    _authData['confirmPassword'] = _confirmPasswordController.text;

    print(_authData['email']);
    print(_authData['password']);
    print(_authData['username']);

    setState(
      () {
        _isLoading = true;
      },
    );

    //try sign up
    try {
      bool? response = await Provider.of<AuthService>(context, listen: false)
          .signUp(_authData['email'], _authData['password']);
      print('THIS IS RESPONSE ${response!}');
      if (response != false) {
        _showSuccessDialog(context);
      }
    } on FirebaseException catch (error) {
      print('on firebase ${error.toString()}');
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
      _showErrorDialog('on cacth $errorMessage');
    } catch (error) {
      print('on cacth $error');
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0F0A1F),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          child: SizedBox(
            width: we,
            height: he,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: he * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: we * 0.04),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: he * 0.03,
                  ),
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 7.0),
                      child: Text(
                        "Create Account",
                        style: GoogleFonts.heebo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 7.0),
                      child: Text(
                        "Please fill the input below here",
                        style: GoogleFonts.heebo(
                            color: Colors.grey, letterSpacing: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: he * 0.07),
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      width: we * 0.9,
                      height: he * 0.071,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(constant.borderRadius),
                        color: selected == Gender.fullname
                            ? enabled
                            : backgroundColor,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.contains(' ')) {
                            return 'username cannot contain space!';
                          }
                          if (value.isEmpty || value.length < 3) {
                            return 'username too short';
                          }
                          return null;
                        },
                        controller: _usernameController,
                        onTap: () {
                          setState(() {
                            selected = Gender.fullname;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.key,
                            color: selected == Gender.fullname
                                ? enabledtxt
                                : deaible,
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: selected == Gender.fullname
                                ? enabledtxt
                                : deaible,
                          ),
                        ),
                        style: TextStyle(
                            color: selected == Gender.fullname
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
                        color: selected == Gender.Email
                            ? enabled
                            : backgroundColor,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        onTap: () {
                          setState(() {
                            selected = Gender.Email;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 11, right: 3, top: 14, bottom: 14),
                          errorStyle: const TextStyle(fontSize: 9, height: 0.2),
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color:
                                selected == Gender.Email ? enabledtxt : deaible,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color:
                                selected == Gender.Email ? enabledtxt : deaible,
                          ),
                        ),
                        style: TextStyle(
                            color:
                                selected == Gender.Email ? enabledtxt : deaible,
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
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
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
                              onPressed: () =>
                                  setState(() => ispasswordev = !ispasswordev),
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
                    child: Container(
                      width: we * 0.9,
                      height: he * 0.071,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(constant.borderRadius),
                          color: selected == Gender.confirmpassword
                              ? enabled
                              : backgroundColor),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Confirm password is too short!';
                          }
                          if (_passwordController.text != value) {
                            return 'Confirm Password not match';
                          }
                          return null;
                        },
                        onTap: () {
                          setState(() {
                            selected = Gender.confirmpassword;
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
                              color: selected == Gender.confirmpassword
                                  ? enabledtxt
                                  : deaible,
                            ),
                            suffixIcon: IconButton(
                              icon: isConfirmPasswordev
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: selected == Gender.confirmpassword
                                          ? enabledtxt
                                          : deaible,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: selected == Gender.confirmpassword
                                          ? enabledtxt
                                          : deaible,
                                    ),
                              onPressed: () => setState(() =>
                                  isConfirmPasswordev = !isConfirmPasswordev),
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                                color: selected == Gender.confirmpassword
                                    ? enabledtxt
                                    : deaible)),
                        obscureText: isConfirmPasswordev,
                        style: TextStyle(
                          color: selected == Gender.confirmpassword
                              ? enabledtxt
                              : deaible,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: he * 0.02,
                  ),
                  FadeAnimation(
                    delay: 1,
                    child: TextButton.icon(
                      icon: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.add_card,
                              color: Colors.black,
                            ),
                      onPressed: _submit,
                      label: Text(
                        "SIGN UP",
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
                    ),
                  ),
                  SizedBox(height: he * 0.13),
                  FadeAnimation(
                    delay: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have a account?",
                            style: GoogleFonts.heebo(
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          },
                          child: Text("sign in",
                              style: GoogleFonts.heebo(
                                color: const Color.fromARGB(255, 22, 97, 92),
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
        ),
      ),
    );
  }
}
