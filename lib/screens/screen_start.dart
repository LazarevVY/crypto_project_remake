import 'package:crypto_project_remake/utils/app_strings.dart';
import 'package:flutter/material.dart';
import '../utils/app_settings.dart';
import 'screen_coins.dart';
import 'screen_news.dart';
//import 'settingsscreen.dart';
class ScreenStart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenStartState();
  }
}

class ScreenStartState extends State<ScreenStart> {
  int _currentScreenIndex=0;
  List<Widget> widgets = [ScreenNews(0.0, ""), const ScreenCoins()];//,SettingsScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSettings.colorScaffoldScreenStart,
      drawer: Drawer(backgroundColor: Colors.lightGreen, //todo move to Settings
      child: Column(
        children: [],
      )
        ,),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreenIndex,
        onTap: (index){
          setState(() {
            _currentScreenIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.note,color: Colors.green,),
            title: Text('News',style: AppSettings.textStyleScreenStartBottomNavigationBarItem),
            //label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on,color: Colors.green,),
            title: Text('Coins',style: AppSettings.textStyleScreenStartBottomNavigationBarItem),
            //label: 'Coins'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.green,),
            title: Text('Settings',style: AppSettings.textStyleScreenStartBottomNavigationBarItem),
            //label: "Settings"
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          AppStrings().textScreenStartAppBarTitle,
          style: AppSettings.textStyleScreenStartAppBarTitle,
          textAlign: TextAlign.center,
        ),
      ),
      body: widgets[_currentScreenIndex],
    );
  }
}
