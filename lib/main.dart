import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Note: User code for main function shown in step-2
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Admob Rewarded Ads',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Google Admob Rewarded Ads'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RewardedAd? _rewardedAd;
  var rewardPoints = 0;


  @override
  void initState() {
// TODO: implement initState
    super.initState();
    loadAd();
  }

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  void loadAd() {
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdClicked: (ad) {});

          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        }));
  }

  //Note:- Use code here for variable declaration, load and show ads from step-2
  void showAds() {
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          // Reward the user for watching an ad.
          print("Reward points:- ${rewardItem.amount}");
          rewardPoints+= rewardItem.amount.toInt();
          setState(() {
            rewardPoints;
            print("Reward:- $rewardPoints");
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        centerTitle: Platform.isAndroid ? false : true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            const Text(
              'You will get 10 points for watching video ads.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(
                "images/reward.png",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rewards Points:- $rewardPoints',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            Container(
              width: 100,
              height: 50,
              color: Colors.blue,
              child: TextButton(
                  onPressed: () {
                    showAds();
                  },
                  child: const Text('Show Ads',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}