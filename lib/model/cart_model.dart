import 'package:flutter/material.dart';
double? totalPrice;
class CartModel extends ChangeNotifier{
  final List _shopModel = [
    // [itemName, price, imagePath, color]
    ['Avocado', '24', 'assets/images/avocado.png', Colors.green],
    ['Banana', '42', 'assets/images/banana.png', Colors.orangeAccent],
    ['Apple', '95', 'assets/images/apple.png', Colors.red],
    ['Walnut', '34', 'assets/images/walnut.png', Colors.grey],
  ];

  // list of cart items

  List _cartItems = [];

  get shopItems =>  _shopModel;

  get cartItems => _cartItems;

  // add items to cart
  void addItemToCart(int index){
    _cartItems.add(_shopModel[index]);
    notifyListeners();
  }
  // remove items from cart
  void removeItemFromCart(int index){
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // calculate total price

  String calculateTotal(){
    totalPrice = 0;
    for(int i = 0; i<_cartItems.length; i++){
      totalPrice = (totalPrice!+double.parse(_cartItems[i][1]));
    }
    return totalPrice.toString();

  }
  // notifyListeners();
}

