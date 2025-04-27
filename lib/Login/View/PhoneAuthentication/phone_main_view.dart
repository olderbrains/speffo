import 'package:flutter/material.dart';

class PhoneMainView extends StatefulWidget {
  const PhoneMainView({super.key});

  @override
  State<PhoneMainView> createState() => _PhoneMainViewState();
}

class _PhoneMainViewState extends State<PhoneMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Country/Region',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('India (+91)'),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Phone number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const Text(
              "We'll call or text you to confirm your number. Standard message and data rates apply.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            _buildSocialButton('Continue with email', Icons.email),
            const SizedBox(height: 12),
            _buildSocialButton('Continue with Apple', Icons.apple),
            const SizedBox(height: 12),
            _buildSocialButton('Continue with Google', Icons.g_mobiledata),
            const SizedBox(height: 12),
            _buildSocialButton('Continue with Facebook', Icons.facebook),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
