import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/routes/routes.dart';

class RouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = AuthenticationRepository.instance.currentUser;

    // debugPrint('User ID: ${user?.id}');
    // debugPrint('User Email: ${user?.email}');
    // debugPrint('User Role: ${user?.roleName}');
    // debugPrint('User Role ID: ${user?.roleId}');
    // debugPrint('User Agency ID: ${user?.agencyId}');

    return user != null ? null : const RouteSettings(name: Routes.login);
  }
}
