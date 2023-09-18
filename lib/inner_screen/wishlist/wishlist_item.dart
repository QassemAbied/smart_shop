import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/models/wishlist_model.dart';
import 'package:new_store_app/provider/cart_provider.dart';
import 'package:new_store_app/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../service/my_app_method.dart';
import '../../widget/product/heart_botton.dart';
import '../../widget/text_widget.dart';

class WishListItem extends StatelessWidget {
  const WishListItem({super.key, });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistModels = Provider.of<WishLitModels>(context,);
    final cartProvider = Provider.of<CartProvider>(context);
    final isToCart= cartProvider.isProductAddedToCart(prodId: wishlistModels.productId);

    final getCurrent = productProvider.getProductById(wishlistModels.productId);
    return getCurrent==null? SizedBox.shrink():GestureDetector(
      onTap: (){
        // Navigator.push(context,
        //   MaterialPageRoute(builder: (context)=>DetailsScreen(),),
        // );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:  FancyShimmerImage(
              imageUrl: getCurrent.productImage,
              boxFit: BoxFit.fill,
              height:  170,
              width: double.infinity,
            ),

            // Image(
            //   image: NetworkImage(getCurrent.productImage),
            //   fit: BoxFit.fill,
            //   height:  170,
            //   width: double.infinity,
            // ),
          ),

          Row(
            children: [
              Expanded(
                child: TextWidget(
                  text: getCurrent.productName,
                  maxLines: 2,
                  fontWeight: FontWeight.w500,
                  sizeText: 18,
                  fontStyle: FontStyle.italic,
                  color: themeProvider.getDarkTheme
                      ? Colors.white
                      : Colors.black,
                ),
              ) ,
              // IconButton(
              //   onPressed: (){},
              //   icon: Icon(Icons.favorite_border),
              // ),
              HeartBottomWidget(
                size: 28,
                productId: wishlistModels.productId,
                // color:themeProvider.getDarkTheme
                //     ? Colors.tealAccent
                //     : Colors.teal ,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    TextWidget(
                      text: '\$ ',
                      maxLines: 1,
                      fontWeight: FontWeight.bold,
                      sizeText: 18,
                      color: Colors.red,
                    ),
                    TextWidget(
                      text: '${getCurrent.productPrice}',
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                      sizeText: 18,
                      color: themeProvider.getDarkTheme
                          ? Colors.white38
                          : Colors.grey,
                    ),
                  ],
                ),
              ) ,
              IconButton(
                onPressed: ()async{
                  try{
                    await  cartProvider.addToCartFirebase(productId: getCurrent.productId, qty: 1, context: context);
                  }catch(e){
                    MethodApp.showAlertDialog( context: context,contentText: e.toString(), ftx: (){}, bottomText: 'ok');
                  }
                },
                icon: Icon(isToCart?Icons.done_all_outlined :Icons.add_shopping_cart),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
