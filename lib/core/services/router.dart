// import 'package:flutter/material.dart';

// import '../../presentation/pages/post/comment/comment_page.dart';
// import '../constant/route_names.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case RouteNames.overviewPageRoute:
//       return _pageBuilder((_) => const CommentPage(), routeSettings: settings);
//     default:
//       return _pageBuilder((_) => const CommentPage(), routeSettings: settings);
//   }
// }

// PageRouteBuilder<dynamic> _pageBuilder(
//   Widget Function(BuildContext) page, {
//   required RouteSettings routeSettings,
// }) {
//   return PageRouteBuilder(
//     settings: routeSettings,
//     transitionsBuilder: (_, animation, __, child) => FadeTransition(
//       opacity: animation,
//       child: child,
//     ),
//     pageBuilder: (context, _, __) => page(context),
//   );
// }
