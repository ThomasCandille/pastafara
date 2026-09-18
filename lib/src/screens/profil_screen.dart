import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error.code) {
          'user-not-found' => 'Aucun utilisateur trouvé pour cet e-mail.',
          'wrong-password' => 'Mot de passe incorrect.',
          _ => error.message ?? error.code,
        };
      });
    }
  }

  Future<void> _createAccount() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error.code) {
          'email-already-in-use' => 'Un compte existe déjà avec cet e-mail.',
          _ => error.message ?? error.code,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data ?? auth.currentUser;

        if (user != null) {
          return Column(
            children: [
              Text(user.email ?? ''),
              ElevatedButton(
                onPressed: auth.signOut,
                child: const Text('Se déconnecter'),
              ),
            ],
          );
        }

        return ListView(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            if (_error != null) Text(_error!),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Se connecter'),
            ),
            TextButton(
              onPressed: _createAccount,
              child: const Text('Créer un compte'),
            ),
          ],
        );
      },
    );
  }
}
