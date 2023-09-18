import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../provider/product_provider.dart';
import '../service/my_app_method.dart';
import 'main_screen.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProviderr =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId:
                    "AVqIRjdKTbJhNSlYXGwTfsA8ylGmyKkuFOp-9u2rrDR21zyqovnsKzMC4q1ODGxdALkZOWGSSOSC-ktB",
                secretKey:
                    "EMi31YojY5nciBUp7eqPaBvJRm5ygGKAkhOM2zskGfed8OyrvyQB5VCRFBg0oxZ4oqwfeH96XWldlS_N",
                returnURL: "success.snippetcoder.com",
                cancelURL: "cancel.snippetcoder.com",
                transactions: [
                  {
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
                          'totalPrice':
                              (getCurrent?.productPrice)! * value.quanty,
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
                    }),
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}
