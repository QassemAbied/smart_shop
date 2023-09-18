import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  UserModels{
  final String userId, userName,userEmail,userAdders,userImage;
  final List usercart,userwish;
  final Timestamp createAt;
  UserModels({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userAdders,
    required this.userImage,
    required this.usercart,
    required this.userwish,
    required this.createAt,
  }
  );
}