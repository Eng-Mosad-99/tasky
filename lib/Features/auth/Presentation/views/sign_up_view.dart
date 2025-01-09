// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_tasky/core/constants/constants.dart';
import 'package:todo_tasky/core/helper/app_colors.dart';
import 'package:todo_tasky/core/services/service_locator.dart';
import 'package:todo_tasky/core/widgets/custom_button.dart';
import 'package:todo_tasky/core/widgets/custom_text_form_field.dart';
import '../../../../core/database/cache_helper.dart';
import '../../../../core/helper/app_assets.dart';
import '../../data/inputs/register_inputs.dart';
import '../controller/auth/auth_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isPasswordVisible = true;
  final List<String> levels = ['fresh', 'junior', 'midLevel', 'senior'];
  String? selectedLevel;
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController experienceYearsController = TextEditingController();

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
                .saveData(key: 'level', value: selectedLevel)
                .then((value) => log('Level saved: $value'));
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
            await getIt<CacheHelper>()
                .saveData(
                    key: 'experienceYears',
                    value: experienceYearsController.text)
                .then((value) => log('Experience years saved: $value'));

            await getIt<CacheHelper>()
                .saveData(key: 'name', value: displayNameController.text)
                .then((value) => log('Name saved: $value'));

            await getIt<CacheHelper>()
                .saveData(key: 'phone', value: phoneController.text)
                .then((value) => log('Phone saved: $value'));

            await getIt<CacheHelper>()
                .saveData(key: 'address', value: addressController.text)
                .then((value) => log('Address saved: $value'));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.colorPrimary,
                content: Text(
                  'Registration successful!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
                key: registerKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Image.asset(
                          AppAssets.onboardingGirlImage,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: 250.h,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 16.h),
                      ),
                      const SliverToBoxAdapter(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff24252C),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 24.h),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: displayNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          hntText: 'Name..',
                          hintStyle: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff7F7F7F),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 20.h),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 20.h),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: experienceYearsController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the year of experience';
                            }
                            return null;
                          },
                          hntText: 'year of experience',
                          hintStyle: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff7F7F7F),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 20.h),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffBABABA),
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.fieldNameColor,
                              size: 24,
                            ),
                            underline: Container(),
                            value: selectedLevel,
                            hint: Text(
                              'Choose experience Level',
                              style: TextStyle(
                                fontFamily: kFontFamily,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff2F2F2F),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLevel = newValue;
                                log(selectedLevel.toString());
                              });
                            },
                            items: levels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff2F2F2F),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 20.h),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: addressController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                          hntText: 'Address..',
                          hintStyle: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff7F7F7F),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 20.h),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          hintStyle: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff7F7F7F),
                          ),
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
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 24.h),
                      ),
                      SliverToBoxAdapter(
                        child: state is AuthLoadingState
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
                                text: 'Sign Up',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor,
                                ),
                                onPressed: () {
                                  log('phone: ${phoneController.text}');
                                  log('password: ${passwordController.text}');
                                  log('address: ${addressController.text}');
                                  log('displayName: ${displayNameController.text}');
                                  log('experienceYears: ${experienceYearsController.text}');
                                  log('level: $selectedLevel');

                                  if (registerKey.currentState!.validate()) {
                                    authBloc.add(
                                      SignUpEvent(
                                        registerInputs: RegisterInputs(
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          displayName:
                                              displayNameController.text,
                                          experienceYears:
                                              experienceYearsController.text,
                                          level: selectedLevel.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 24.h),
                      ),
                      SliverToBoxAdapter(
                        child: Align(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have any account?',
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff7F7F7F),
                                  ),
                                ),
                                TextSpan(
                                  text: ' Sign In',
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 14.sp,
                                    color: AppColors.colorPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      GoRouter.of(context)
                                          .pushReplacement('/home');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
