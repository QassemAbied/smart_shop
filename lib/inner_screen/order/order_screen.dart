import 'package:flutter/material.dart';
import 'package:new_store_app/inner_screen/order/order_item.dart';
import 'package:provider/provider.dart';
import '../../provider/order_provider.dart';
import '../../provider/theme_provider.dart';
import '../../widget/title_text_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text:  'Orders (${orderProvider.getOrderList.length})',
          color: themeProvider.getDarkTheme
              ? Colors.white
              : Colors.black,
        ),

        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
          child: Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: orderProvider.getOrderList.length,
              itemBuilder: (context , index){
                return ChangeNotifierProvider.value(
                  value: orderProvider.getOrderList[index],
                    child: const OrderItemWidget());
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
    );
  }
}
