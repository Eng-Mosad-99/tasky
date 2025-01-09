import 'package:get_it/get_it.dart';
import 'package:todo_tasky/Features/auth/data/repository/auth_repo.dart';
import 'package:todo_tasky/core/api/api.dart';
import 'package:todo_tasky/core/database/cache_helper.dart';
import '../../Features/auth/Presentation/controller/auth/auth_bloc.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    getIt.registerSingleton<API>(API());
    getIt.registerSingleton<AuthRepo>(AuthRepo(getIt.get<API>()));
    getIt.registerSingleton<AuthBloc>(AuthBloc(getIt<AuthRepo>()));
    getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  }
}
