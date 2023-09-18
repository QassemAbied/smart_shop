import 'package:flutter/cupertino.dart';
import 'package:new_store_app/models/recently_model.dart';

class ViewedRecentlyProvider with ChangeNotifier{
 final Map<String , ViewedRecentlyModels> viewedItem={};
  Map<String , ViewedRecentlyModels> get getViewedItem{
   return viewedItem;
 }

 void addViewedRecently({required String proId}){


   viewedItem.putIfAbsent(proId, () =>
         ViewedRecentlyModels(
           productId: proId,

         )
   );
 }

 removeOneProduct({required String proId}){
   viewedItem.remove(proId);
   notifyListeners();
 }
 void removeAllViewedRecently(){
   viewedItem.clear();
   notifyListeners();
 }

}