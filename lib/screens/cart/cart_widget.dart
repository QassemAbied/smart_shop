import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/models/cart_model.dart';
import 'package:new_store_app/screens/cart/quintity_btm_sheet.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../widget/product/heart_botton.dart';
import '../../widget/text_widget.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModels>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.getProductById(cartModel.prodId);
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : SizedBox(
            width: double.infinity,
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      boxFit: BoxFit.fill,
                      height: 140,
                      width: size.width * 0.33,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.589,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextWidget(
                                text: getCurrentProduct.productName
                                    .toLowerCase()
                                    .trim(),
                                maxLines: 2,
                                fontWeight: FontWeight.w500,
                                sizeText: 20,
                                color: themeProvider.getDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await cartProvider.removeOneItem(
                                  //cartModel.prodId,
                                  productId: getCurrentProduct.productId,
                                  qty: cartModel.quanty,
                                  context: context,
                                  cartId: cartModel.cartId,
                                );
                              },
                              icon: const Icon(Icons.clear),
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
                                    sizeText: 22,
                                    color: Colors.red,
                                  ),
                                  TextWidget(
                                    text: getCurrentProduct.productPrice,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                    sizeText: 20,
                                    color: themeProvider.getDarkTheme
                                        ? Colors.white38
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            HeartBottomWidget(
                              size: 28,
                              productId: getCurrentProduct.productId,
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                )),
                                backgroundColor: Colors.grey,
                                context: context,
                                builder: (context) {
                                  return QuantityBtmSheet(
                                    id: cartModel.prodId,
                                  );
                                });
                          },
                          label: TextWidget(
                            text: 'Qut:${cartModel.quanty}',
                            maxLines: 1,
                            sizeText: 13,
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          icon: const Icon(
                            Icons.arrow_downward_outlined,
                            size: 13,
                          ),
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
