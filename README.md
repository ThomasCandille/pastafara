# Pastafara

Pastafara est une application Flutter consacrée aux recettes de pâtes. Elle permet de découvrir des plats, de conserver ses favoris et de générer une recette personnalisée avec un assistant culinaire basé sur l'IA.

## Prérequis

Avant de lancer le projet, installez :

- [Flutter](https://docs.flutter.dev/get-started/install) avec une version de Dart compatible avec `>= 3.13.3 < 4.0.0` ;
- Git ;
- Android Studio et le SDK Android pour une exécution sur Android ;
- Java 17 pour la compilation Android ;
- un émulateur Android ou un appareil physique connecté à Internet.

Vérifiez ensuite votre environnement :

```bash
flutter doctor
flutter devices
```

## Installation et configuration

Clonez le dépôt, puis installez les dépendances :

```bash
git clone https://github.com/ThomasCandille/pastafara.git
cd pastafara
flutter pub get
```

### Firebase

La configuration Firebase du projet est déjà préparée. Avant le premier lancement sur Android, récupérez le fichier `google-services.json`, fourni séparément à côté du projet, puis placez-le à l'emplacement suivant :

```text
android/app/google-services.json
```

Si un fichier du même nom existe déjà à cet emplacement, remplacez-le par celui qui vous a été fourni. Pour utiliser l'ensemble des fonctionnalités connectées, les services suivants doivent également être activés dans la console Firebase associée au projet :

- **Authentication** avec la méthode de connexion **E-mail/Mot de passe** ;
- **Cloud Firestore** pour les profils utilisateurs ;
- **Firebase AI Logic** pour la génération de recettes avec Gemini ;
- **App Check** avec le fournisseur Debug pendant le développement Android, puis Play Integrity en production.

En mode Debug, récupérez le jeton App Check affiché dans les journaux au premier lancement, puis enregistrez-le dans **Firebase Console > App Check > Gérer les jetons de débogage**. Ne publiez jamais ce jeton.

Pour connecter l'application à un autre projet Firebase :

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Cette commande régénère notamment `lib/firebase_options.dart` et la configuration native de chaque plateforme sélectionnée.

## Lancement du projet

Depuis la racine du projet, lancez :

```bash
flutter run
```

Pour choisir un appareil précis :

```bash
flutter run -d <identifiant_appareil>
```

Après une modification de la configuration native Firebase, effectuez une reconstruction complète :

```bash
flutter clean
flutter pub get
flutter run
```

## Fonctionnalités

- découverte et recherche de recettes de sauces fournies par TheMealDB ;
- génération d'une recette selon les ingrédients, les allergènes et le nombre de personnes ;
- création de compte et connexion par e-mail et mot de passe avecFirebase Authentication ;
- enregistrement local des recettes favorites avec Isar et en ligne sur Firebase Firestore ;
- Fonctionnalitée du telephone avec la connexion au parametre wifi du téléphone.

## Dépôt Git

Le code source est disponible sur GitHub : [ThomasCandille/pastafara](https://github.com/ThomasCandille/pastafara).
