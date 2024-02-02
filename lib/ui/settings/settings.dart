import 'package:flutter/material.dart';
import 'package:habit_maker/ui/login/login.dart';
import 'package:habit_maker/ui/theme_data_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  late ThemeProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15)),
              height: 110,
              child: ListView(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      provider.toggleTheme();
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    )),
                    child: const Text('Light color'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                      onPressed: () {
                        provider.toggleTheme();
                      },
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                        color: Colors.black26,
                        fontSize: 16,
                      )),
                      child: const Text('Dark mode')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 70),
          Container(
              width: 380,
              alignment: Alignment.topLeft,
              child: const Text(
                'Start week on',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: 380,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(15)),
            height: 110,
            child: ListView(
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  )),
                  child: const Text('Monday'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                      color: Colors.black26,
                      fontSize: 16,
                    )),
                    child: const Text('Sunday')),

              ],
            ),
          ),
          // const SizedBox(
          //   height: 90,
          // ),
          // Container(
          //   width: 250,
          //   child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(primary: Colors.blue),
          //       onPressed: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => SignInPage()));
          //       },
          //       child: const Text('Sign Out',style: TextStyle(fontSize: 22),)),
          // )
        ],
      ),
    );
  }
}
