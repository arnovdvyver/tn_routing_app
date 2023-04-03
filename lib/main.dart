import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_app/widgets/trips_tab_widget.dart';
import 'package:routing_app/widgets/saved_locations_tab_widget.dart';
import 'package:routing_app/providers/user_data_provider.dart';
import 'providers/location_service_provider.dart';
import 'widgets/map_tab_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //load environment variables
  await dotenv.load();
  
  //init firebase and firestore connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseFirestore db = FirebaseFirestore.instance;

  runApp(
    
    //define and create the two main providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationController()),
        ChangeNotifierProvider(create: (context) => User("Arno", db))
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true
        ),
        home: const DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: TabBar(
              indicatorColor: Color.fromRGBO(15, 163, 177, 1),
              isScrollable: false,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.add_road_rounded, color: Color.fromRGBO(241, 95, 41, 1)),
                ),
                Tab(
                  icon: Icon(Icons.map_outlined, color: Color.fromRGBO(241, 95, 41, 1)),
                ),
                Tab(
                  icon: Icon(Icons.bookmarks_outlined, color: Color.fromRGBO(241, 95, 41, 1)),
                ),
              ],
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                //first
                Center(
                  child: Trips(),
                ),

                //second
                Center(
                  child: RoutingMap()
                ),

                //third
                Center(
                  child: SavedLocations()
                ),
              ],
            ),
          ),
        ),
      )
    )
  );
}