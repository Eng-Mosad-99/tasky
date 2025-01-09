import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_tasky/core/database/cache_helper.dart';
import 'package:todo_tasky/core/services/service_locator.dart';
import '../../../auth/Presentation/controller/auth/auth_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ),
          );
        } else if (state is AuthSuccessfulState) {
          GoRouter.of(context).pushReplacement('/login');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  // Trigger the SignOutEvent
                  context.read<AuthBloc>().add(SignOutEvent());
                },
              ),
            ],
          ),
          body: FutureBuilder(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 10.h,
                    width: 10.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.w,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                final userData = snapshot.data as Map<String, dynamic>;
                return _buildUserDataList(userData);
              }
            },
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    // Retrieve all data from CacheHelper
    final name = await getIt<CacheHelper>().getData(key: 'name');
    final level = await getIt<CacheHelper>().getData(key: 'level');
    final experienceYears =
        await getIt<CacheHelper>().getData(key: 'experienceYears');
    final phone = await getIt<CacheHelper>().getData(key: 'phone');
    final address = await getIt<CacheHelper>().getData(key: 'address');
    final accessToken = await getIt<CacheHelper>().getData(key: 'access_token');
    final refreshToken =
        await getIt<CacheHelper>().getData(key: 'refresh_token');
    final id = await getIt<CacheHelper>().getData(key: 'id');

    // Return the data as a Map
    return {
      'name': name,
      'level': level,
      'experienceYears': experienceYears,
      'phone': phone,
      'address': address,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'id': id,
    };
  }

  Widget _buildUserDataList(Map<String, dynamic> userData) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      children: [
        _buildDataTile('Name', userData['name']),
        _buildDataTile('Level', userData['level']),
        _buildDataTile('Experience Years', userData['experienceYears']),
        _buildDataTile('Phone', userData['phone']),
        _buildDataTile('Address', userData['address']),
        _buildDataTile('Access Token', userData['accessToken']),
        _buildDataTile('Refresh Token', userData['refreshToken']),
        _buildDataTile('ID', userData['id']),
      ],
    );
  }

  Widget _buildDataTile(String title, String? value) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value ?? 'Not available',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
