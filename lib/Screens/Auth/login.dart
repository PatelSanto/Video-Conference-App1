import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:video_conference_app1/Screens/Auth/signup.dart';
import 'package:video_conference_app1/Widgets/auth_widgets.dart';
import 'package:video_conference_app1/Widgets/snackbar.dart';
import 'package:video_conference_app1/ZegoCloud/homepage.dart';
import 'package:video_conference_app1/constants/assets_path.dart';
import 'package:video_conference_app1/services/auth_services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late AuthService _authService;
  final _formKey = GlobalKey<FormState>();
  final emailOrNumber = TextEditingController();
  final passwordOrOtp = TextEditingController();
  String? _verificationId;

  bool isLoadingLogin = false;
  bool viewPassword = false;
  bool isLoadingGoogle = false;
  bool isSelectedEmail = true;
  bool isSelectedNumber = false;
  bool isLoadingOtp = false;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  void dispose() {
    emailOrNumber.dispose();
    passwordOrOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context,
        "Login Account",
        const SignupScreen(),
        "Or Signup",
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
            _loginForm(context),
            otherSigninMethods(context, _authService),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      ? "Enter valid phone number (ex. +91 9876543212)"
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
                        snackbarToast(
                          context: context,
                          title: "Error in sending OTP",
                          icon: Icons.error_outline_rounded,
                        );
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
              "Login Account",
              () {
                _onTapLogin();
              },
              isLoadingLogin,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoadingLogin = true;
      });
      try {
        String smsCode = passwordOrOtp.text.trim();
        final result = (isSelectedEmail)
            ? await _authService.login(
                emailOrNumber.text, passwordOrOtp.text, ref)
            : await _authService.verifyOTP(
                _verificationId ?? "",
                smsCode,
                context,
              );
        if (result) {
          snackbarToast(
            context: context,
            title: "Login Sucessfully",
            icon: Icons.login_outlined,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          setState(() {
            isLoadingLogin = false;
          });
        } else {
          snackbarToast(
            context: context,
            title: "Enter Valid Informaiton",
            icon: Icons.error_outline_rounded,
          );
          setState(() {
            isLoadingLogin = false;
          });
        }
      } catch (e) {
        snackbarToast(
          context: context,
          title: "Enter Valid Informaiton",
          icon: Icons.error_outline_rounded,
        );
        print(e);
        setState(() {
          isLoadingLogin = false;
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
          setState(() {
            _verificationId = verificationId;
          });
        },
        (userCredential) async {
          // successful login
          print('User signed in: ${userCredential.user?.phoneNumber}');
          await _authService
              .createOrLoginUserAfterPhoneVerification(
            userCredential,
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
      return false;
    }
  }
}
