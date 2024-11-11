import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_db_helper.dart';
import '../utills/widgets/custom_text.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utills/widgets/custom_text_form_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateFormState);
    _lastNameController.addListener(_updateFormState);
  }

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

  // Expose this method for testing
  bool get isFormValid => _isFormValid;

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

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextField(
          controller: _firstNameController,
          hintText: 'First Name',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _lastNameController,
          hintText: 'Last Name',
        ),
        const SizedBox(height: 160),
        _isLoading
            ? Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        )
            : _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 1.4),
      child: ElevatedButton(
        onPressed: _isFormValid ? _onSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.4),
          shape: const CircleBorder(),
        ),
        child: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    setState(() {
      _isLoading = true;
    });

    await DatabaseHelper.instance.insertUser(
      _firstNameController.text,
      _lastNameController.text,
    );

    Provider.of<AuthProvider>(context, listen: false).setUserData(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    Permission.notification.request();
    context.go('/notifications');
  }
}
