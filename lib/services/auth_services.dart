import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_conference_app1/Models/user.dart';
import 'package:video_conference_app1/Models/user_provider.dart';
import 'package:video_conference_app1/Screens/Auth/signup.dart';
import 'package:video_conference_app1/Widgets/loader.dart';
import 'package:video_conference_app1/ZegoCloud/homepage.dart';
import 'package:video_conference_app1/services/database_services.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? user;

  Widget checkLogin() {
    print("checkingLogin function called");
    return Consumer(builder: (context, ref, child) {
      return StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData) {
            user = snapshot.data;
            final uid = user?.uid;

            if (uid != null && uid.isNotEmpty) {
              ref
                  .read(userDataNotifierProvider.notifier)
                  .fetchCurrentUserData(uid);
            } else {
              print("Error: UID is null or empty: retuning to signup screen");
              return const SignupScreen();
            }

            print('User Firebase: ${user?.email}');
            print("User is signed in: to home screen : ${user?.displayName}");

            return HomePage();
          } else {
            print("User is not signed in: to auth screen");
            return const SignupScreen();
          }
        },
      );
    });
  }

  Future<bool> login(String email, String password, WidgetRef ref) async {
    print("login function called");
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        user = credential.user;
        ref
            .read(userDataNotifierProvider.notifier)
            .fetchCurrentUserData(user?.uid)
            .then((value) {
          ref
              .read(userDataNotifierProvider.notifier)
              .updateCurrentUserData(isOnline: true);
        });

        return true;
      }
    } catch (e) {
      print("Error: $e");
      print("login failed");
      return false;
    }
    return false;
  }

  Future<bool> signup(
      String name, String email, String password, WidgetRef ref) async {
    print("signup function called");
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        user = credential.user;
        createUserProfile(
            userProfile: UserData(
          uid: user?.uid,
          name: name,
          email: email,
          isOnline: true,
        ));
        ref
            .read(userDataNotifierProvider.notifier)
            .fetchCurrentUserData(user?.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    BuildContext context,
    Function(String) onCodeSent,
    Function(UserCredential) onVerificationCompleted,
    Function(FirebaseAuthException) onVerificationFailed,
  ) async {
    try {
      print("verifying phone number $phoneNumber");
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically signs in the user if verification is successful
          // final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential).then((value) {
            onVerificationCompleted(value);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e);
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          // You need to ask the user to input the OTP here.
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto-retrieval timeout.");
        },
      );
    } catch (e) {
      print("error verifying phoneNumber: $e");
    }
  }

  Future<bool> verifyOTP(
      String verificationId, String smsCode, BuildContext context,
      {String? name = ""}) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign in the user with the credential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print("Phone number successfully verified");
      return createOrLoginUserAfterPhoneVerification(userCredential,
          name: name);
      // Handle successful sign-in here (e.g., navigate to the home page)
    } catch (e) {
      print("Failed to verify OTP: $e");
      return false;
    }
  }

  Future<bool> createOrLoginUserAfterPhoneVerification(
      UserCredential userCredential,
      {String? name = "",
      WidgetRef? ref}) async {
    try {
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;
        final phoneNumber = user.phoneNumber;

        bool userExists = await checkExistingUser(uid);

        if (userExists) {
          print("User already exists with UID: $uid");
          ref
              ?.read(userDataNotifierProvider.notifier)
              .fetchCurrentUserData(user.uid)
              .then((value) {
            ref
                .read(userDataNotifierProvider.notifier)
                .updateCurrentUserData(isOnline: true);
          });
          return true;
        } else {
          UserData newUser = UserData(
            uid: uid,
            name: name,
            phoneNumber: phoneNumber,
            isOnline: true,
          );

          await createUserProfile(userProfile: newUser);

          print("New user created with UID: $uid");
          return true;
        }
      } else {
        print("No user found in the UserCredential");
        return false;
      }
    } catch (e) {
      print("Error in createOrLoginUserAfterPhoneVerification: $e");
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    print("handleGoogleSignIn function called");
    try {
      final userCredential = await signInWithGoogle();
      final user = userCredential?.user;
      final uid = user?.uid;
      final pfpicUrl = user?.photoURL;
      final email = user?.email;
      final name = user?.displayName;
      print("UID: $uid, \nemail: $email,");

      bool userExists = await checkExistingUser(uid!);

      if (user != null) {
        if (!userExists) {
          await createUserProfile(
              userProfile: UserData(
            uid: uid,
            name: name,
            pfpURL: pfpicUrl,
            email: email,
          ));
        }

        this.user = userCredential?.user;
        // go to HomeScreen
        print('Signed in as: ${user.displayName}');
        return true;
      } else {
        print("Gooogle signin failed");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    print("signInWithGoogle function called");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<bool> logout() async {
    print("logout function called");
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      user = null;
      return true;
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }

  void logoutDilog(BuildContext context, WidgetRef ref) {
    print("logoutDilog function called");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    logout();
                    ref
                        .read(userDataNotifierProvider.notifier)
                        .updateCurrentUserData(isOnline: false);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/signup",
                      (Route<dynamic> route) =>
                          false, // This removes all the previous routes
                    );
                  },
                  child: const Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
            ],
          );
        });
  }

  Future<void> googleSignOut() async {
    print("googleSignOut function called");
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      print("Signed out of Google");
    } catch (e) {
      print("Error: $e");
    }
  }
}
