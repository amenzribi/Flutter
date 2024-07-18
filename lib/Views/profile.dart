/**
import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/Components/button.dart';
import 'package:flutter_sqlite_auth_app/Components/colors.dart';
import 'package:flutter_sqlite_auth_app/JSON/users.dart';
import 'package:flutter_sqlite_auth_app/Views/auth.dart'; // Import AuthScreen
import 'package:flutter_sqlite_auth_app/pages/home_page.dart'; // Import HomePage

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Implement your sign-out logic here
            // This might include:
            // 1. Clearing authentication data (e.g., shared preferences)
            // 2. Navigating back to the AuthScreen
            Navigator.pushReplacementNamed(
                context, '/auth'); // Assuming '/auth' is your AuthScreen route
          },
          icon: const Icon(Icons.logout), // Sign out icon
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 77,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/no_user.jpg"),
                  radius: 75,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                profile!.fullName ?? "",
                style: const TextStyle(fontSize: 28, color: primaryColor),
              ),
              Text(
                profile!.email ?? "",
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),

              //Button to navigate to LoginScreen (This should be removed!)
              // Button(label: "SIGN UP", press: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
              // }),

              ListTile(
                leading: const Icon(Icons.person, size: 30),
                subtitle: const Text("Full name"),
                title: Text(profile!.fullName ?? ""),
              ),

              ListTile(
                leading: const Icon(Icons.email, size: 30),
                subtitle: const Text("Email"),
                title: Text(profile!.email ?? ""),
              ),

              ListTile(
                leading: const Icon(Icons.account_circle, size: 30),
                subtitle: Text(profile!.usrName),
                title: const Text("admin"),
              ),

              const SizedBox(height: 20), // Add some space before the button

              // Icon to navigate to Add Article screen (HomePage)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: const Icon(Icons.add_circle,
                    size: 40), // Use the add circle icon
              ),
            ],
          ),
        )),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/Components/button.dart';
import 'package:flutter_sqlite_auth_app/Components/colors.dart';
import 'package:flutter_sqlite_auth_app/JSON/users.dart';
import 'package:flutter_sqlite_auth_app/Views/auth.dart'; // Import AuthScreen
import 'package:flutter_sqlite_auth_app/pages/home_page.dart'; // Import HomePage

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/auth'); // Assuming '/auth' is your AuthScreen route
          },
          icon: const Icon(Icons.logout), // Sign out icon
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
            child: profile != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 77,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/no_user.jpg"),
                          radius: 75,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile!.fullName ?? '',
                        style:
                            const TextStyle(fontSize: 28, color: primaryColor),
                      ),
                      Text(
                        profile!.email ?? '',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person, size: 30),
                        subtitle: const Text("Full name"),
                        title: Text(profile!.fullName ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email, size: 30),
                        subtitle: const Text("Email"),
                        title: Text(profile!.email ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle, size: 30),
                        subtitle: const Text("Username"),
                        title: Text(profile!.usrName),
                      ),
                      const SizedBox(
                          height: 20), // Add some space before the button
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        icon: const Icon(Icons.add_circle,
                            size: 40), // Use the add circle icon
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'Profile not available',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
