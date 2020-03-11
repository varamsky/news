import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/homepage.dart';
import 'package:news/signupPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController _email = TextEditingController() ,_password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  var width;

  Future<FirebaseUser> handleGoogleSignIn() async{
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
    );

    FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;

    print("signed in " + user.displayName);

    return user;
  }

  handleGoogleSignOut(){
    _googleSignIn.signOut();
    print("Signed Out");
  }

  Future<FirebaseUser> handleEmailSignIn(String email,String password) async{
    print("in handleEmailSignIn() email $email , password $password");
    //FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

    print("Signed in email " + user.email);

    if(user.email != null)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(isLogin: true,)));

    return user;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    //String _email,_password;
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN'),centerTitle: true,),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlutterLogo(size: 100.0),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _email,
                  /*onChanged: (value) {
                    setState(() {
                      _email = (value != null)?value:_email;
                    });
                    print("_email $_email , value $value");
                  },*/
                  decoration: InputDecoration(
                    hintText: '_email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  enableSuggestions: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _password,
                  /*onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },*/
                  decoration: InputDecoration(
                      hintText: '_password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                child: MaterialButton(
                  onPressed: () {
                    print('_email : ${_email.text} and _password : ${_password.text}');
                    handleEmailSignIn(_email.text,_password.text);
                    //handleEmailSignIn('newemail@gmail.com','_password2');
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Text('Login',style: TextStyle(color: Colors.white),),
                  color: Colors.blue,
                  minWidth: width,
                  height: 40.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MaterialButton(
                  onPressed: () => handleGoogleSignIn().then((FirebaseUser user)=>print(user)).catchError((e)=>print(e)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Text('Login with google',style: TextStyle(color: Colors.white),),
                  color: Colors.red,
                  minWidth: width,
                  height: 40.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: MaterialButton(
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUpPage())),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Text('New User? Sign Up',style: TextStyle(color: Colors.white),),
                  color: Colors.red,
                  minWidth: width,
                  height: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
