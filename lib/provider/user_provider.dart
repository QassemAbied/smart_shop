import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_store_app/models/user_model.dart';

import '../models/user_model.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier{
  UserModels? userModels;
  UserModels? get getAuthModels{
    return userModels;
  }

  Future<UserModels?> fetchUserData()async{
    FirebaseFirestore firestore= FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if(user ==null){
      return null;
    }
    final uid = user.uid;
    try{
      final userDoc= await firestore.collection('users').doc(uid).get();
      final userDocDict= userDoc.data();
      userModels = UserModels(
          userId: userDoc.get('userId'),
          userName: userDoc.get('userName'),
          userEmail: userDoc.get('userEmail'),
          userAdders: userDoc.get('userAdders'),
          userImage: userDoc.get('userImage'),
          usercart: userDocDict!.containsKey('user_cart')?userDoc.get('user_cart'):[],
          userwish: userDocDict.containsKey('user_wish')?userDoc.get('user_wish'):[],
          createAt:  userDoc.get('createAt'),
      );
      notifyListeners();
      return userModels;
    }on FirebaseException catch(error){
      throw error.message.toString();
    }catch(error){
      rethrow;
    }

  }
}