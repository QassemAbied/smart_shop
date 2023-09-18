import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/screens/main_screen.dart';
import 'package:new_store_app/screens/paypal_screen.dart';
import 'package:new_store_app/screens/stripe_payment/payment_manger.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../provider/product_provider.dart';
import '../service/my_app_method.dart';
import '../widget/title_text_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const TitleTextWidget(
          text: 'Payment | Stripe OR Paypal',
          color: Colors.black,
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child:
              Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120, right: 10, left: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final productProviderr =
                    Provider.of<ProductProvider>(context, listen: false);
                await PaymentManager.makePayment(context,
                    cartProvider.totalPrice(productProvider).toInt(), 'USD');
                cartProvider.cartProductItem.forEach((key, value) async {
                  final getCurrent =
                      productProviderr.getProductById(value.prodId);
                  try {
                    final User? user = FirebaseAuth.instance.currentUser;
                    final _uid = user!.uid;
                    final orderId = Uuid().v4();
                    await FirebaseFirestore.instance
                        .collection('order')
                        .doc(orderId)
                        .set({
                      'orderId': orderId,
                      'userId': user.uid,
                      'productId': value.prodId,
                      'price': getCurrent?.productPrice,
                      'title': getCurrent?.productName,
                      'quantity': value.quanty,
                      'userName': user.displayName,
                      'totalPrice': (getCurrent?.productPrice)! * value.quanty,
                      'imageUrl': getCurrent?.productImage,
                      'orderDate': Timestamp.now(),
                    });
                    await cartProvider.removeAllCart(context: context);
                    await orderProvider.fetchorder();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen(
                                  currentIndex: 2,
                                )));
                  } catch (error) {
                    print(
                        '$error---------------------------------------------');
                    await MethodApp.ToastBar(text: '$error');
                    print(error);
                  } finally {}
                });
              },
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Image(
                  image: NetworkImage(
                      'https://www.merchantmaverick.com/wp-content/uploads/2014/02/Stripe-wordmark-blurple-large.png'),
                  //fit: BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutPage()));
              },
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Image(
                  image: NetworkImage(
                      'https://www.3arrafni.com/wp-content/uploads/2023/03/%D8%A7%D9%86%D8%B4%D8%A7%D8%A1-'
                      '%D8%AD%D8%B3%D8%A7%D8%A8-%D8%B9%D9%84%D9%89-%D9%85%D9%86%D8%B5%D8%A9-PayPal.jpg'),
                  // fit: BoxFit.cover,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
