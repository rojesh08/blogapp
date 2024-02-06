import 'package:blogapp/services/notification_service.dart';
import 'package:blogapp/screens/add_post.dart';
import 'package:blogapp/screens/detail_screen.dart';
import 'package:blogapp/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
NotificationServices notificationServices = NotificationServices();

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Posts').child('Blog List');
    notificationServices.configureFirebaseMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('My Blogs'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orange[100],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                ),
                child: Text(
                  'Blog App',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.logout_rounded),
                onTap: () {
                  _logout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.orange[100],
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  return _buildBlogPost(context, snapshot);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget _buildBlogPost(BuildContext context, DataSnapshot snapshot) {

    double cardHeight = 120.0;

    if (snapshot.value is Map<dynamic, dynamic>?) {
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      String title = data?['pTitle'] ?? 'No Title';
      String description = data?['pDescription'] ?? 'No Description';
      String imageUrl = data?['pImage'] ?? '';

      return InkWell(
        onTap: () {
          _navigateToDetailScreen(context, title, description, imageUrl);
        },
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: SizedBox(
            height: cardHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 80,
                    height: cardHeight,
                    child: FadeInImage(
                      placeholder: AssetImage('images/logo1.png'),
                      image: NetworkImage(imageUrl),
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: SizedBox(
          height: cardHeight,
          child: Column(
            children: [
              Text('Error: Invalid data format'),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OptionScreen()),
      );
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetailScreen(BuildContext context, String title, String description, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: title,
          description: description,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
