import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech387almir/helpers/http_exception.dart';
import 'package:tech387almir/providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const routeName = '/auth';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisible = true;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Greška!'),
              content: Text(message),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            ));
  }

  void _togglePasswordView() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
      //prosljedjivanje emaila home screenu
      await Provider.of<AuthProvider>(context, listen: false)
          .emailF(_authData['email']!);
    } on HttpException catch (error) {
      var errorMessage = 'Authetication failed';
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Email nije validan';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email ne postoji!';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Password nije tačan.';
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 320,
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/productarena.png'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Pogrešan format emaila!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _passwordVisible,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Morate unijeti password!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                      ),
                      child: const Text('LOGIN'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
