import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:new_store_app/consts/theme_data.dart';
import 'package:new_store_app/provider/cart_provider.dart';
import 'package:new_store_app/provider/order_provider.dart';
import 'package:new_store_app/provider/product_provider.dart';
import 'package:new_store_app/provider/recently_provider.dart';
import 'package:new_store_app/provider/theme_provider.dart';
import 'package:new_store_app/provider/user_provider.dart';
import 'package:new_store_app/provider/wishlist_provider.dart';
import 'package:new_store_app/screens/main_screen.dart';
import 'package:new_store_app/screens/search/search_screen.dart';
import 'package:new_store_app/screens/stripe_payment/stripe_keys.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = ApiKeys.publishableKey;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapShot.hasError) {
            return Center(
              child:
                  TitleTextWidget(text: 'hellow$hashCode', color: Colors.black),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => ProductProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => WishListProvider()),
              ChangeNotifierProvider(create: (_) => ViewedRecentlyProvider()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => OrderProvider()),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: style.themeData(isDark: themeProvider.getDarkTheme),
                  home: MainScreen(),
                  routes: {
                    SearchScreen.routName: (context) => const SearchScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}
