import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:video_conference_app1/Models/user.dart';

final ImagePicker _picker = ImagePicker();
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

CollectionReference<UserData> userCollection =
    FirebaseFirestore.instance.collection('users').withConverter<UserData>(
          fromFirestore: (snapshots, _) => UserData.fromJson(snapshots.data()!),
          toFirestore: (userData, _) => userData.toJson(),
        );

Future<void> createUserProfile({required UserData userProfile}) async {
  try {
    await userCollection.doc(userProfile.uid).set(userProfile);
  } catch (e) {
    print("Error creating user profile: $e");
  }
}

Future<bool> checkExistingUser(String uid) {
  CollectionReference blogsRef = FirebaseFirestore.instance.collection('users');
  return blogsRef.doc(uid).get().then((doc) {
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  });
}

Future<UserData> getUserDetailsFromUid(String uid) async {
  try {
    final docSnapshot = await userCollection.doc(uid).get();

    if (docSnapshot.exists) {
      UserData userDetails = docSnapshot.data()!;
      return userDetails;
    } else {
      return Future.error("User not found");
    }
  } catch (e) {
    return Future.error("Failed to fetch user data : $e");
  }
}

Future<File?> getImageFromGallery() async {
  final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}

Future<String?> uploadUserPfpic(
    {required File file, required String uid}) async {
  try {
    print("uploading profile pic");
    Reference fileReference = firebaseStorage
        .ref('users/pfpics')
        .child("$uid${path.extension(file.path)}");

    UploadTask uploadTask = fileReference.putFile(file);
    print("upload task done: \n${fileReference.getDownloadURL()}");

    return uploadTask.then((p) {
      if (p.state == TaskState.success) {
        print("profile pic uploaded");
        return fileReference.getDownloadURL();
      }
      print("error while uploading profile pic");
      return null;
    });
  } catch (e) {
    print("Error uploading user profile pic: $e");
    return null;
  }
}
