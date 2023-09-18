import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_store_app/screens/auth/login_screen.dart';
import 'package:new_store_app/screens/loading_screen.dart';
import 'package:new_store_app/widget/auth/auth_diolag.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/theme_provider.dart';
import '../../widget/auth/picke_image.dart';
import '../../widget/text_widget.dart';
import '../../widget/title_text_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addersController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode addersFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  bool isShow = true;
  bool isLoading = false;
  XFile? _imagePicked;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addersController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    addersFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _uuid = const Uuid().v4();
  Future uploadImageToFirebase(dynamic image)async{
    Reference ref= storage.ref().child('userImage').child(_uuid +'png');
    UploadTask uploadTask = ref.putFile(File(_imagePicked!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downLoad= await taskSnapshot.ref.getDownloadURL();
    return downLoad;
  }

  void _submitFormOnRegister() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    String imageUrl =await uploadImageToFirebase(_imagePicked);
    if (isValid) {
      setState(() {
        isLoading=true;
      });
      try {

        await auth.createUserWithEmailAndPassword(
          email: emailController.text.toString().trim().toUpperCase(),
          password: passwordController.text.toString().trim(),
        );
        final User? user = auth.currentUser;
        final uid = user!.uid;
        user.updateDisplayName(nameController.text);
        user.reload();
        await fireStore.collection('users').doc(uid).set({
          'userId': uid,
          'userName': nameController.text,
          'userEmail': emailController.text,
          'userAdders': addersController.text,
          'userImage': imageUrl,
          'createAt': Timestamp.now(),
          'user_cart': [],
          'user_wish': [],
        });
        clearForm();
        showAlertDialogRegister(
          context: context,
          text: 'Congrats!',
          contentText: 'Congratulations my friend, you have been successfully logged in',
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } on FirebaseException catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: '${error.code}',
        );
        setState(() {
          isLoading=false;
        });
      } catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: '$error',
        );
        setState(() {
          isLoading=false;
        });
      }finally{
        setState(() {
          isLoading=false;
        });
      }
    }
  }
  void clearForm(){
    setState(() {
      _imagePicked==null;
      emailController.clear();
      nameController.clear();
      passwordController.clear();
      addersController.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: LoadingManagerScreen(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
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
                      text: 'Sign up to Continue',
                      sizeText: 18,
                      maxLines: 1,
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          PickImage(
                            imagePicked: _imagePicked,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          final themeProvider =
                                              Provider.of<ThemeProvider>(context);

                                          return AlertDialog(
                                            title: Center(
                                              child: TitleTextWidget(
                                                text: 'Chose Option',
                                                color: themeProvider.getDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 23,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: () async {
                                                      await pickImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.camera_alt, color: Colors.teal,),
                                                    label: TextWidget(
                                                      text: 'Camera',
                                                      sizeText: 22,
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .getDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () async {
                                                      await pickImageGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.camera, color: Colors.teal),
                                                    label: TextWidget(
                                                      text: 'Gallery',
                                                      sizeText: 22,
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .getDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      setState(() {
                                                        _imagePicked = null;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.remove, color: Colors.teal),
                                                    label: TextWidget(
                                                      text: 'Remove',
                                                      sizeText: 22,
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .getDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.camera_alt)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: nameFocusNode,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter The Real UserName';
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
                        hintText: 'enter your name',
                        prefixIcon: Icon(
                          Icons.edit,
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
                      textInputAction: TextInputAction.next,
                      focusNode: emailFocusNode,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter The Real Email Adders';
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
                      textInputAction: TextInputAction.next,
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(addersFocusNode);
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
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      focusNode: addersFocusNode,
                      controller: addersController,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        //FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter The Real Adders';
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
                        hintText: 'enter your Adders',
                        prefixIcon: Icon(
                          Icons.place_outlined,
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
                    Center(
                      child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(150, 40),
                                minimumSize: const Size(150, 40),
                                backgroundColor: themeProvider.getDarkTheme
                                    ? Colors.teal
                                    : Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _submitFormOnRegister();

                              },
                              child: const TextWidget(
                                  text: 'Sign Up',
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
                    Row(
                      children: [
                        TextWidget(
                          text: 'Already a User?',
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
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const TextWidget(
                            text: 'Sign in',
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
      ),
    );
  }

  pickImageCamera() async {
    ImagePicker imagePicker = ImagePicker();
    _imagePicked = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  pickImageGallery() async {
    ImagePicker imagePicker = ImagePicker();
    _imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
}
