import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grosaryshop/model/cart_model.dart';
import 'package:grosaryshop/pages/phone_pay_payment.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';

import '../model/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // *********** phone pay ***************
  String environment = "UAT_SIM";
  String appId = '';

  // *********** From developer ::  "M1U6N00AIFUD" ::      ********************

  String merchantId = 'PGTESTPAYUAT';
  bool enableLogging = true;
  String checksum = '';
  String saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';
  String saltIndex = '1';
  String callBackUrl = 'https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1';
  String body = '';
  Object? result;
  String apiEndPoint = '/pg/v1/pay';


  //******************   this all the variables for the checksum values ************

  // ********************  start the method of getCheckSumValue values ***************

  getCheckSum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "9999999999",
      "callbackUrl": callBackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };
    String base64Body = base64.encode(utf8.encode(jsonEncode(requestData)));
    checksum =
    '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    return base64Body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phonePayInit();
    body = getCheckSum().toString();
  }

 // ********************  start the method of getCheckSumValue values ***************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartModel>(
        builder: (context,value,child){
          return Column(
            children: [
              SizedBox(height: 35,),
              Text(
                "My Cart",
                style: GoogleFonts.notoSerif(
                    fontSize: 39, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(child:
               value.cartItems.length == 0 ? 
                   Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Your Cart",style: TextStyle(
                           fontWeight: FontWeight.bold,fontSize: 27,color: Colors.red
                         ),textAlign: TextAlign.center,),
                         Container(
                             height: 100,width: 100,
                             child: Image.asset('assets/images/empty_cart.gif',fit: BoxFit.cover,)),
                         Text("is Empty",style: TextStyle(
                             fontWeight: FontWeight.bold,fontSize: 27,color: Colors.red
                         ),textAlign: TextAlign.center,),
                       ],
                     ),
                   ):
               ListView.builder(
                   itemCount: value.cartItems.length,
                   itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Container(
                         decoration: BoxDecoration(
                             color: Colors.grey[200],borderRadius: BorderRadius.circular(12)
                         ),
                         child: ListTile(
                           leading: Image.asset(value.cartItems[index][2].toString(),height: 38,),
                           title: Text(value.cartItems[index][0].toString()),
                           subtitle: Text("\$ "+value.cartItems[index][1].toString()),
                           trailing: IconButton(
                             onPressed: (){
                               Provider.of<CartModel>(context,listen: false).removeItemFromCart(index);
                             },icon: Icon(Icons.cancel),
                           ),
                         ),
                       ),
                     );
                   })
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green
                ),
                padding: EdgeInsets.all(23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Total Price",style: TextStyle(
                            color: Colors.white
                        ),),
                        Text(value.calculateTotal().toString(),style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold,color: Colors.white
                        ),),
                      ],
                    ),
                   totalPrice == 0 ? GestureDetector(
                     onTap: (){
                       showDialog(
                           context: context,
                           builder: (BuildContext context){
                             return AlertDialog(
                               title: Text("Enable Payment After Find Itmes",style: TextStyle(
                                   fontSize: 18,color: Colors.red
                               ),),

                             );
                           }
                       );
                     },
                     child:
                     Container(
                         padding: EdgeInsets.all(11),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(
                                 color: Colors.white,width: 1.4
                             )
                         ),
                         child: Row(
                           children: [
                             Text("No Payment",style: TextStyle(
                                 color: Colors.white
                             ),),
                             Icon(Icons.arrow_forward_ios,size: 12,color: Colors.white,),
                           ],
                         )
                     ),
                   ): GestureDetector(
                      onTap:() {
                        startPgTransaction();
                        print('shfhsdhfdshfhdshfdshf');
                      },
                      child: Container(
                        padding: EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,width: 1.4
                          )
                        ),
                          child: Row(
                            children: [
                              Text("Pay now",style: TextStyle(
                                color: Colors.white
                              ),),
                              Icon(Icons.arrow_forward_ios,size: 12,color: Colors.white,),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      )
    );
  }
  void phonePayInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    try {
      var response = PhonePePaymentSdk.startPGTransaction(
          body, callBackUrl, checksum, {}, apiEndPoint, ' ');
      response
          .then((val) => {
        setState(() {
          if (val != null) {
            String status = val['status'].toString();
            String error = val['error'].toString();
            if (status == 'SUCCESS') {
              result = 'Flow Complete Status : SUCCESS!';
            } else {
              result =
              'Flow Complete Status : $status and error is $error !';
            }
          } else {
            result = 'Flow Incomplete sorry !';
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      result = {'error': error};
    });
  }
}
