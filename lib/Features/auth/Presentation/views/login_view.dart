// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_tasky/core/constants/constants.dart';
import 'package:todo_tasky/core/database/cache_helper.dart';
import 'package:todo_tasky/core/helper/app_colors.dart';
import 'package:todo_tasky/core/services/service_locator.dart';
import 'package:todo_tasky/core/widgets/custom_button.dart';
import 'package:todo_tasky/core/widgets/custom_text_form_field.dart';
import '../../../../core/helper/app_assets.dart';
import '../../data/inputs/login_inputs.dart';
import '../controller/auth/auth_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = true;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ),
            );
          } else if (state is AuthSuccessfulState) {
            await getIt<CacheHelper>()
                .saveData(
                  key: 'id',
                  value: state.userModel.id,
                )
                .then((value) => log('Id saved: $value'));
            await getIt<CacheHelper>()
                .saveData(
                  key: 'access_token',
                  value: state.userModel.accessToken,
                )
                .then((value) => log('access token saved: $value'));
            await getIt<CacheHelper>()
                .saveData(
                  key: 'refresh_token',
                  value: state.userModel.refreshToken,
                )
                .then((value) => log('refresh_token saved: $value'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.colorPrimary,
                content: Text(
                  'Login successful!',
                ),
              ),
            );
            GoRouter.of(context).pushReplacement('/home');
          }
        },
        builder: (context, state) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              AuthBloc authBloc = context.read<AuthBloc>();
              return Form(
                key: loginKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          AppAssets.onboardingGirlImage,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: 450.h,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff24252C),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a phone';
                            }
                            if (value.length < 5) {
                              return 'phone must be at least 5 characters long';
                            }
                            return null;
                          },
                          hntText: '123 456-7890',
                          hintStyle: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 16.sp,
                            color: AppColors.fieldNameColor,
                          ),
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: SizedBox(
                            width: 120.w,
                            child: Row(
                              children: [
                                CountryListPick(
                                  appBar: AppBar(
                                    backgroundColor: Colors.blue,
                                    title: Text(
                                      'Choose Country',
                                      style: TextStyle(
                                        fontFamily: kFontFamily,
                                        fontSize: 16.sp,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  theme: CountryTheme(
                                    isShowFlag: true,
                                    isShowTitle: false,
                                    isShowCode: true,
                                    isDownIcon: false,
                                    showEnglishName: true,
                                  ),
                                  initialSelection: '+20',
                                  onChanged: (value) {
                                    log(value.toString());
                                    authBloc.onCountryChange(value!);
                                  },
                                  useUiOverlay: true,
                                  useSafeArea: false,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.fieldNameColor,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          obscureText: _isPasswordVisible,
                          hntText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _isPasswordVisible
                                  ? Colors.grey
                                  : AppColors.blackColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        state is AuthLoadingState
                            ? Center(
                                child: SizedBox(
                                  height: 10.h,
                                  width: 10.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.w,
                                    color: AppColors.colorPrimary,
                                  ),
                                ),
                              )
                            : CustomButton(
                                text: 'Sign In',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor,
                                ),
                                onPressed: () {
                                  log('phone: ${phoneController.text}');
                                  log('password: ${passwordController.text}');
                                  if (loginKey.currentState!.validate()) {
                                    authBloc.add(
                                      SignInEvent(
                                        loginInput: LoginInput(
                                          phone: phoneController.text,
                                          password: passwordController.text,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Align(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff7F7F7F),
                                  ),
                                ),
                                TextSpan(
                                  text: ' Sign Up',
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 14.sp,
                                    color: AppColors.colorPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      GoRouter.of(context)
                                          .pushReplacement('/register');
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
