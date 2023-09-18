import 'package:flutter/material.dart';
import 'package:new_store_app/inner_screen/wishlist/wishlist_item.dart';
import 'package:new_store_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../provider/wishlist_provider.dart';
import '../../screens/empty_screen.dart';
import '../../service/my_app_method.dart';
import '../../widget/product/heart_botton.dart';
import '../../widget/text_widget.dart';
import '../../widget/title_text_widget.dart';
import '../detalis_screen.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishListProvider>(context);

    return wishlistProvider.getWishListItem.isEmpty?EmptyForScreen(
      image: 'assets/images/bag/bag_wish.png',
      title: 'Whoops!',
      subTitle: 'Your WishList is Empty',
      lastTitle: 'look like you have added no anything to you car '
          ' go ahead & explore top categories',
      bottomTitle: 'Shop Now',
      onPressed: (){}, textAppBar: 'WishList',
    ):Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text:  'WishList (${wishlistProvider.getWishListItem.length})',
          color: themeProvider.getDarkTheme
              ? Colors.white
              : Colors.black,
        ),

        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
          child: Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: (){
                MethodApp.showAlertDialog(
                    context: context,
                    contentText: 'Are you sure you want to delete all?',
                    ftx: () {
                      wishlistProvider.removeAllWishList();
                      Navigator.pop(context);
                    },
                    bottomText: 'ok');

              },
              icon: Icon(Icons.delete , color: Colors.red,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,


                  ),
                  itemCount: wishlistProvider.getWishListItem.length,
                  itemBuilder: (context , index){
                    return ChangeNotifierProvider.value(
                      value: wishlistProvider.getWishListItem.values.toList()[index],
                      child: WishListItem(
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
