import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier{
  List<ProductModels> _product=[];
  List<ProductModels> get getProduct{
    return _product;
  }
  ProductModels? getProductById(String Id){
    if(_product.where((element) => element.productId==Id ).isEmpty){
    return null;
    }
    return _product.firstWhere((element) => element.productId ==Id);
  }

  List<ProductModels> getProductByCat(String Category){
    List<ProductModels> catList= _product.where((element) =>
    element.productCategory.toLowerCase()     ==Category.toLowerCase()).toList();
    return catList;
  }

  List<ProductModels> getProductBySearch(String name,List<ProductModels> list){
    List<ProductModels> searchList= _product.where((element) =>
    element.productName.toLowerCase().contains(name.toLowerCase())).toList();
    return searchList;
  }

  final productDB= FirebaseFirestore.instance.collection('product');
  Future<List<ProductModels>> fetchProductDate()async{
    try{
      await productDB.orderBy('createAt', descending: false).
      get().then((productSnapShot) {
        _product.clear();
        for( var element in productSnapShot.docs){
          _product.insert(0,
            ProductModels.fromFireStore(element),
          );
        }
      }
      );
      notifyListeners();
      return _product;

    }catch(error){
      rethrow;
    }
  }

  Stream<List<ProductModels>> fetchProductStream(){
    try{
      return productDB.orderBy('createAt', descending: false).snapshots().map((snapShot) {
        _product.clear();
        for(var element in snapShot.docs){
        _product.insert(0,  ProductModels.fromFireStore(element));
        }
        return _product;
      });

    }catch(error){
      rethrow;
    }
  }

  // List<ProductModels> _product=[
  //   ProductModels(
  //       productId: 'guhijokgnjgfdfghgkmfld',
  //       productName: 'mobile',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg',
  //       productCategory: 'Fashion'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokgngfdsgtjgkmfld',
  //       productName: 'iphone',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'Book',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokgndfsyhjgkmfld',
  //       productName: 'computer',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'pc',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokgnfeasetgjgkmfld',
  //       productName: 'car',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'pc',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokewtyregnjgkmfld',
  //       productName: 'qassem',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'Watch',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokdgeryterugnjgkmfld',
  //       productName: 'abied',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'Watch',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  //   ProductModels(
  //       productId: 'guhijokgneterujgkmfld',
  //       productName: 'everything',
  //       productPrice: '4557',
  //       productSalePrice: '6546877',
  //       productImage: 'assets/images/129.png',
  //       quantity: '10',
  //       productCategory: 'Mobiles',
  //       description: 'fhdfjghghdfxgjhfxdgchkfjghxgckchjg'
  //   ),
  // ];
}