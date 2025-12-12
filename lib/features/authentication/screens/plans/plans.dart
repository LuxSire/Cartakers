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
          child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Free Trial Card
Expanded(
  child: Card(
    elevation: 18,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _goToDashboard,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage('assets/images/img_trial.jpeg'), width: 48, height: 48),
            const SizedBox(height: 16),
            const Text('Free Trial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Try all features for free. No credit card required.'),
            const SizedBox(height: 24),
            // Features list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PlanFeatureRow(
                  feature: 'Full access to deals',
                  enabled: false,
                ),
                _PlanFeatureRow(
                  feature: 'Communication system',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Document visualization',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Full support',
                  enabled: false,
                ),
              ],
            ),
          const Spacer(),
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
          children: [
            Image(image: AssetImage('assets/images/img_premium.jpeg'), width: 48, height: 48),
            const SizedBox(height: 16),
            const Text('Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Unlock all features.'),
            const SizedBox(height: 16),
            const Text('250 CHF/month or 2000 CHF/year', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // Features list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PlanFeatureRow(
                  feature: 'Limited access to deals',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Full access to deals',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Communication system',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Document visualization',
                  enabled: true,
                ),
                _PlanFeatureRow(
                  feature: 'Full support',
                  enabled: true,
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    ),
  ),
),            ],
          ),
        ),

      ),
    ),  
    );
  }
}
class _PlanFeatureRow extends StatelessWidget {
  final String feature;
  final bool enabled;
  const _PlanFeatureRow({required this.feature, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(feature, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}