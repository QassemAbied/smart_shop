import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/provider/cart_provider.dart';
import 'package:new_store_app/widget/botton_widget.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/theme_provider.dart';
import '../service/my_app_method.dart';
import '../widget/product/heart_botton.dart';
import '../widget/text_widget.dart';
import '../widget/title_text_widget.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider= Provider.of<CartProvider>(context);

    final productProvider= Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.getProductById(productId);

    Size size =MediaQuery.of(context).size;
    return getCurrentProduct == null ? const SizedBox.shrink() :Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text:getCurrentProduct.productName,
          color: themeProvider.getDarkTheme
              ? Colors.white
              : Colors.black,
        ),
        //title: AppNamedWidget(),

        leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
            child: Image(image: AssetImage('assets/images/bag/shopping_cart.png'))
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
              child:  FancyShimmerImage(
                imageUrl: getCurrentProduct.productImage,
                boxFit: BoxFit.fill,
                height:  size.height *0.5,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: getCurrentProduct.productName,
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,

                          sizeText: 23,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      TextWidget(
                        text: '\$ ${getCurrentProduct.productPrice}',
                        maxLines: 1,
                        fontWeight: FontWeight.w500,
                        sizeText: 20,
                        color: themeProvider.getDarkTheme
                            ? Colors.teal
                            : Colors.red,
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      HeartBottomWidget(
                        size: 28, productId: getCurrentProduct.productId ,

                      ),
                      const Spacer(),
                      BottomWidget(
                          color: themeProvider.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                          onPressed: ()async{
                            try{
                              await  cartProvider.addToCartFirebase(productId:
                              getCurrentProduct.productId, qty: 1, context: context);
                            }catch(e){

                              MethodApp.showAlertDialog(
                                  context: context,contentText: e.toString(), ftx: (){}, bottomText: 'ok');
                            }
                          },
                          text:cartProvider.isProductAddedToCart(prodId: getCurrentProduct.productId)?
                          'Sure From Cart': 'Add Item To Cart',
                          icon: Icons.card_travel_sharp
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'About this Items',
                        color: themeProvider.getDarkTheme
                            ? Colors.white
                            : Colors.black,

                        sizeText: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      TextWidget(
                        text: getCurrentProduct.productCategory,
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                        sizeText: 22,
                        color:  Colors.red,
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text:getCurrentProduct.description,
                    maxLines: 20,
                    //ontWeight: FontWeight.w400,
                    sizeText: 20,
                    color: themeProvider.getDarkTheme
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
