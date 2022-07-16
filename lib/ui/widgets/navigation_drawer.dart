import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  Widget _buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    const color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      // material will allow us to have a nice click feedback when
      // clicking anything in the drawer
      child: Material(
        color: colorScheme.primary,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(height: 50),
            _buildMenuItem(text: "Data", icon: Icons.bar_chart),
            _buildMenuItem(text: "Settings", icon: Icons.settings),
          ],
        ),
      ),
    );
  }
}
