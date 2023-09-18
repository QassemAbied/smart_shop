import 'package:flutter/material.dart';
import 'package:new_store_app/provider/order_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import '../../widget/text_widget.dart';
import '../../widget/title_text_widget.dart';
import '../payment_screen.dart';

class BottomCartSheet extends StatelessWidget {
  const BottomCartSheet({super.key, });


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size= MediaQuery.of(context).size;
    final cartProvider= Provider.of<CartProvider>(context);
    final productProvider= Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,

        border: Border(top: BorderSide(color: themeProvider.getDarkTheme
            ? Colors.white
            : Colors.black , width: 1)),

      ),
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Total (${cartProvider.cartProductItem.length} product/ ${cartProvider.quantitiyCount()} items)',
                  maxLines: 1,
                  sizeText: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getDarkTheme
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextWidget(
                    text: '\$ ${cartProvider.totalPrice(productProvider)}',
                    maxLines: 1,
                    sizeText: 16,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getDarkTheme
                        ? Colors.tealAccent
                        : Colors.deepOrangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white54,
                    minimumSize:const Size(70, 40),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaymentScreen()));
                  },

                  child: const TitleTextWidget(
                    text:'CheckOut',
                    color:Colors.black,
                    fontSize: 18,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
