import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/order_models.dart';

class OrderProvider with ChangeNotifier {
  static List<OrderModels> orderList = [];

  List<OrderModels> get getOrderList {
    return orderList;
  }

  Future<void> fetchorder() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('order')
        .where('userId', isEqualTo: _uid)
        .orderBy('orderDate', descending: false)
        .get()
        .then((QuerySnapshot orderSnapshot) {
      orderList = [];
      orderSnapshot.docs.forEach((element) {
        orderList.insert(
          0,
          OrderModels(
            orderId: element.get('orderId'),
            userId: element.get('userId'),
            userName: element.get('userName'),
            productId: element.get('productId'),
            price: element.get('price').toString(),
            image: element.get('imageUrl'),
            quantity: element.get('quantity').toString(),
            orderDate: element.get('orderDate'),
          ),
        );
      });
    });
    notifyListeners();
  }
}
