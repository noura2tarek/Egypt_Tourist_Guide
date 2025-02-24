import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_strings_en.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/shared_prefs_service.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // Static method to return auth bloc object (to apply singleton pattern)
  static AuthBloc get(context) => BlocProvider.of(context);

  // handle login request event
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      // login using firebase auth
      final user = await FirebaseService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      // save token in shared prefs
      await SharedPrefsService.saveStringData(
        key: AppStringEn.tokenKey,
        value: user!.uid,
      );
      emit(AuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthError(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthError(message: 'Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(AuthError(message: 'An error occurred'));
    }
  }

  // handle sign up request event
  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      // sign up using firebase auth
      final user = await FirebaseService.createUserWithEmailAndPassword(
        email: event.user.email,
        password: event.user.password,
      );
      log('user id is : ${user?.uid}');
      //--> Save user data in firestore database
      await FirebaseService.addUser(
        uid: user!.uid,
        user: event.user,
      );
      emit(AccountCreated());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthError(message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthError(message: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to sign up'));
    }
  }

  // handle logout request event
  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await FirebaseService.signOut();
    await SharedPrefsService.clearStringData(key: AppStringEn.tokenKey);
  }
}
