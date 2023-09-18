import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/provider/cart_provider.dart';
import 'package:new_store_app/widget/product/heart_botton.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../service/my_app_method.dart';
import '../../widget/text_widget.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final isToCart = cartProvider.isProductAddedToCart(prodId: productId);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.getProductById(productId);

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.productImage,
                  boxFit: BoxFit.fill,
                  height: 170,
                  width: double.infinity,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      text: getCurrentProduct.productName,
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                      sizeText: 18,
                      fontStyle: FontStyle.italic,
                      color: themeProvider.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  HeartBottomWidget(
                    size: 28, productId: getCurrentProduct.productId,
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
                        const TextWidget(
                          text: '\$ ',
                          maxLines: 1,
                          fontWeight: FontWeight.bold,
                          sizeText: 18,
                          color: Colors.red,
                        ),
                        TextWidget(
                          text: getCurrentProduct.productPrice,
                          maxLines: 1,
                          fontWeight: FontWeight.w500,
                          sizeText: 18,
                          color: themeProvider.getDarkTheme
                              ? Colors.white38
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await cartProvider.addToCartFirebase(
                            productId: getCurrentProduct.productId,
                            qty: 1,
                            context: context);
                      } catch (e) {
                        MethodApp.showAlertDialog(
                            context: context,
                            contentText: e.toString(),
                            ftx: () {},
                            bottomText: 'ok');
                      }
                    },
                    icon: Icon(
                      isToCart
                          ? Icons.done_all_outlined
                          : Icons.shopping_cart_rounded,
                      color: isToCart ? Colors.teal : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
