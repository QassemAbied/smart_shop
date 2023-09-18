import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_store_app/inner_screen/order/order_screen.dart';
import 'package:new_store_app/inner_screen/viewed_recently/viewed_recently_screen.dart';
import 'package:new_store_app/inner_screen/wishlist/wishlist_screen.dart';
import 'package:new_store_app/models/user_model.dart';
import 'package:new_store_app/provider/user_provider.dart';
import 'package:new_store_app/screens/auth/login_screen.dart';
import 'package:new_store_app/screens/loading_screen.dart';
import 'package:new_store_app/widget/botton_widget.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../service/my_app_method.dart';
import '../widget/auth/auth_diolag.dart';
import '../widget/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  UserModels? userModels;
  Future fetchUser() async {
    if (user == null) {
      return null;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      userModels = await userProvider.fetchUserData();
    } on FirebaseException catch (error) {
      showAlertDialogRegister(
        context: context,
        text: 'have you error',
        contentText: '${error.code}',
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

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text: 'Profile',
          color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
        ),
        //title: AppNamedWidget(),

        leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Image(
                image: AssetImage('assets/images/bag/shopping_cart.png'))),
        elevation: 0.0,
      ),
      body: LoadingManagerScreen(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: TitleTextWidget(
                    text: 'Please Login to have ultimate access',
                    color: themeProvider.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                userModels == null
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          Container(
                            width: 70,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: themeProvider.getDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              //borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(userModels!.userImage),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextWidget(
                                text: userModels!.userName,
                                color: themeProvider.getDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 23,
                              ),
                              TextWidget(
                                text: userModels!.userEmail,
                                maxLines: 1,
                                color: themeProvider.getDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                sizeText: 15,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(IconlyBold.edit))
                        ],
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextWidget(
                      text: 'General',
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                      fontSize: 22,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    user == null
                        ? const SizedBox.shrink()
                        : ListTitleWidget(
                            image: 'assets/images/bag/order_svg.png',
                            text: 'All Order',
                            tap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrderScreen(),
                                ),
                              );
                            },
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    user == null
                        ? const SizedBox.shrink()
                        : ListTitleWidget(
                            image: 'assets/images/bag/wishlist_svg.png',
                            text: 'Wishlist',
                            tap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WishListScreen(),
                                ),
                              );
                            },
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTitleWidget(
                      image: 'assets/images/profile/recent.png',
                      text: 'Viewed Recently',
                      tap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewedRecentlyScreen(),
                          ),
                        );
                      },
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTitleWidget(
                      image: 'assets/images/profile/address.png',
                      text: 'Address',
                      tap: () {},
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TitleTextWidget(
                      text: 'Settings',
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                      fontSize: 22,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                        value: themeProvider.getDarkTheme,
                        activeThumbImage:
                            const AssetImage('assets/images/profile/theme.png'),
                        inactiveThumbImage:
                            const AssetImage('assets/images/profile/theme.png'),
                        secondary: const Image(
                          image: AssetImage('assets/images/profile/theme.png'),
                        ),
                        title: TextWidget(
                            text: 'Theme',
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                            sizeText: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                        onChanged: (value) {
                          themeProvider.setDarkTheme(setDart: value);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                      height: 2,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                Center(
                  child: BottomWidget(
                    color: themeProvider.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                    onPressed: () async {
                      if (user == null) {
                        if (!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      } else {
                        await MethodApp.showAlertDialog(
                            context: context,
                            contentText: 'ComFirm LogOut',
                            ftx: () async {
                              await auth.signOut();
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            bottomText: 'ok',
                            nextBottom: true);
                      }
                    },
                    text: user == null ? 'Login' : 'LogOut',
                    icon: user == null ? IconlyBold.login : IconlyBold.logout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListTitleWidget({
    required String image,
    required String text,
    required Function tap,
    required Color color,
  }) {
    return ListTile(
      leading: Image(image: AssetImage(image)),
      title: TextWidget(
        text: text,
        maxLines: 1,
        color: color,
      ),
      trailing: const Icon(IconlyBold.arrowRightCircle),
      onTap: () => tap(),
    );
  }
}
