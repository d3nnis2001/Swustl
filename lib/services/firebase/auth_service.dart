import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swustl/models/user_data.dart';
import 'package:swustl/services/firebase/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  // Current User Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current User
  User? get currentUser => _auth.currentUser;

  // Registrierung mit E-Mail und Passwort
  Future<UserCredential> registerWithEmailAndPassword(
    String email, 
    String password, 
    UserData userData
  ) async {
    try {
      // Nutzer in Firebase Auth erstellen
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Nutzer-ID aus Firebase Auth für Firestore verwenden
      final userId = userCredential.user!.uid;
      userData.id = userId;
      
      // Nutzerdaten in Firestore speichern
      await _userService.createOrUpdateUser(userData);
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Anmeldung mit E-Mail und Passwort
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In wurde abgebrochen');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Anmeldung bei Firebase Auth
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Prüfen, ob der Nutzer neu ist
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Basisinformationen aus Google-Konto extrahieren
        final user = userCredential.user!;
        final userData = UserData()
          ..id = user.uid
          ..firstName = user.displayName?.split(' ').first ?? ''
          ..lastName = user.displayName?.split(' ').last ?? ''
          ..username = user.email?.split('@').first ?? '';
        
        // Nutzerdaten in Firestore speichern
        await _userService.createOrUpdateUser(userData);
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // GitHub Sign-In
  Future<UserCredential> signInWithGitHub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();
      return await _auth.signInWithProvider(githubProvider);
    } catch (e) {
      rethrow;
    }
  }

  // Passwort zurücksetzen
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Abmeldung
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}