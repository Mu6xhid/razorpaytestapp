
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      handleExternalWallet,
    );
  }

  void openCheckout() {
  final key = dotenv.env['RAZORPAY_KEY_ID'];
print(key);
  if (key == null || key.isEmpty) {
    debugPrint('Razorpay Key ID not found in .env');
    return;
  }

  var options = {
    'key': key,
    'amount': 49900,
    'currency': 'INR',
    'name': 'My Shopping App',
    'description': 'T Shirt',
    'prefill': {
      'contact': '9876543210',
      'email': 'test@example.com',
    },
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint('Error: $e');
  }
}

  void handlePaymentSuccess(PaymentSuccessResponse response) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Successful! ID: ${response.paymentId}',
        ),
        backgroundColor: Colors.green,
      ),
    );

  }

  void handlePaymentError(PaymentFailureResponse response) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed: ${response.message}',
        ),
        backgroundColor: Colors.red,
      ),
    );

  }

  void handleExternalWallet(ExternalWalletResponse response) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Wallet: ${response.walletName}',
        ),
      ),
    );

  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay Payment App"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/034/882/699/small/ai-generated-t-shirt-mockup-clip-art-free-png.png',
              height: 200,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            const Text(
              "T Shirt",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "₹499",
              style: TextStyle(
                fontSize: 22,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: openCheckout,
              child: const Text("Buy Now"),
            ),

          ],
        ),
      ),
    );
  }
}
