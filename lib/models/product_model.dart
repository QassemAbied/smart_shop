import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModels with ChangeNotifier{
   Timestamp? createAt;
  final String productId, productName,productPrice,
      productImage,productCategory,quantity,description;

  ProductModels(
   {
    required this.productId,
     required this.description,
     required this.productName,
     required this.productPrice,
   required this.productImage,
     required this.quantity,
     required this.productCategory,
     this.createAt,
   });

  factory ProductModels.fromFireStore(DocumentSnapshot doc){
    Map data= doc.data() as Map<String , dynamic>;
    return ProductModels(
        productId: data['productId'],
        description: data['productDescription'],
        productName: data['productName'],
        productPrice: data['productPrice'],
        productImage: data['productImage'],
        quantity: data['productQty'],
        productCategory: data['productCategory'],
      createAt:data['createAt'],
    );
  }
}