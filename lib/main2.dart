
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';
import 'package:twitter_test/globals.dart';
import 'package:twitter_test/state/local.dart';
import 'package:twitter_test/state/timeline.dart';

import 'pages/main_model.dart';
import 'router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton(LocalState(), signalsReady: true);
  getIt.registerSingleton(TimelineState());//, signalsReady: true);
  getIt.registerSingleton(router);

  runApp(MaterialApp(home: ChangeNotifierProvider(
      create: (context) => MainModel(),
      child: MainRoot())));
}

class MainRoot extends StatelessWidget {
  const MainRoot({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: getIt<GoRouter>(),
  );
}

/// PKCE認証Androidだと正常に動作しないため保留
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _accessToken;
  String? _refreshToken;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Access Token: $_accessToken'),
          Text('Refresh Token: $_refreshToken'),
          ElevatedButton(
            onPressed: () async {
              final oauth2 = TwitterOAuth2Client(
                clientId: 'TVZ2TDZ0ZzgzcmZHNDRoeENKNFo6MTpjaQ',
                clientSecret: 'b1TBQeW6SNR88p1Al9fPv1R_2HbNQTNfLuGOHHSq00ZEv6iFGt',
                redirectUri: 'org.example.android.oauth://callback/',
                customUriScheme: 'org.example.android.oauth',
              );

              final response = await oauth2.executeAuthCodeFlowWithPKCE(
                scopes: Scope.values,
              );

              super.setState(() {
                _accessToken = response.accessToken;
                _refreshToken = response.refreshToken;
              });
            },
            child: const Text('Push!'),
          )
        ],
      ),
    ),
  );
}