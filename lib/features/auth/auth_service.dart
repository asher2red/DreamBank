import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginMethod { google, apple }

class LoginProfile {
  const LoginProfile(this.uid, this.name, this.email);
  final String uid;
  final String name;
  final String? email;
}

abstract interface class AuthService {
  Stream<LoginProfile?> get changes;
  Future<void> signIn(LoginMethod method);
  Future<void> signOut();
}

class LoginFailure implements Exception {
  const LoginFailure(this.message, {this.cancelled = false});
  final String message;
  final bool cancelled;
}

String loginErrorMessage(String code) => switch (code) {
  'network-request-failed' => '인터넷 연결을 확인해 주세요.',
  'account-exists-with-different-credential' =>
    '이 이메일로 가입한 다른 로그인 수단을 사용해 주세요.',
  'user-disabled' => '사용이 제한된 계정이에요.',
  'too-many-requests' => '잠시 쉬었다가 다시 시도해 주세요.',
  _ => '로그인을 완료하지 못했어요. 잠시 후 다시 시도해 주세요.',
};

// Native Firebase configuration is deliberately opt-in. An unconfigured build
// never creates an identity or changes the local account.
final authServiceProvider = FutureProvider<AuthService>((ref) async {
  if (!const bool.fromEnvironment('FIREBASE_ENABLED')) {
    throw const LoginFailure('로그인 서비스 연결을 준비하고 있어요. 연결이 완료되면 이용할 수 있어요.');
  }
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    throw const LoginFailure('이 기기에서는 아직 로그인을 지원하지 않아요.');
  }
  try {
    final app = Firebase.apps.isEmpty
        ? await Firebase.initializeApp()
        : Firebase.app();
    return FirebaseAuthService(FirebaseAuth.instanceFor(app: app));
  } catch (_) {
    throw const LoginFailure('지금은 계정을 연결할 수 없어요. 잠시 후 다시 시도해 주세요.');
  }
}, retry: (_, _) => null);

final loginProfileProvider = StreamProvider<LoginProfile?>((ref) async* {
  final service = await ref.watch(authServiceProvider.future);
  yield* service.changes;
}, retry: (_, _) => null);

class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._auth);
  final FirebaseAuth _auth;
  Future<void>? _googleInitialization;
  bool _busy = false;

  @override
  Stream<LoginProfile?> get changes => _auth.authStateChanges().map(
    (user) => user == null
        ? null
        : LoginProfile(
            user.uid,
            user.displayName ?? 'DreamBank 사용자',
            user.email,
          ),
  );

  Future<void> _exclusive(Future<void> Function() operation) async {
    if (_busy) return;
    _busy = true;
    try {
      await operation();
    } on GoogleSignInException catch (error) {
      throw LoginFailure(
        loginErrorMessage(error.code.name),
        cancelled: error.code == GoogleSignInExceptionCode.canceled,
      );
    } on FirebaseAuthException catch (error) {
      throw LoginFailure(
        loginErrorMessage(error.code),
        cancelled:
            error.code == 'web-context-cancelled' ||
            error.code == 'canceled' ||
            error.code == 'popup-closed-by-user',
      );
    } on LoginFailure {
      rethrow;
    } catch (_) {
      throw const LoginFailure('요청을 완료하지 못했어요. 다시 시도해 주세요.');
    } finally {
      _busy = false;
    }
  }

  @override
  Future<void> signIn(LoginMethod method) => _exclusive(() async {
    if (method == LoginMethod.apple) {
      await _auth.signInWithProvider(AppleAuthProvider());
      return;
    }
    // Android reads generated resources; iOS reads GIDClientID in Info.plist.
    await (_googleInitialization ??= GoogleSignIn.instance.initialize());
    final google = await GoogleSignIn.instance.authenticate();
    final token = google.authentication.idToken;
    if (token == null) throw const LoginFailure('Google 인증을 완료하지 못했어요.');
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(idToken: token),
    );
  });

  @override
  Future<void> signOut() => _exclusive(() async {
    // Firebase is the session authority. Google SDK cleanup must not prevent logout.
    await _auth.signOut();
    if (_googleInitialization != null) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        /* Session ended. */
      }
    }
  });
}
