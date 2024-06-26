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
    final realtime = ref.watch(appwriteRealtimeProvider);
    return TweetApi(db: db, realtime: realtime);
  },
);

abstract class ITweet {
  FutureEither<Document> shareTweet(
    Tweet tweet,
  );
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Stream<RealtimeMessage> getUserLatestTweets();
}

class TweetApi implements ITweet {
  final Databases _db;
  final Realtime _realtime;
  TweetApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

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
      queries: [Query.orderDesc('tweetedAt')],
    );
    final listOfDocuments = documents.documents;
    return listOfDocuments;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
      ],
    ).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            'likes': tweet.likes,
          });

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

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            'reshareCount': tweet.reshareCount,
          });

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

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.equal('repliedTo', tweet.id),
        ]);
    final listOfDocuments = documents.documents;
    return listOfDocuments;
  }

  @override
  Future<Document> getTweetById(String id) async {
    return await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [Query.equal('uid', uid)],
    );
    final userTweets = documents.documents;
    return userTweets;
  }

  @override
  Stream<RealtimeMessage> getUserLatestTweets() {
    final userTweets = _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
      ],
    ).stream;
    return userTweets;
  }
}
