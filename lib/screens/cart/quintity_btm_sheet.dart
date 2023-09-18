import 'package:flutter/material.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';

class QuantityBtmSheet extends StatelessWidget {
  const QuantityBtmSheet({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    cartProvider.updateQuantity(prodId: id, quanty: index + 1);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TitleTextWidget(
                        text: '${index + 1}',
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
