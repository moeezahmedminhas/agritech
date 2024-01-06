import 'dart:io';

import 'package:agritech/features/auth/exceptions/exceptions.dart';
import 'package:agritech/features/auth/view/signup_screen.dart';
import 'package:agritech/features/auth/view/user_data_screen.dart';
import 'package:agritech/features/company/screens/company_home_screen.dart';
import 'package:agritech/features/home/views/home_screen.dart';
import 'package:agritech/features/splash_screen.dart';
import 'package:agritech/models/user.dart';
import 'package:agritech/utils/contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/views/admin_home_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _storage = FirebaseStorage.instance;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<bool> userDataExists() async {
    if (firebaseUser.value == null) {
      // Handle the case where firebaseUser.value is null.
      // For example, return false or throw a custom exception.
      return false;
    }

    final snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: _auth.currentUser!.uid)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  _setInitialScreen(User? user) async {
    Get.to(const SplashScreen());
    // logout();
    Future.delayed(const Duration(seconds: 2), () async {
      if (user == null) {
        Get.to(const SplashScreen());

        Get.offAll(() => SignUpScreen());
      }

      // bool userExists = await userDataExists();
      AppUser? currentUser = await getUserData();
      if (currentUser != null) {
        if (currentUser.type == 'admin') {
          Get.offAll(() => const AdminHomeScreen());
        } else if (currentUser.fullName == "" && currentUser.postalCode == "") {
          Get.offAll(() => UserDataScreen());
        } else if (currentUser.type == userTypes[0]) {
          Get.offAll(() => const HomeScreen());
        } else if (currentUser.type == userTypes[1]) {
          Get.offAll(() => const CompanyHomeScreen());
        }
      }
    });
  }

  selectProfileImage() async {
    final picker = ImagePicker(); // Instance of Image picker
    File selectedImage;

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
      await uploadProfilePic(selectedImage);
    }
  }

  uploadProfilePic(File imageFile) async {
    Reference ref = _storage.ref('users/$currentUserId');
    UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() => {});
    String downloadUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'profilePic': downloadUrl,
    });
  }

  Future<AppUser?> getUserData() async {
    final userData =
        await _firestore.collection("users").doc(firebaseUser.value!.uid).get();
    AppUser? user;

    if (userData.data() != null) {
      user = AppUser.fromJson(userData.data()!);
    }
    return user;
  }

  Stream<AppUser?> getUserDataStream() async* {
    final usersRef = _firestore.collection("users");
    final userSnapshotStream =
        usersRef.doc(firebaseUser.value!.uid).snapshots();

    yield* userSnapshotStream.map((userSnapshot) {
      if (userSnapshot.data() != null) {
        return AppUser.fromJson(userSnapshot.data()!);
      }
      return null;
    });
  }

  Future<void> saveUserDataToFirebase(String name, String address,
      String postalCode, String phoneNumber, String userType) async {
    AppUser user = AppUser(
      id: firebaseUser.value!.uid,
      fullName: name,
      email: firebaseUser.value!.email!,
      address: address,
      phone: phoneNumber,
      postalCode: postalCode,
      profilePic:
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
      type: userType,
    );
    await _firestore
        .collection("users")
        .doc(firebaseUser.value!.uid)
        .set(user.toJson());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userType', userType);

    // Get.offAllNamed(HomeScreen.routeName);
    // firebaseUser.value!.email == adminEmail
    //     ? Get.offAllNamed(AdminHomeScreen.routeName)
    //     : Get.offAllNamed(HomeScreen.routeName);
  }

  Future<void> updateAddress(String address, String postalCode) async {
    await _firestore
        .collection("users")
        .doc(firebaseUser.value!.uid)
        .update({'address': address, 'postalCode': postalCode});
    Get.offAllNamed(HomeScreen.routeName);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // Get.offAndToNamed(UserDataScreen.routeName);
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      AppUser user = AppUser(
        id: firebaseUser.value!.uid,
        fullName: "",
        email: email,
        address: "",
        phone: "",
        postalCode: "",
        profilePic:
            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
        type: '',
      );
      await _firestore
          .collection("users")
          .doc(firebaseUser.value!.uid)
          .set(user.toJson());
      firebaseUser.value != null
          ? Get.toNamed(UserDataScreen.routeName)
          : Get.offAllNamed(SignUpScreen.routeName);
      Get.snackbar("User SignedUp", "User Signed Up Successfully",
          snackPosition: SnackPosition.TOP);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar('Signup Error', ex.message,
          snackPosition: SnackPosition.TOP);
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar('Signup Error', ex.message,
          snackPosition: SnackPosition.BOTTOM);
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      // await _auth.(phoneNumber)
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAllNamed(HomeScreen.routeName)
          : Get.offAllNamed(SignUpScreen.routeName);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar('Login Error', ex.toString(),
          snackPosition: SnackPosition.BOTTOM);
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      throw ex;
    }
  }

  Future<bool> userDataExistsServices(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.exists;
  }

  Future<void> saveUserDataToFirestore(AppUser user) async {
    await _firestore.collection("users").doc(user.id).set(user.toJson());
    Get.offAllNamed(HomeScreen.routeName);
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google user credentials
        await _auth.signInWithCredential(credential);
        AppUser user = AppUser(
          id: firebaseUser.value!.uid,
          fullName: "",
          email: firebaseUser.value!.email!,
          address: "",
          phone: "",
          postalCode: "",
          profilePic:
              'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
          type: '',
        );
        await _firestore
            .collection("users")
            .doc(firebaseUser.value!.uid)
            .set(user.toJson());
        AppUser? currentUser = await getUserData();
        if (currentUser != null) {
          if (currentUser.type == 'admin') {
            Get.offAll(() => const AdminHomeScreen());
          } else if (currentUser.fullName == "" &&
              currentUser.postalCode == "") {
            Get.offAll(() => UserDataScreen());
          } else if (currentUser.type == userTypes[0]) {
            Get.offAll(() => const HomeScreen());
          } else if (currentUser.type == userTypes[1]) {
            Get.offAll(() => const CompanyHomeScreen());
          }
        }
      }
    } catch (error) {
      Get.snackbar('Login Error', 'Failed to sign in with Google: $error',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Facebook Sign-In
  // Future<void> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);

  //       // Sign in to Firebase with the Facebook user credentials
  //       UserCredential userCredential =
  //           await _auth.signInWithCredential(facebookAuthCredential);

  //       // Fetching the user data from Facebook
  //       final userData = await FacebookAuth.instance.getUserData();

  //       // Fetch or create user data in Firestore
  //       await _handleFirebaseSignIn(userCredential, userData['name'],
  //           userData['email'], userData['picture']['data']['url']);
  //     }
  //   } catch (error) {
  //     Get.snackbar('Login Error', 'Failed to sign in with Facebook: $error',
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }
  // // Method to handle Firebase sign-in and user data storage
  // Future<void> _handleFirebaseSignIn(UserCredential userCredential,
  //     String? displayName, String? email, String? photoUrl) async {
  //   if (!await userDataExistsServices(userCredential.user!.uid)) {
  //     // If user data does not exist, create a new entry
  //     AppUser newUser = AppUser(
  //       id: userCredential.user!.uid,
  //       fullName: displayName ?? '',
  //       email: email ?? '',
  //       address: '',
  //       phone: '',
  //       postalCode: '',
  //       profilePic: photoUrl ?? '',
  //     );

  //     await saveUserDataToFirestore(newUser);
  //   } else {
  //     // If user data exists, navigate to the home screen
  //     Get.offAll(() => const HomeScreen());
  //   }
  // }
  Future<void> logout() async => await _auth.signOut();
}
