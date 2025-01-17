import 'package:firebase_core/firebase_core.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,FirebaseAuthException;

class FirebaseAuthProvider extends AuthProvider{
  @override
  AuthUser? get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
        return AuthUser.fromFirebase(user);
    }
    else {return null;}
  }

  @override
  Future<AuthUser> createUser({required String email, required String password}) async{
    try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        final user = currentUser;
        if(user!=null){
          return user;
        } 
        else{
          throw UserNotLoggedInAuthException();
        }
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
          throw WeakPasswordAuthException();
      }
      else if(e.code == 'email-already-in-use'){
         throw EmailAlreadyExistsAuthException();
      }
      else if(e.code == 'invalid-email'){
          throw InvalidEmailAuthException();
      }
      else{
        throw GenericAuthException();
      }

    }
    catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user!=null){
        return user;
      }
      else{
        throw UserNotLoggedInAuthException();
      }
    }
    on FirebaseAuthException catch(e){
       if(e.code == 'invalid-credential'){
        throw UserNotFoundAuthException();
      }
      else if(e.code == 'invalid-password'){
        throw InvalidPasswordAuthException();
      }
      else{
        throw GenericAuthException();
      }
    }
    catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }
  
  @override
  Future<void> startService() {
    return Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

}
