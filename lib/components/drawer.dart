import 'package:flutter/material.dart';
import 'package:wewall/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.onLogoutTap, required this.onProfileTap});

  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [

              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              // header
              MyListTile(
                myIcon: Icons.home,
                tileText: 'home',
                onTap: Navigator.of(context).pop,
              ),
              //profile
              MyListTile(
                myIcon: Icons.person,
                tileText: 'profile',
                onTap: onProfileTap,
              ), //profile

            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MyListTile(
              myIcon: Icons.logout,
              tileText: 'LogOut',
              onTap: onLogoutTap,
            ),
          ), // head





          // home list tile

          // profile list tile

          // logout list tile
        ],
      ),
    );
  }
}
