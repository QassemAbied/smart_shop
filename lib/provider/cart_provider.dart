import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_store_app/models/cart_model.dart';
import 'package:new_store_app/models/product_model.dart';
import 'package:new_store_app/provider/product_provider.dart';
import 'package:new_store_app/service/my_app_method.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModels> cartItem = {};
  Map<String, CartModels> get cartProductItem {
    return cartItem;
  }

  bool isProductAddedToCart({required String prodId}) {
    return cartItem.containsKey(prodId);
  }

  final userDB = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    User? user = auth.currentUser;
    if (user == null) {
      MethodApp.showAlertDialog(
          context: context,
          contentText: 'Sorry, you must log in first',
          ftx: () {
            Navigator.pop(context);
          },
          bottomText: 'ok');
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      userDB.doc(uid).update({
        'user_cart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'qty': qty,
            'productId': productId,
          }
        ]),
      });
      await fetchCart();
      await MethodApp.ToastBar(text: 'Successfully added to cart', );
    } catch (e) {
      rethrow;
    }
  }

  Future fetchCart() async {
    final User? user = auth.currentUser;
    if (user == null) {
      cartItem.clear();
      return;
    }

    try {
      final uid = user.uid;
      final userDoc = await userDB.doc(uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('user_cart')) {
        return;
      }
      final leng = userDoc.get('user_cart').length;
      for (int index = 0; index < leng; index++) {
        cartItem.putIfAbsent(
          userDoc.get('user_cart')[index]['productId'],
          () => CartModels(
              prodId: userDoc.get('user_cart')[index]['productId'],
              cartId: userDoc.get('user_cart')[index]['cartId'],
              quanty: userDoc.get('user_cart')[index]['qty']),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
//   void addToCart({required String prodId}){
//     cartItem.putIfAbsent(prodId, () =>
//         CartModels(
//             prodId: prodId,
//             cartId: Uuid().v4(),
//             quanty: 10
//         ),
//     );
//     notifyListeners();
// }

  Future<void> removeOneItem({
    required String productId,
    required String cartId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;

    final uid = user!.uid;
    try {
      await userDB.doc(uid).update({
        'user_cart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'qty': qty,
            'productId': productId,
          }
        ]),
      });
      await fetchCart();
      cartItem.remove(productId);
     await MethodApp.ToastBar(text: 'Successfully removed from cart', );
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future removeAllCart({required BuildContext context}) async{
    final User? user = auth.currentUser;
    if (user == null) {
     await MethodApp.showAlertDialog(
          context: context,
          contentText: 'Sorry, you must log in first',
          ftx: () {
            Navigator.pop(context);
          },
          bottomText: 'ok');
      return;
    }
    final uid = user.uid;

   await userDB.doc(uid).update({
      'user_cart': [],
    });
    cartItem.clear();

    notifyListeners();
  }

  void updateQuantity({required String prodId, required int quanty}) {
    cartItem.update(
      prodId,
      (value) =>
          CartModels(prodId: prodId, cartId: value.cartId, quanty: quanty),
    );
    notifyListeners();
  }

  int quantitiyCount() {
    int quanty = 0;
    cartItem.forEach((key, value) {
      quanty += value.quanty;
    });
    return quanty;
  }

  double totalPrice(ProductProvider productProvider) {
    double total = 0.0;
    cartItem.forEach((key, value) {
      final ProductModels? productModels =
          productProvider.getProductById(value.prodId);
      if (productModels == null) {
        total += 0;
      } else {
        total += double.parse(productModels.productPrice) * value.quanty;
      }
    });
    return total;
  }
}
