import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body:  ListView(
              children: <Widget>[
                ListTile(
                  leading:const Icon(Icons.color_lens_outlined),
                  title:const Text('Background color'),
                  trailing:const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Handle the tap on the ListTile
                    print('Tapped on Star ListTile');
                  },
                ),
                const SizedBox(height: 8,),
                ListTile(
                  leading:const Icon(Icons.dark_mode_outlined),
                  title:const Text('Dark mode'),
                  trailing:const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Handle the tap on the ListTile
                    print('Tapped on Star ListTile');
                  },
                ),
              ],
            ),
    );
  }
}
