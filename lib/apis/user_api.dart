import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/constants/appwrite/appwrite_providers.dart';
import 'package:the_iconic/core/type_definitions.dart';
import 'package:the_iconic/errors/responses.dart';
import 'package:the_iconic/models/user_model.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);

  return UserApi(db: db, realtime: realtime);
});

abstract class IUserApi {
  FutureEitherVoid saveUserData(UserModel userModel);

  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserProfile(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
}

class UserApi implements IUserApi {
  final Databases _db;
  final Realtime _realtime;

  UserApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? 'Unexpected error',
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }

//********** if something goes wrong remove async and await , because wasn't their before */

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final searchResults = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollection,
      queries: [
        Query.search('name', name),
      ],
    );
    final listOfAvailableUsers = searchResults.documents;

    return listOfAvailableUsers;
  }

  @override
  FutureEitherVoid updateUserProfile(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? 'Unexpected error',
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.userCollection}.documents'
    ]).stream;
  }
}
