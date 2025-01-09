import 'dart:async';

import 'package:country_list_pick/support/code_country.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_tasky/Features/auth/data/inputs/login_inputs.dart';
import 'package:todo_tasky/Features/auth/data/models/user_model.dart';
import 'package:todo_tasky/core/database/cache_helper.dart';
import 'package:todo_tasky/core/helper/bloc_manager.dart';
import 'package:todo_tasky/core/services/service_locator.dart';
import '../../../data/inputs/register_inputs.dart';
import '../../../data/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  String _countryCode = '+20';
  String get countryCode => _countryCode;
  void onCountryChange(CountryCode countryCode) {
    _countryCode = countryCode.dialCode!;
  }

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) async {
        on<SignOutEvent>(_onSignOutEvent);
        if (event is SignInEvent) {
          emit(AuthLoadingState());
          final response = await authRepo.signIn(
            LoginInput(
              phone: countryCode + event.loginInput.phone,
              password: event.loginInput.password,
            ),
          );
          response.fold(
            (error) => emit(AuthFailureState(message: error.errorMessage)),
            (userModel) => emit(AuthSuccessfulState(userModel: userModel)),
          );
        } else if (event is SignUpEvent) {
          emit(AuthLoadingState());
          final response = await authRepo.signUp(
            RegisterInputs(
              address: event.registerInputs.address,
              displayName: event.registerInputs.displayName,
              experienceYears: event.registerInputs.experienceYears,
              level: event.registerInputs.level,
              phone: event.registerInputs.phone,
              password: event.registerInputs.password,
            ),
          );
          response.fold(
            (error) => emit(AuthFailureState(message: error.errorMessage)),
            (userModel) => emit(AuthSuccessfulState(userModel: userModel)),
          );
        }
      },
    );
  }

  Future<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState()); // Show loading state

    final result = await authRepo.logOut(event.token); // Call logOut method

    result.fold(
      (failure) {
        // Handle failure
        emit(AuthFailureState(message: failure.errorMessage));
      },
      (userModel) async {
        // Remove user data from CacheHelper
        await getIt<CacheHelper>().removeData(key: 'id');
        await getIt<CacheHelper>().removeData(key: 'access_token');
        await getIt<CacheHelper>().removeData(key: 'refresh_token');

        // Emit a state indicating the user has signed out
        emit(AuthSuccessfulState(userModel: userModel));
      },
    );
  }
}

//!  TODO_Signleton_Bloc
SingleChildWidget initAuthBloc({Widget? child}) {
  return GlobalBlocProvider(
    create: () => getIt<AuthBloc>(),
    child: child,
  );
}
