import 'package:flutter/material.dart';
import 'package:new_store_app/screens/cart/cart_widget.dart';
import 'package:new_store_app/screens/empty_screen.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/theme_provider.dart';
import '../../service/my_app_method.dart';
import 'bottom_sheet.dart';

class CartScreen extends StatelessWidget {
   const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider= Provider.of<CartProvider>(context);

    final getProductCart= cartProvider.cartProductItem;
    Size size= MediaQuery.of(context).size;
    return getProductCart.isEmpty?EmptyForScreen(
      image: 'assets/images/bag/shopping_cart.png',
      title: 'Whoops!',
      subTitle: 'Your Cart is Empty',
      lastTitle: 'look like you have added no anything to you car '
          ' go ahead & explore top categories',
      bottomTitle: 'Shop Now',
      onPressed: (){}, textAppBar: 'Cart',
    ):Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text:  'Cart (${getProductCart.length})',
          color: themeProvider.getDarkTheme
              ? Colors.white
              : Colors.black,
        ),

        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
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
                      cartProvider.removeAllCart(context: context);
                      Navigator.pop(context);
                    },
                    bottomText: 'ok');

              },
              icon: const Icon(Icons.delete , color: Colors.red,)
          )
        ],
      ),
      body: SizedBox(
        height: size.height * 0.73,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: getProductCart.length,
                itemBuilder: (context , index){
                  return ChangeNotifierProvider.value(
                    value: getProductCart.values.toList()[index],
                      child: const CartWidget());
                },
                separatorBuilder: (context , index){
                  return const SizedBox(
                    height:   15,
                  );
                },

              ),
            ],
          ),
        ),
      ),
      bottomSheet: const BottomCartSheet(),
    );


  }
}
