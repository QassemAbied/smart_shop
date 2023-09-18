import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/provider/recently_provider.dart';
import 'package:provider/provider.dart';
import '../../inner_screen/detalis_screen.dart';
import '../../provider/cart_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../service/my_app_method.dart';
import '../../widget/product/heart_botton.dart';
import '../../widget/text_widget.dart';

class ProductHomeWidget extends StatelessWidget {
  const ProductHomeWidget({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final isToCart = cartProvider.isProductAddedToCart(prodId: productId);
    final productProvider = Provider.of<ProductProvider>(context);
    final viewedProvider = Provider.of<ViewedRecentlyProvider>(context);
    final getCurrentProduct = productProvider.getProductById(productId);
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    productId: getCurrentProduct.productId,
                  ),
                ),
              );
              viewedProvider.addViewedRecently(
                  proId: getCurrentProduct.productId);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: SizedBox(
                width: 250,
                height: size.height * 0.22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FancyShimmerImage(
                          imageUrl: getCurrentProduct.productImage,
                          boxFit: BoxFit.fill,
                          height: size.height * 0.22,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: getCurrentProduct.productName,
                            maxLines: 2,
                            fontWeight: FontWeight.w700,
                            sizeText: 20,
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                HeartBottomWidget(
                                  size: 28, productId: productId,
                                  // color:themeProvider.getDarkTheme
                                  //     ? Colors.tealAccent
                                  //     : Colors.teal ,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      await cartProvider.addToCartFirebase(
                                          productId:
                                              getCurrentProduct.productId,
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
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
                                sizeText: 16,
                                color: themeProvider.getDarkTheme
                                    ? Colors.white38
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
