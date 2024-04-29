import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/constants/appwrite/appwrite_providers.dart';
import 'package:the_iconic/core/type_definitions.dart';
import 'package:the_iconic/errors/responses.dart';
import 'package:the_iconic/models/user_model.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  return UserApi(db: db);
});

abstract class IUserApi {
  FutureEitherVoid saveUserData(UserModel userModel);
}

class UserApi implements IUserApi {
  final Databases _db;
  UserApi({required Databases db}) : _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollection,
        documentId: ID.unique(),
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
}
