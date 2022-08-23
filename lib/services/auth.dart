import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickquiz/models/user.dart';

class AuthService{
  FirebaseAuth auth = FirebaseAuth.instance;

  User2? user; _userFromFirebaseUser(User user){
    return user !=null ? User2(uid: user.uid):null;
  }

Future signInEmailAndPass(String email, String password) async{
  try{
    UserCredential result = await auth.signInWithEmailAndPassword
      (email: email, password: password);
    User? user = result.user;
  }
  catch(e){
    print(e.toString());
  }
}
  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User? user = result.user;
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}