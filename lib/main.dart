import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import './constants.dart' as Constants;
import './screens/home_screen.dart';
import './screens/triage_screen.dart';
import './screens/challenge_screen.dart';
import './screens/reward_screen.dart';
import './screens/schedule_screen.dart';
import './screens/check_back_screen.dart';
import './screens/review_screen.dart';
import './providers/activities.dart';
import './providers/rewards.dart';
import './providers/challenges.dart';
import './database/database.dart';
import './widgets/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  try {
    // Enforce portrait orientation.
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(App());
  } catch (err) {
    throw err;
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _isInit = true;
  late Database _database;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      connectToDB(Constants.DATABASE_NAME).then((database) {
        _database = database;
      }).catchError((err) {
        print(err);
      }).whenComplete(() {
        setState(() {
          _isInit = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isInit
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Activities(_database),
              ),
              ChangeNotifierProvider(
                create: (_) => Rewards(_database),
              ),
              ChangeNotifierProvider(
                create: (_) => Challenges(_database),
              ),
            ],
            child: Consumer<Challenges>(
              builder: (context, challenges, _) {
                return MaterialApp(
                  title: 'Helm',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Constants.PRIMARY_COLOR,
                    colorScheme: ColorScheme.light(
                      primary: Constants.PRIMARY_COLOR,
                      secondary: Constants.ACCENT_COLOR, 
                    ),
                    textTheme: GoogleFonts.karlaTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  home: challenges.latestChallenge == null
                      ? HomeScreen()
                      : CheckBackScreen(
                          challenge: challenges.latestChallenge,
                        ),
                  routes: {
                    TriageScreen.routeName: (ctx) => TriageScreen(),
                    ChallengeScreen.routeName: (ctx) => ChallengeScreen(),
                    RewardScreen.routeName: (ctx) => RewardScreen(),
                    ScheduleScreen.routeName: (ctx) => ScheduleScreen(),
                    ReviewScreen.routeName: (ctx) => ReviewScreen(),
                  },
                );
              },
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Container(
              color: Constants.PRIMARY_COLOR,
              child: LoadingScreen(),
            ),
          );
  }
}
