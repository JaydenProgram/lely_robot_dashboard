// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/auth_data_source.dart' as _i702;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/dashboard/data/dashboard_data_source.dart' as _i30;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i702.AuthDataSource>(() => _i702.AuthDataSource());
    gh.lazySingleton<_i30.DashboardDataSource>(
      () => _i30.DashboardDataSource(),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(gh<_i702.AuthDataSource>()),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(gh<_i30.DashboardDataSource>()),
    );
    return this;
  }
}
