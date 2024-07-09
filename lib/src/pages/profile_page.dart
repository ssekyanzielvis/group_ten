import 'package:flutter/material.dart';
import '../screens/edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 45, 40, 40)
                              .withOpacity(0.2),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("lib/assets/images/profile.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Nancy",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "zainab@gmail.com",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 100.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Location"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.visibility, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Change Password"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.shopping_bag, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Shipping"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.paypal, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Payment"),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
