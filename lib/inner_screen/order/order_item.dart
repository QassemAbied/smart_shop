import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/models/order_models.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../widget/text_widget.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orderModels= Provider.of<OrderModels>(context);
     final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrent = productProvider.getProductById(orderModels.productId);
    Size size =MediaQuery.of(context).size;
    return orderModels == null? const SizedBox.shrink(): Container(
      width: double.infinity,
      height: 130,
      //color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FancyShimmerImage(
                imageUrl: orderModels.image,
                boxFit: BoxFit.fill,
                height:  140,
                width: size.width *0.33,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width *0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: getCurrent!.productName,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                    sizeText: 20,
                    color: themeProvider.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ) ,
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const TextWidget(
                        text: '\$ ',
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                        sizeText: 22,
                        color: Colors.red,
                      ),
                      TextWidget(
                        text: orderModels.price,
                        maxLines: 1,
                        fontWeight: FontWeight.w500,
                        sizeText: 20,
                        color: themeProvider.getDarkTheme
                            ? Colors.white38
                            : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'qeuty : ${orderModels.quantity}',
                    maxLines: 1,
                    sizeText: 18,
                    color: themeProvider.getDarkTheme
                        ? Colors.white38
                        : Colors.grey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: (){},
                icon: const Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
