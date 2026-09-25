import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_model.dart' as app;
import '../providers/user_provider.dart';
import '../router/route_names.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
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
    } on FirebaseException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message ?? error.code;
      });
    }
  }

  Future<void> _addInfoToDatabase() async {
    final user = auth.currentUser;
    if (user == null) return;

    final appUser = app.User(
      email: user.email ?? '',
      favoriteMeals: const [],
      allergies: const [],
    );

    await ref.read(userServiceProvider).addUserToDatabase(user.uid, appUser);
  }

  Future<void> _createAccount() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      await _addInfoToDatabase();
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error.code) {
          'email-already-in-use' => 'Un compte existe déjà avec cet e-mail.',
          _ => error.message ?? error.code,
        };
      });
    } on FirebaseException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message ?? error.code;
      });
    }
  }

  Future<void> _openWifiSettings() async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.wifi);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'ouvrir les réglages Wi-Fi."),
        ),
      );
    }
  }

  Widget _buildConnectedProfile(BuildContext context, User user) {
    final email = user.email?.trim().isNotEmpty == true
        ? user.email!.trim()
        : 'Utilisateur';

    return ColoredBox(
      color: const Color(0xFFFFFAF8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD763),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/test_image.png',
                          width: 94,
                          height: 94,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        email,
                        style: const TextStyle(
                          color: Color(0xFF2D1B17),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: () => context.goNamed(AppRouteNames.favorite),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 23,
                          backgroundColor: Color(0xFFFFE2D8),
                          child: Icon(
                            Icons.favorite,
                            color: Color(0xFFC52820),
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mes favoris',
                                style: TextStyle(
                                  color: Color(0xFF2D1B17),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Retrouve toutes tes recettes préférées',
                                style: TextStyle(
                                  color: Color(0xFF6C5A52),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF8B776F),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: _openWifiSettings,
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundColor: Color(0xFFDCEEFF),
                          child: Icon(
                            Icons.wifi,
                            color: Color(0xFF1665A8),
                            size: 25,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Connecter mon Thermomix',
                                style: TextStyle(
                                  color: Color(0xFF2D1B17),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Connexion au thermomix WIFI',
                                style: TextStyle(
                                  color: Color(0xFF6C5A52),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: Color(0xFF8B776F)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: auth.signOut,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFC52820),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _authInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF8B776F)),
      prefixIcon: Icon(icon, color: const Color(0xFF6C5247)),
      filled: true,
      fillColor: const Color(0xFFFFF0EB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFC52820), width: 1.5),
      ),
    );
  }

  Widget _buildLoginForm() {
    return ColoredBox(
      color: const Color(0xFFFFFAF8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 16,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 29,
                      backgroundColor: Color(0xFFFFD763),
                      child: Icon(
                        Icons.person_outline,
                        color: Color(0xFF735B15),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Bienvenue !',
                      style: TextStyle(
                        color: Color(0xFF2D1B17),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Connecte-toi pour retrouver ton espace gourmand.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6C5A52),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: _authInputDecoration(
                        label: 'E-mail',
                        icon: Icons.mail_outline,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _signIn(),
                      decoration: _authInputDecoration(
                        label: 'Mot de passe',
                        icon: Icons.lock_outline,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE2D8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Color(0xFFC52820),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC52820),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: _createAccount,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6C5247),
                      ),
                      child: const Text('Créer un compte'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data ?? auth.currentUser;

        if (user != null) {
          return _buildConnectedProfile(context, user);
        }

        return _buildLoginForm();
      },
    );
  }
}
