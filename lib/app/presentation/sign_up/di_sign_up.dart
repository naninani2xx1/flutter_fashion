import 'package:flutter_fashion/dependency_injection.dart';

import '../../blocs/auth_phone/auth_phone_cubit.dart';

Future<void> initDISignUp() async {
  getIt.registerFactory(() => AuthPhoneCubit(auth: getIt()));
}
