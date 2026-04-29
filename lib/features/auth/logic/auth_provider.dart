import 'package:ecommerce_app/features/auth/data/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/local_storage/prefs_provider.dart';
import '../../../core/local_storage/biometric_helper.dart'; 
import '../data/auth_repository.dart';

// 1. Define the possible states
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String token;
  AuthSuccess(this.token);
}
class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

// ---> ADDED: Secure Storage Provider <---
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// 2. Create the Controller
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _secureStorage;
  final BiometricHelper _biometricHelper = BiometricHelper();

  // Inject secure storage into the constructor
  AuthController(this._repository, this._secureStorage) : super(AuthInitial());

  // --- MANUAL LOGIN ---
  Future<void> login(String email, String password) async {
    state = AuthLoading(); 
    
    try {
      final token = await _repository.login(email, password);
      
      // SUCCESS! Secretly save the credentials to the encrypted keystore
      await _secureStorage.write(key: 'saved_email', value: email);
      await _secureStorage.write(key: 'saved_password', value: password);
      
      state = AuthSuccess(token); 
    } catch (e) {
      state = AuthError(e.toString()); 
    }
  }

  // --- BIOMETRIC LOGIN ---
  Future<void> loginWithBiometrics() async {
    // 1. Check if they have saved credentials from a previous manual login
    final savedEmail = await _secureStorage.read(key: 'saved_email');
    final savedPassword = await _secureStorage.read(key: 'saved_password');

    if (savedEmail == null || savedPassword == null) {
      state = AuthError("No fingerprint linked. Please login with your email and password first.");
      return;
    }

    // 2. Trigger the hardware scanner
    final didAuthenticate = await _biometricHelper.authenticate();

    if (didAuthenticate) {
      // 3. Scanner passed! Silently run the manual login process using the saved keystore data
      await login(savedEmail, savedPassword);
    } else {
      // They cancelled the scan or the fingerprint didn't match
      state = AuthError("Biometric authentication failed or was canceled.");
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    await _repository.logout(); 
    
    // Pro-Tip: Leaving these commented out means the user can log out, but still log back in with their fingerprint later.
    // If you UNCOMMENT these, logging out will permanently delete their fingerprint link, forcing them to type their password again.
    // await _secureStorage.delete(key: 'saved_email');
    // await _secureStorage.delete(key: 'saved_password');
    
    state = AuthInitial(); 
  }
}

// 3. Create the Riverpod Providers 
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider); 
  return AuthRepository(prefs); 
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider); // Watch the new secure storage
  
  return AuthController(repository, secureStorage); // Pass it to the controller
});

// 4. USER PROFILE PROVIDER
final userProfileProvider = FutureProvider<UserModel>((ref) async {
  
  final prefs = ref.watch(sharedPrefsProvider);
  final savedToken = prefs.getString('auth_token');
  
  if (savedToken != null) {
    final repository = ref.read(authRepositoryProvider);
    return await repository.getUserProfile(savedToken);
  }
  
  throw Exception('User is not authenticated');
});