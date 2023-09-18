import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:new_store_app/screens/stripe_payment/stripe_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(
      BuildContext context, int amount, String currency) async {
    try {
      String clientSecret =
          await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret, context);
      await Stripe.instance.presentPaymentSheet().then((value) {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment is Successful')));
    } catch (error) {
      if (error is StripeException) {
        //Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('An error occurred ${error.error.localizedMessage}')));
        return print('$error---------------------------------------------');
      } else {
        //Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occurred $error')));
        return print('$error---------------------------------------------');
      }
    }
  }

  static Future<void> _initializePaymentSheet(
      String clientSecret, BuildContext context) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Qassem",
          customerId: 'customer',
          customerEphemeralKeySecret: 'ephemeralKey',
          customFlow: true),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }
}
