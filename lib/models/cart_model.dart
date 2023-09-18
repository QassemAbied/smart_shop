import 'package:flutter/cupertino.dart';

class CartModels with ChangeNotifier{
  final String prodId, cartId;
  final int quanty;
  CartModels({
    required this.prodId, required this.cartId, required this.quanty
});
}