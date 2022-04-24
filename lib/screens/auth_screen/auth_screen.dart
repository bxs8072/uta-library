import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/api/auth.dart';
import 'package:uta_library/screens/auth_screen/components/auth_screen_app_bar.dart';
import 'package:uta_library/screens/auth_screen/form_type.dart';
import 'package:uta_library/screens/auth_screen//tools/validator.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FormType _formType = FormType.login;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _forgetPasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String get _email => _emailController.text.trim().toLowerCase();
  String get _password => _passwordController.text.trim();

  final Auth _auth = Auth();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;

  bool _hideConfirmPassword = true;

  _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  _toggleHideConfirmPassword() {
    setState(() {
      _hideConfirmPassword = !_hideConfirmPassword;
    });
  }

  toggleFormType() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.register : FormType.login;
    });
  }

  _onSubmit() async {
    _formKey.currentState!.save();
    bool _validateForm = _formKey.currentState!.validate();

    if (_validateForm) {
      if (_formType == FormType.login) {
        _auth.login(_email, _password).then((user) {}).catchError((error) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(error),
                );
              });
        });
      } else {
        _auth.register(_email, _password).catchError((error) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(error),
                );
              });
        });
      }
    }
  }

  _onForgetPassword() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: TextFormField(
              controller: _forgetPasswordController,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "xyz1234@mavs.uta.edu",
              ),
              onChanged: (val) {
                setState(() {});
              },
              validator: (val) {
                return Validator(val!).email();
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Validator(_forgetPasswordController.text).email() ==
                      null) {
                    _auth
                        .forgetPassword(
                            _forgetPasswordController.text.trim().toLowerCase())
                        .then((value) {
                      _forgetPasswordController.clear();
                      Fluttertoast.showToast(
                        msg: "Password reset link has been sent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      ).then((value) {
                        Navigator.of(context).pop();
                      });
                    }).catchError((error) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: Text(error.toString()),
                            );
                          });
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: Text(
                                Validator(_forgetPasswordController.text)
                                    .email()!),
                          );
                        });
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _forgetPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _formTypeIsLogin = _formType == FormType.login;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AuthScreenAppBar(key: widget.key),
            SliverToBoxAdapter(
              child: SizedBox(
                height: customSize(context).height * 0.15,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: Card(
                  elevation: 4.0,
                  // margin:
                  //     EdgeInsets.only(top: customSize(context).height * 0.12),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text(
                            _formTypeIsLogin ? "Login" : "Register",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: ThemeTools.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: customSize(context).height * 0.035),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "xyz1234@mavs.uta.edu",
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                            validator: (val) {
                              return Validator(val!).email();
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "********",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _toggleHidePassword();
                                },
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                color:
                                    ThemeTools.appBarForeGroundColor(context),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                            validator: (val) {
                              return Validator(val!).password();
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          const SizedBox(height: 15),
                          if (!_formTypeIsLogin)
                            TextFormField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              obscureText: _hideConfirmPassword,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                hintText: "********",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggleHideConfirmPassword();
                                  },
                                  icon: Icon(
                                    _hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  color:
                                      ThemeTools.appBarForeGroundColor(context),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              validator: (val) {
                                if (_passwordController.text.trim() != val!) {
                                  return "Password did not match.";
                                }
                                return null;
                              },
                            ),
                          TextButton(
                            onPressed: () {
                              _onForgetPassword();
                            },
                            child: Text(
                              "Forget Password?",
                              style: GoogleFonts.lato(
                                color: ThemeTools.textButtonColor(context),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: ThemeTools.secondaryColor,
                            ),
                            onPressed: _onSubmit,
                            child: Text(
                              _formTypeIsLogin ? "Login" : "Register",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize: customSize(context).height * 0.018,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              toggleFormType();
                            },
                            child: Text(
                              !_formTypeIsLogin
                                  ? "Already have an account?"
                                  : "Need an account?",
                              style: GoogleFonts.lato(
                                color: ThemeTools.textButtonColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
