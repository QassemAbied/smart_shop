import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/models/recently_model.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/recently_provider.dart';
import '../../provider/theme_provider.dart';
import '../../widget/text_widget.dart';

class ViewedRecentlyItem extends StatelessWidget {
  const ViewedRecentlyItem({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewedProvider= Provider.of<ViewedRecentlyProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final viewedModels = Provider.of<ViewedRecentlyModels>(context,);

    final getCurrent = productProvider.getProductById(viewedModels.productId);


    return getCurrent==null? const SizedBox.shrink(): GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        height:  170,
        width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FancyShimmerImage(
                imageUrl: getCurrent.productImage,
                boxFit: BoxFit.fill,
                height:  170,
                width: 150,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
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
            IconButton(
              onPressed: (){
                viewedProvider.removeOneProduct(proId: getCurrent.productId);
              },
              icon: const Icon(Icons.dangerous, color: Colors.red,),
            ),

          ],
        ),
      ),
    );
  }
}
