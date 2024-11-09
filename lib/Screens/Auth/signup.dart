import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:video_conference_app1/Screens/Auth/login.dart';
import 'package:video_conference_app1/Widgets/auth_widgets.dart';
import 'package:video_conference_app1/Widgets/snackbar.dart';
import 'package:video_conference_app1/ZegoCloud/homepage.dart';
import 'package:video_conference_app1/constants/assets_path.dart';
import 'package:video_conference_app1/services/auth_services.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late AuthService _authService;
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final emailOrNumber = TextEditingController();
  final passwordOrOtp = TextEditingController();
  String? _verificationId;

  bool isLoadingSignup = false;
  bool isLoadingOtp = false;
  bool viewPassword = false;
  bool isLoadingGoogle = false;
  bool isSelectedEmail = true;
  bool isSelectedNumber = false;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    emailOrNumber.dispose();
    passwordOrOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context,
        "Create Account",
        const LoginScreen(),
        "Or Login",
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _signupForm(context),
            otherSigninMethods(context, _authService),
          ],
        ),
      ),
    );
  }

  Widget _signupForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(
              name,
              text: "Full Name",
              personIcon,
              isNameField: true,
              errorText: "Enter valid full name",
            ),
            customTextField(
              emailOrNumber,
              (isSelectedEmail) ? emailIcon : phoneIcon,
              hintText: isSelectedEmail ? "Enter email" : "Enter phone number",
              emailOrNumberWidget: emailOrNumberOption(
                onClickEmail: (value) {
                  setState(() {
                    isSelectedEmail = value;
                    isSelectedNumber = !isSelectedNumber;
                  });
                },
                onClickNumber: (value) {
                  setState(() {
                    isSelectedNumber = value;
                    isSelectedEmail = !isSelectedEmail;
                  });
                },
                isSelectedEmail: isSelectedEmail,
                isSelectedNumber: isSelectedNumber,
              ),
              isEmailField: isSelectedEmail,
              isNumberField: isSelectedNumber,
              errorText: (isSelectedEmail)
                  ? "Enter valid email address"
                  : (isSelectedNumber)
                      ? "Enter valid phone number"
                      : "Enter valid information!",
              suffixIcon: (isSelectedNumber)
                  ? sendOtpWidget("Send OTP", () async {
                      setState(() {
                        isLoadingOtp = true;
                      });
                      final result = await sendOtp();
                      if (result) {
                        snackbarToast(
                          context: context,
                          title: "OTP Sent !",
                          icon: Icons.done,
                        );
                        setState(() {
                          isLoadingOtp = false;
                        });
                      } else {
                        setState(() {
                          isLoadingOtp = false;
                        });
                      }
                    }, isLoadingOtp)
                  : null,
            ),
            customTextField(
              passwordOrOtp,
              text: (isSelectedEmail) ? "Password" : "OTP",
              (isSelectedEmail) ? passwordIcon : numberDialpadIcon,
              viewPassword: !viewPassword,
              isPasswordField: !isSelectedNumber,
              isOtpField: isSelectedNumber,
              hintText: (isSelectedEmail) ? "Enter password" : "Enter OTP",
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      viewPassword = !viewPassword;
                    });
                  },
                  icon: Icon(
                    (viewPassword)
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  )),
            ),
            authButton(
              "Create Account",
              () {
                _onTapSignup();
              },
              isLoadingSignup,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoadingSignup = true;
      });
      try {
        String smsCode = passwordOrOtp.text.trim();

        bool result = (isSelectedEmail)
            ? await _authService.signup(
                name.text,
                emailOrNumber.text,
                passwordOrOtp.text,
                ref,
              )
            : await _authService.verifyOTP(
                _verificationId ?? "",
                smsCode,
                context,
                name: name.text,
              );
        if (result) {
          snackbarToast(
            context: context,
            title: "Account Created Sucessfully",
            icon: Icons.login_outlined,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          setState(() {
            isLoadingSignup = false;
          });
        } else {
          snackbarToast(
            context: context,
            title: "Enter Valid Informaiton",
            icon: Icons.error_outline_rounded,
          );
          setState(() {
            isLoadingSignup = false;
          });
        }
      } catch (e) {
        print(e);
        snackbarToast(
          context: context,
          title: "Unable to Create Account",
          icon: Icons.error_outline_rounded,
        );
        setState(() {
          isLoadingSignup = false;
        });
      }
    }
  }

  Future<bool> sendOtp() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = emailOrNumber.text.trim();
      _authService.verifyPhoneNumber(
        phoneNumber,
        context,
        (verificationId) {
          print("OTP Sent: $verificationId");
          setState(() {
            _verificationId = verificationId;
          });
          return true;
        },
        (userCredential) async {
          // successful login
          print('User signed in: ${userCredential.user?.phoneNumber}');
          await _authService
              .createOrLoginUserAfterPhoneVerification(
            userCredential,
            name: name.text,
            ref: ref,
          )
              .then((value) {
            if (value) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/home",
                (Route<dynamic> route) => false,
              );
              return true;
            } else {
              return false;
            }
          });
        },
        (error) {
          // error
          print('Error verifying phone number: $error');
          return false;
        },
      );
      return false;
    } else {
      print("validation error");
      return false;
    }
  }
}

Widget otherSigninMethods(
  BuildContext context,
  AuthService authService,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Divider(
              color: Colors.grey,
            )),
            SizedBox(width: 7),
            Text(
              "Or use other methods",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 7),
            Expanded(
                child: Divider(
              color: Colors.grey,
            )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        OutlinedButton(
          onPressed: () async {
            // Handle Google sign in
            await authService.handleGoogleSignIn().then((value) {
              if (value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            });
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                googleImage,
                width: 35,
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Sign Up with Google',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
