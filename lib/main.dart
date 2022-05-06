// import 'package:firebase_core/firebase_core.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rental_partners/Blocs/category_bloc.dart';
import 'package:rental_partners/Blocs/filter_bloc.dart';
import 'package:rental_partners/Blocs/order_status_bloc.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';

import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';
import 'package:rental_partners/Screens/SplashScreen/splash_screen.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/themes.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessageKey = GlobalKey();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<OrderListCubit>(create: (context) => OrderListCubit()),
        BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
        BlocProvider<EquipmentDetailModelCubit>(
            create: (context) => EquipmentDetailModelCubit()),
        BlocProvider<AttachmentDetailsModelCubit>(
            create: (context) => AttachmentDetailsModelCubit()),
        BlocProvider<OrderStatusesCubit>(
            create: (context) => OrderStatusesCubit()),
        BlocProvider<FliterBlocCubit>(create: (context) => FliterBlocCubit()),
      ],
      child: AdaptiveTheme(
        light: lightThemeData,
        dark: darkThemeData,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          title: 'AEMPL Group',
          scaffoldMessengerKey: scaffoldMessageKey,
          theme: theme,
          darkTheme: darkTheme,

          home: SplashScreen(), // EquipmentDetailScreen(),
        ),
      ),
    );
  }
}
