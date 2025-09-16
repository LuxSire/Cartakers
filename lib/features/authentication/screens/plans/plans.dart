import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  void _goToDashboard() {
    Get.offAllNamed('/dashboard'); // Adjust route as needed
  }

  void _showPremiumDialog() async {
    String? selectedPlan = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Premium Plan'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'monthly'),
            child: const Text('Monthly (250 CHF/month)'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'annual'),
            child: const Text('Annual (2000 CHF/year)'),
          ),
        ],
      ),
    );
    if (selectedPlan != null) {
      _goToStripe(selectedPlan);
    }
  }

  void _goToStripe(String plan) {
    // Replace with your actual Stripe checkout logic
    // For example, use Get.toNamed with arguments or launch a URL
    String stripeUrl;
    if (plan == 'monthly') {
      stripeUrl = 'https://your-stripe-checkout.com/monthly';
    } else {
      stripeUrl = 'https://your-stripe-checkout.com/annual';
    }
    // For web: launch in browser, for mobile: use WebView or url_launcher
    Get.toNamed('/stripe', arguments: {'url': stripeUrl});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Plan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Free Trial Card
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _goToDashboard,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.rocket_launch, size: 48, color: Colors.blue),
                          SizedBox(height: 16),
                          Text('Free Trial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Try all features for free. No credit card required.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              // Premium Card
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _showPremiumDialog,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star, size: 48, color: Colors.amber),
                          SizedBox(height: 16),
                          Text('Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Unlock all features.'),
                          SizedBox(height: 16),
                          Text('250 CHF/month or 2000 CHF/year', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}