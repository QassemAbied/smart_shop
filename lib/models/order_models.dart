import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModels with ChangeNotifier {
  final String orderId, userId, userName, productId, price, image, quantity;
  final Timestamp orderDate;

  OrderModels(
      {required this.orderId,
      required this.userId,
      required this.userName,
      required this.productId,
      required this.price,
      required this.image,
      required this.quantity,
      required this.orderDate});
}
