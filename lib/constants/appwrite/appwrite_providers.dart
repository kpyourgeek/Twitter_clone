import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: false);
});

final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabasesProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});
final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
