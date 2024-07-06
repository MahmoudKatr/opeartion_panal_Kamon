import 'package:bloc_v2/Features/Splash/presentation/views/widgets/splash_view_body.dart';
import 'package:go_router/go_router.dart';
import '../../Features/home/presentation/views/home_view.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: kBookDetailsView,
       /*
        builder: (context, state) => BlocProvider(
          create: (context) => SimilarBooksCubit(
            getIt.get<HomeRepoImpl>(),
          ),
          child: BookDetailsView(
            bookModel: state.extra as BookModel,
          ),
        ),*/
      ),
    ],
  );
}
