import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/photo_model.dart';
import 'models/user_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userList = <User>[];
  Future<List<User>?> getUserData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var jsonUserData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> user in jsonUserData) {
        userList.add(User.fromJson(user));
      }
    }
    return userList;
  }

  var photoList = <Photo>[];
  Future<List<Photo>?> getPhotoData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var jsonPhotoData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> photo in jsonPhotoData) {
        photoList.add(Photo.fromJson(photo));
      }
    }
    return photoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // FutureBuilder(
            //   future: getUserData(),
            //   builder: ((context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Expanded(
            //         child: ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: userList.length,
            //             itemBuilder: (context, index) {
            //               var user = userList[index];
            //               return userWidget(user);
            //             }),
            //       );
            //     } else {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   }),
            // ),
            FutureBuilder(
              future: getPhotoData(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: photoList.length,
                        itemBuilder: (context, index) {
                          var photo = photoList[index];
                          return photoWidget(photo);
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userWidget(user) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontSize: 22),
          ),
          Text(
            user.email,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                user.address.suite.toString(),
              ),
              Text(
                user.address.street.toString(),
              ),
              Text(
                user.address.city.toString(),
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.address.zipcode.toString(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget photoWidget(photo) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(photo.thumbnailUrl),
        title: Text(photo.title),
      ),
    ),
  );
}
