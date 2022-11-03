import 'package:flutter/material.dart';
import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/full_exam/full_exam.dart';
import '../personal_page/personal_page.dart';
import '../practice_page/practice_page.dart';
import '../class_page/class_page.dart';
import '../widgets/fade_transition_page.dart';
import '../navigation/route_state.dart';
import 'home_page.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

class ApplicationHome extends StatelessWidget {
  static const String routeName = 'apphome';
  ApplicationHome({super.key});
  @override
  Widget build(BuildContext context) {
    // FIXME 22.11.3 实现RouteStateScope
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);
    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: const ApplicationHomeBody(),
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go(HomePage.routeName);
          if (idx == 1) routeState.go(PracticePage.routeName);
          if (idx == 2) routeState.go(ClassPage.routeName);
          if (idx == 3) routeState.go(PersonalPage.routeName);
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Home',
            icon: Icons.home,
          ),
          AdaptiveScaffoldDestination(
            title: 'Practice',
            icon: Icons.book,
          ),
          AdaptiveScaffoldDestination(
            title: 'Class',
            icon: Icons.class_,
          ),
          AdaptiveScaffoldDestination(
            title: 'Personal',
            icon: Icons.person,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith(HomePage.routeName)) return 0;
    if (pathTemplate.startsWith(PracticePage.routeName)) return 1;
    if (pathTemplate.startsWith(ClassPage.routeName)) return 2;
    if (pathTemplate.startsWith(PersonalPage.routeName)) return 3;
    return 0;
  }
}

class ApplicationHomeBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const ApplicationHomeBody({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        if (currentRoute.pathTemplate.startsWith(HomePage.routeName))
          const FadeTransitionPage<void>(
            key: ValueKey(HomePage.routeName),
            child: HomePage(),
          )
        else if (currentRoute.pathTemplate.startsWith(PracticePage.routeName))
          const FadeTransitionPage<void>(
            key: ValueKey(PracticePage.routeName),
            child: PracticePage(),
          )
        else if (currentRoute.pathTemplate.startsWith(ClassPage.routeName))
          const FadeTransitionPage<void>(
            key: ValueKey(ClassPage.routeName),
            child: ClassPage(),
          )
        else if (currentRoute.pathTemplate.startsWith(PersonalPage.routeName))
          const FadeTransitionPage<void>(
            key: ValueKey(PersonalPage.routeName),
            child: PersonalPage(),
          )
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
