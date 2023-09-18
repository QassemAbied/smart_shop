import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/screens/auth/register_screen.dart';
import 'package:new_store_app/screens/loading_screen.dart';
import 'package:new_store_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/theme_provider.dart';
import '../../widget/auth/auth_diolag.dart';
import '../../widget/auth/google_botton.dart';
import '../../widget/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isShow = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _uuid = const Uuid().v4();
  void _submitFormOnLogin() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        clearForm();
        
        showAlertDialogRegister(
          context: context,
          text: 'Congrats!',
          contentText:
              'Congratulations my friend, you have been successfully logged in',
        );
        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } on FirebaseException catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: error.code,
        );
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: '$error',
        );
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void clearForm() {
    setState(() {
      emailController.clear();
      passwordController.clear();
    });
  }

  IconData suifxxx = Icons.visibility;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: LoadingManagerScreen(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Welcome Back',
                    sizeText: 28,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: themeProvider.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: 'Sign in to Continue',
                    sizeText: 18,
                    maxLines: 1,
                    color: themeProvider.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: emailFocusNode,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter The Real EmailAdders';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: themeProvider.getDarkTheme
                            ? Colors.black
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: themeProvider.getDarkTheme
                            ? Colors.black
                            : Colors.black,
                      ),
                      filled: true,
                      fillColor: themeProvider.getDarkTheme
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.red
                              : Colors.red,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: () {
                      // FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter The Real Password';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: themeProvider.getDarkTheme
                            ? Colors.black
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    decoration: InputDecoration(
                      hintText: '***************',
                      prefixIcon: Icon(
                        Icons.password,
                        color: themeProvider.getDarkTheme
                            ? Colors.black
                            : Colors.black,
                      ),
                      filled: true,
                      fillColor: themeProvider.getDarkTheme
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.red
                              : Colors.red,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        // MaterialPageRoute(
                        //     builder: (context) =>
                        //     const ForgetPasswordScreen())
                        // );
                      },
                      child: const TextWidget(
                        text: 'Forget Password?',
                        sizeText: 18,
                        maxLines: 1,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          maximumSize: const Size(150, 40),
                          minimumSize: const Size(150, 40),
                          backgroundColor: themeProvider.getDarkTheme
                              ? Colors.teal
                              : Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        _submitFormOnLogin();
                      },
                      child: const TextWidget(
                          text: 'Sign in',
                          sizeText: 23,
                          maxLines: 1,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'OR',
                        sizeText: 18,
                        maxLines: 1,
                        color: themeProvider.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const GoogleBottom(),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(150, 40),
                            minimumSize: const Size(150, 40),
                            backgroundColor: Colors.teal.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        child: const TextWidget(
                            text: 'Guest',
                            sizeText: 23,
                            maxLines: 1,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Don\'t have an account?',
                        sizeText: 18,
                        maxLines: 1,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: themeProvider.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: const TextWidget(
                          text: 'Sign up',
                          sizeText: 18,
                          maxLines: 1,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
