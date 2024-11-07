import 'package:blott_mobile_assessment/views/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utills/assets.dart';
import '../utills/widgets/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsAllowingScreen extends StatefulWidget {
  const NotificationsAllowingScreen({super.key});

  @override
  _NotificationsAllowingScreenState createState() =>
      _NotificationsAllowingScreenState();
}

class _NotificationsAllowingScreenState extends State<NotificationsAllowingScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.messageNotification,
                  height: 98,
                  width: 98,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 24),
                const CustomText(
                  text: 'Get the most out of Blott ✅',
                  fontSize: 24,
                  isSmall: false,
                ),
                const SizedBox(height: 20),
                // Centered Text: Allow notifications description
                const CustomText(
                  color: Color(0xFF737373),
                  isSmall: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text:
                  'Allow notifications to stay in the loop with your payments, requests and groups.',
                  fontSize: 16,
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
                child: _continueButton()),
          ],
        ),
      ),
    );
  }


  // Method to build the continue button
  Widget _continueButton() {
    return ElevatedButton(
      onPressed: () {
        context.go('/home');
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Ensure the button spans full width
      ),
      child: const CustomText(
        color: Colors.white,
        isSmall: true,
        maxLines: 2,
        textAlign: TextAlign.center,
        text: 'Continue',
        fontSize: 16,
      ),
    );
  }
}
