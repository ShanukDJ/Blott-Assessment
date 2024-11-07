import 'package:blott_mobile_assessment/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utills/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controllers for first name and last name fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Boolean to track whether the form is valid
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Listeners to track changes in text fields and validate form
    _firstNameController.addListener(_updateFormState);
    _lastNameController.addListener(_updateFormState);
  }

  // Update form validity based on text field values
  void _updateFormState() {
    setState(() {
      _isFormValid = _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const CustomText(
              text: 'Your Legal Name',
              fontSize: 30,
              isSmall: false,
            ),
            const SizedBox(height: 30),
            const CustomText(
              color: Color(0xFF737373),
              isSmall: true,
              maxLines: 2,
              text: 'We need to know a bit about you so that we can create your account.',
              fontSize: 16,
            ),
            const SizedBox(height: 30),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  // Method to build the form widget
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTextField(
          controller: _firstNameController,
          hintText: 'First Name',
        ),
        const SizedBox(height: 30),
        _buildTextField(
          controller: _lastNameController,
          hintText: 'Last Name',
        ),
        const SizedBox(height: 160),
        _buildSubmitButton(),
      ],
    );
  }

  // Method to build the text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Method to build the submit button
  Widget _buildSubmitButton() {
    return Padding(
      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width / 1.4),
      child: ElevatedButton(
        onPressed:  () async {
          if (_isFormValid) {
            await Provider.of<AuthProvider>(context, listen: false).signUpAnonymously();
            await FirestoreAuthService().saveUserName(_firstNameController.text);
            Permission.notification.request();
            context.go('/notifications');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.4),
          shape: const CircleBorder(),
        ),
        child: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.white,
          size: 20, // Icon size
        ),
      ),
    );
  }
}
