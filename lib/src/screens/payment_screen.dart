import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Token? _paymentToken;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CreditCard testCard = CreditCard(
    number: '4242424242424242',
    expMonth: 12,
    expYear: 23, // Updated to a future year
  );

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "your_publishable_key",
        merchantId: "your_merchant_id",
        androidPayMode: 'test', // Use 'production' for the live environment
      ),
    );
  }

  void setError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
      ),
    );
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(
                  CardFormPaymentRequest(),
                ).then((paymentMethod) {
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Received ${paymentMethod.id}'),
                    ),
                  );
                  // ignore: invalid_return_type_for_catch_error
                }).catchError(setError);
              },
              child: const Text('Pay with Card'),
            ),
            if (_paymentToken != null)
              Text('Payment token: ${_paymentToken!.tokenId}'),
            if (_error != null) Text('Error: $_error'),
          ],
        ),
      ),
    );
  }
}
