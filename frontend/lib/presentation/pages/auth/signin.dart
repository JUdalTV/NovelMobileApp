import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/auth/auth_bloc.dart'; 
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../core/utils/input_validator.dart';
import 'signup.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../../../main.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkSavedAuth();
    _loadSavedCredentials();
  }
  Future<void> _checkSavedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      if (!mounted) return;
      context.read<AuthBloc>().add(AutoSignInEvent(token: token, email: ''));
    }
  }
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      setState(() {
        _emailController.text = prefs.getString('email') ?? '';
        _rememberMe = true;
      });
    }
  }

Future<void> _saveCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  if (_rememberMe) {
    await prefs.setString('email', _emailController.text);
    await prefs.setBool('rememberMe', true);
  } else {
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('rememberMe', false);
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _performSignIn(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    await _saveCredentials(); // Lưu credentials nếu remember me được chọn
    
    context.read<AuthBloc>().add(
      SignInRequested(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is Authenticated) {
            final novelRepository = Provider.of<NovelRepository>(context, listen: false);
            
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  novelRepository: novelRepository,
                ),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400, // Giới hạn chiều rộng
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header
                          _buildHeader(),

                          const SizedBox(height: 32),

                          // Email Field
                          _buildEmailField(),

                          const SizedBox(height: 16),

                          // Password Field
                          _buildPasswordField(),

                          const SizedBox(height: 16),

                          // Remember Me Checkbox
                          _buildRememberMe(),

                          const SizedBox(height: 8),

                          // Sign In Button
                          _buildSignInButton(),

                          const SizedBox(height: 16),

                          // Sign Up Link
                          _buildSignUpLink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 36,
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Chào mừng đạo hữu đã quay lại!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          validator: InputValidator.validateEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration(
            hintText: 'Nhập email',
            prefixIcon: Icons.email_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mật khẩu',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: InputValidator.validatePassword,
          decoration: _inputDecoration(
            hintText: 'Nhập mật khẩu',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state is AuthLoading ? null : () => _performSignIn(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 146, 200, 245),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          child: state is AuthLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chưa có căn cơ? ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          ),
          child: Text(
            'Đăng kí',
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      prefixIcon: Icon(prefixIcon, color: Colors.grey),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _outlineInputBorder(),
      enabledBorder: _outlineInputBorder(),
      focusedBorder:
          _outlineInputBorder(color: const Color(0xff078fff), width: 2),
      errorBorder: _outlineInputBorder(color: Colors.red),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  OutlineInputBorder _outlineInputBorder({
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? Colors.grey[300]!,
        width: width,
      ),
    );
  }
  Widget _buildRememberMe() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value!;
              });
            },
            activeColor: const Color(0xff078fff),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Ghi nhớ tài khoản',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}
}
