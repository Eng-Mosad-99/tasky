import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg.dart';
import 'package:todo_tasky/core/constants/constants.dart';
import 'package:todo_tasky/core/database/cache_helper.dart';
import 'package:todo_tasky/core/helper/app_assets.dart';
import 'package:todo_tasky/core/services/service_locator.dart';
import '../../../core/widgets/custom_button.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.asset(
            AppAssets.onboardingGirlImage,
            width: double.infinity,
            fit: BoxFit.fill,
            height: 450.h,
          ),
          SizedBox(
            height: 24.h,
          ),
          SizedBox(
            width: 250.w,
            child: Text(
              'Task Management & To-Do List ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff24252C),
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0.w),
            child: Text(
              'This productive tool is designed to help you better manage your task project-wise conveniently!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff24252C),
              ),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          SizedBox(
            height: 50.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.h),
              child: CustomButton(
                leadingWidget: SvgPicture.asset(
                  AppAssets.arrowIconImage,
                  width: 24.w,
                  height: 24.h,
                ),
                text: 'Let’s Start',
                textStyle: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: kFontFamily,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await checkAuthStateAndNavigate(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkAuthStateAndNavigate(BuildContext context) async {
    // Retrieve data from CacheHelper
    final accessToken = await getIt<CacheHelper>().getData(key: 'access_token');
    final refreshToken =
        await getIt<CacheHelper>().getData(key: 'refresh_token');
    final id = await getIt<CacheHelper>().getData(key: 'id');

    // Check if all values are null or empty
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty) &&
        (id == null || id.isEmpty)) {
      // Navigate to LoginView
      GoRouter.of(context).pushReplacement('/login');
    } else {
      // Navigate to HomeView
      GoRouter.of(context).pushReplacement('/home');
    }
  }
}
