import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_store_app/screens/cart/cart_screen.dart';
import 'package:new_store_app/screens/home/home_screen.dart';
import 'package:new_store_app/screens/profile_screen.dart';
import 'package:new_store_app/screens/search/search_screen.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../provider/wishlist_provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key, this.currentIndex = 0});
  int currentIndex;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  // final List<Map<String, dynamic>> Screens = [
  //   {
  //     'pages': HomeScreen(),
  //     'title': 'Home'
  //   },
  //   {
  //     'pages': SearchScreen(),
  //     'title': 'Search'
  //   },
  //   {
  //     'pages': CartScreen(),
  //     'title': 'Cart'
  //   },
  //   {
  //     'pages': ProfileScreen(),
  //     'title': 'Profile'
  //   }
  // ];

  late PageController pageController;
  bool isLoading = true;

  Future fetchProduct() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishListProvider>(context, listen: false);

    try {
      Future.wait({productProvider.fetchProductDate()});
      Future.wait({cartProvider.fetchCart()});
      Future.wait({wishlistProvider.fetchWishList()});
    } catch (e) {
      throw e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isLoading) {
      fetchProduct();
    }
    super.initState();
    pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height: kBottomNavigationBarHeight,
        selectedIndex: widget.currentIndex,
        onDestinationSelected: (index) {
          setState(
            () {
              widget.currentIndex = index;
            },
          );
          pageController.jumpToPage(widget.currentIndex);
        },
        destinations: [
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.home),
              icon: Icon(IconlyLight.home),
              label: 'Home'),
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.search),
              icon: Icon(IconlyLight.search),
              label: 'Search'),
          NavigationDestination(
              selectedIcon: Badge(
                  label: Text('${cartProvider.cartProductItem.length}'),
                  child: const Icon(IconlyBold.bag2)),
              icon: Badge(
                  label: Text('${cartProvider.cartProductItem.length}'),
                  child: const Icon(IconlyLight.bag2)),
              label: 'Cart'),
          const NavigationDestination(
              selectedIcon: Icon(IconlyBold.profile),
              icon: Icon(IconlyLight.profile),
              label: 'Profile'),
        ],
      ),
    );
  }
}
