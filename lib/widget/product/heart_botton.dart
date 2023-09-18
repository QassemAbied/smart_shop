import 'package:flutter/material.dart';
import 'package:new_store_app/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';

class HeartBottomWidget extends StatelessWidget {
  HeartBottomWidget(
      {super.key,
      this.size = 22,
      this.isWishList = false,
      required this.productId});
  final double size;
  final String productId;
  bool isWishList;
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final getCurrent = productProvider.getProductById(productId);
    bool isWishList = wishListProvider.isWishList(proId: productId);
    return getCurrent == null
        ? const SizedBox.shrink()
        : Material(
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () async {
                if (isWishList == false) {
                  await wishListProvider.addWishListToFirebase(
                    context: context,
                    prodId: getCurrent.productId,
                  );
                } else {
                  await wishListProvider.removeOneProduct(
                    proId: productId,
                    wishListId: wishListProvider
                        .getWishListItem[getCurrent.productId]!.wishlistId,
                    context: context,
                  );
                }
              },
              icon: Icon(
                Icons.favorite,
                size: size,
                color: isWishList ? Colors.red : Colors.black,
              ),
            ),
          );
  }
}
