import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  Widget _buildMenuItem(
    BuildContext context, {
    required String text,
    required IconData icon,
    required String url,
  }) {
    const color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      onTap: () => Navigator.pushNamed(context, url),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const SizedBox(height: 50),
            _buildMenuItem(
              context,
              text: "Stats",
              icon: Icons.bar_chart,
              url: "/stats",
            ),
            _buildMenuItem(
              context,
              text: "Settings",
              icon: Icons.settings,
              url: "/settings",
            ),
          ],
        ),
      ),
    );
  }
}
