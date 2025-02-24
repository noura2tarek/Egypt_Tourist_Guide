import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/governorate_model.dart';
import '../../models/place_model.dart';
import '../../models/user_model.dart';

class FirebaseService {
  //------- Firebase auth feature ------//
  static FirebaseAuth authInstance = FirebaseAuth.instance;

  //--- Sign in with email and password method ---//
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final credentials = await authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credentials.user;
  }

  //--- Create user with email and password ---//
  static Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final credential = await authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Log out from firebase auth
  static Future<void> signOut() async => await authInstance.signOut();

  /////////////////////////////////////////////////
  //----- Firebase firestore feature -----//

  // database instance
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // create a collection called users
  static CollectionReference users = db.collection('users');

  // Add user document to the collection users in database after sign up
  static Future<String> addUser({
    required String uid, // user id of user while authenticating
    required UserModel user,
  }) async {
    var docId = '';
    // Call the user's CollectionReference to add a new user
    users.add({
      'uid': uid,
      'name': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'favPlaces': [],
      'address': user.address ?? '',
    }).then(
      (document) => docId = document.id,
    );
    return docId;
  }

  // Get user data from firestore
  static Future<UserModel> getUserData() async {
    UserModel? user;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await users.where('uid', isEqualTo: userId).get().then(
      (value) {
        user =
            UserModel.fromMap(value.docs.first.data() as Map<String, dynamic>);
      },
    ).catchError((e) {
      print(e);
    });
    return user!;
  }

  // Update user data
  static Future<void> updateUserData({
    required UserModel user,
  }) async {
    String userId = authInstance.currentUser!.uid;

    users.where('uid', isEqualTo: userId).get().then((value) {
      users.doc(value.docs.first.id).update(user.toMap());
    });
  }

  // Create a collection called governorates
  static CollectionReference<Map<String, dynamic>> governoratesCollection =
      db.collection('governorates');

  //--- Get english governorates method ---//
  static Future<List<GovernorateModel>> getGovernorates() async {
    List<GovernorateModel> governorates = [];
    await governoratesCollection.get().then((event) {
      for (var doc in event.docs) {
        governorates.add(GovernorateModel.fromFirestore(doc));
      }
    });
    return governorates;
  }

  // Create a collection called arabic governorates
  static CollectionReference<Map<String, dynamic>> governoratesACollection =
      db.collection('arabic_governorates');

  //--- Get arabic governorates method ---//
  static Future<List<GovernorateModel>> getArabicGovernorates() async {
    List<GovernorateModel> arabicGovernorates = [];
    await governoratesACollection.get().then((event) {
      for (var doc in event.docs) {
        arabicGovernorates.add(GovernorateModel.fromFirestore(doc));
      }
    });
    return arabicGovernorates;
  }

  // Create a collection called places
  static CollectionReference<Map<String, dynamic>> placesCollection =
      db.collection('places');

  //----- Get places method -----//
  static Future<List<PlacesModel>> getPlaces() async {
    List<PlacesModel> places = [];
    await placesCollection.get().then((event) {
      for (var doc in event.docs) {
        places.add(PlacesModel.fromMap(doc.data()));
      }
    });
    return places;
  }

  // Create a collection called arabic places
  static CollectionReference<Map<String, dynamic>> placesACollection =
      db.collection('arabic_places');

  //---- Get Arabic places method ----//
  static Future<List<PlacesModel>> getArabicPlaces() async {
    List<PlacesModel> arabicPlaces = [];
    await placesACollection.get().then((event) {
      for (var doc in event.docs) {
        arabicPlaces.add(PlacesModel.fromMap(doc.data()));
      }
    });
    return arabicPlaces;
  }

  //--- Get user favourite places Method ---//
  static Future<List<int>> getUserFavouritePlacesId({
    required String uid,
    required bool isEnglish,
  }) async {
    final snapshot = await users.where('uid', isEqualTo: uid).get();

    // Extract the likedPlaces array from the document
    List<dynamic> favPlacesDynamic = snapshot.docs.first['favPlaces'];

    // Convert the dynamic list to a List<int>
    return favPlacesDynamic.map((item) => item as int).toList();
  }

  //--- Get place model by id Method from Firebase ---//
  static Future<PlacesModel> getPlaceById(
      {required int id, required bool isEnglish}) async {
    final snapshot = await db
        .collection(isEnglish ? 'places' : 'arabic_places')
        .where('id', isEqualTo: id)
        .get();
    return PlacesModel.fromMap(snapshot.docs.first.data());
  }

//--- Toggle favourite place Method ---//
// Update the favPlaces array in the user document
  static Future<void> toggleFavouritePlace({
    required User? user,
    required PlacesModel placeE,
  }) async {
    if (user == null) {
      throw FirebaseAuthException(code: "no_user_found");
    }

    String uid = user.uid;

    // Get favourite places of that user
    final snapshot = await users.where('uid', isEqualTo: uid).get();
    if (snapshot.docs.isEmpty) {
      throw FirebaseAuthException(code: "no_user_found");
    }

    DocumentReference userDoc = snapshot.docs.first.reference;
    List<dynamic> favPlaces = snapshot.docs.first['favPlaces'] ?? [];

    // check if that place is favourite or not
    if (favPlaces.contains(placeE.id)) {
      favPlaces.remove(placeE.id);
    } else {
      favPlaces.add(placeE.id);
    }

    // Update current favPlaces on firestore
    await userDoc.update({'favPlaces': favPlaces});
  }
}
