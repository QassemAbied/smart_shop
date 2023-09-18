import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_store_app/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

import '../service/my_app_method.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishLitModels> wishListItem = {};
  Map<String, WishLitModels> get getWishListItem {
    return wishListItem;
  }

  bool isWishList({required String proId}) {
    return wishListItem.containsKey(proId);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final wishListDB = FirebaseFirestore.instance.collection('users');
  Future addWishListToFirebase({
    required BuildContext context,
    required String prodId,
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
    final wishId = Uuid().v4();
    try {
      wishListDB.doc(uid).update({
        'user_wish': FieldValue.arrayUnion([
          {
            'prodId': prodId,
            'wishId': wishId,
          }
        ]),
      });
      await fetchWishList();
      await MethodApp.ToastBar(text: 'Successfully added to WishList', );
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future fetchWishList() async {
    final User? user = auth.currentUser;
    if (user == null) {
      wishListItem.clear();
      return;
    }
    final uid = user.uid;
    final wishDoc = await wishListDB.doc(uid).get();
    final data = wishDoc.data();
    if (data == null || !data.containsKey('user_wish')) {
      return;
    }
    try {
      final leng = wishDoc.get('user_wish').length;
      for (int index = 0; index < leng; index++) {
        wishListItem.putIfAbsent(
          wishDoc.get('user_wish')[index]['prodId'],
          () => WishLitModels(
            productId: wishDoc.get('user_wish')[index]['prodId'],
            wishlistId: wishDoc.get('user_wish')[index]['wishId'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // void addWishList({required String proId}){
  //
  //   if(isWishList(proId: proId)== false){
  //     wishListItem.putIfAbsent(proId, () =>
  //         WishLitModels(
  //           productId: proId,
  //           wishlistId: Uuid().v4(),
  //         ),
  //     );
  //   }else{
  //     removeOneProduct(proId: proId);
  //   }
  //
  //   notifyListeners();
  //
  // }

  Future<void> removeOneProduct(
      {required String proId,
      required String wishListId,
      required BuildContext context}) async {
    User? user = auth.currentUser;
    final uid = user!.uid;

    try {
      await wishListDB.doc(uid).update({
        'user_wish': FieldValue.arrayRemove([
          {
            'prodId': proId,
            'wishId': wishListId,
          }
        ]),
      });
      await fetchWishList();
      wishListItem.remove(proId);
      await MethodApp.ToastBar(text: 'Successfully removed to WishList', );
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  void removeAllWishList() {
    User? user = auth.currentUser;
    final uid = user!.uid;
    wishListDB.doc(uid).update({
      'user_wish': [],
    });
    wishListItem.clear();
    notifyListeners();
  }
}
