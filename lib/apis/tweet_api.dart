import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/constants/appwrite/appwrite_providers.dart';
import 'package:the_iconic/core/type_definitions.dart';
import 'package:the_iconic/errors/responses.dart';
import 'package:the_iconic/models/tweet_model.dart';

final tweetApiProvider = Provider(
  (ref) {
    final db = ref.watch(appwriteDatabasesProvider);
    return TweetApi(db: db);
  },
);

abstract class ITweet {
  FutureEither<Document> shareTweet(
    Tweet tweet,
  );
  Future<List<Document>> getTweets();
}

class TweetApi implements ITweet {
  final Databases _db;
  TweetApi({required Databases db}) : _db = db;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Unexpected error',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

// ************* CHECK THIS METHOD IF TWEETS DOESN'T COME PLEASE

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
    );
    final listOfDocuments = documents.documents;
    return listOfDocuments;
  }
}
