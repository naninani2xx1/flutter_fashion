import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_fashion/app/blocs/address_user/address_user_cubit.dart';
import 'package:flutter_fashion/app/blocs/cart/cart_cubit.dart';
import 'package:flutter_fashion/app/blocs/favorite/favorite_cubit.dart';
import 'package:flutter_fashion/app/blocs/notification/notification_cubit.dart';
import 'package:flutter_fashion/app/blocs/order/order_cubit.dart';
import 'package:flutter_fashion/app/blocs/order_cancel/order_cancel_cubit.dart';
import 'package:flutter_fashion/app/blocs/product_detail/product_detail_cubit.dart';
import 'package:flutter_fashion/app/blocs/product_new/product_new_cubit.dart';
import 'package:flutter_fashion/app/blocs/product_sale/product_sale_cubit.dart';
import 'package:flutter_fashion/app/blocs/reviews/review_cubit.dart';
import 'package:flutter_fashion/app/blocs/search/search_cubit.dart';
import 'package:flutter_fashion/app/presentation/category/blocs/category_tab_cubit.dart';
import 'package:flutter_fashion/app/presentation/home/export.dart';
import 'package:flutter_fashion/app_lifecycle.dart';
import 'package:flutter_fashion/core/pusher/beams.dart';
import 'package:flutter_fashion/core/pusher/order.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'core/task_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  log('Handling a background message ${message.notification!.body}');
  log('Handling a background message ${message.notification!.title}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  //HydratedBloc.storage.clear();

  await PusherBeamsApp.instance.getStarted();

  await init();

  Bloc.observer = MyBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CategoryCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<BannerCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<PopularProductCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CategoryTabCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductDetailCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ReviewCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<PromotionCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductNewCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductSaleCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsCubit>(),
        ),
      ],
      child: const Phoenix(child: FashionApp()),
    ),
  );
}

class FashionApp extends StatefulWidget {
  const FashionApp({super.key});

  @override
  State<FashionApp> createState() => _FashionAppState();
}

class _FashionAppState extends State<FashionApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _subscription;

  late PusherUserApp _pusherUserApp;

  @override
  void initState() {
    super.initState();
    // FirebaseAppCheck.instance.onTokenChange.listen(
    //   (token) {
    //     print('Appcheck: $token');
    //   },
    // );
    // getAppCheckToken();
    //listen connect internet
    _subscription = getIt.get<Connectivity>().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        getIt.get<NetworkInfoImpl>().listenChangeNetwork(result);
      },
    );

    getIt.get<UserCubit>().stream.listen(
      (event) {
        event.when(
          initial: () {},
          loading: () {},
          fetchCompleted: (user) {
            //register notfication with authentication userId
            PusherBeamsApp.instance.initToUser(user.id);

            _pusherUserApp = getIt<PusherUserApp>()
              ..initialize(
                onEvent: (PusherEvent? onEvent) {
                  if (onEvent!.data != null && onEvent.data.isNotEmpty) {
                    _pusherUserApp.handleData(onEvent.data);
                  }
                },
              );
          },
          failure: (e) {},
        );
      },
    );

    //register
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());

    PusherBeamsApp.instance.onMessageReceivedInTheForeground();
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(AppLifecycleObserver());
    if (getIt.isRegistered<PusherUserApp>()) {
      _pusherUserApp.dispose();
    }
    PusherBeamsApp.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CartCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddressUserCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<OrderCubit>()..fetchOrder(),
        ),
        BlocProvider(
          create: (context) => getIt<FavoriteCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationCubit>()..fetch(),
        ),
        BlocProvider(
          create: (context) => getIt<SearchCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<OrderCancelCubit>(),
        ),
      ],
      child: MaterialApp.router(
        theme: context.watch<SettingsCubit>().state.isThemeLight
            ? ThemeDataApp.appThemeLight
            : ThemeDataApp.appThemeDark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        scaffoldMessengerKey: AppSnackbarMessenger.scaffoldMessengerKey,
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
        locale: context.watch<SettingsCubit>().state.isVietnamese
            ? const Locale('vi', 'VN')
            : const Locale('en', 'US'),
        title: 'App Fashion',
      ),
    );
  }
}
