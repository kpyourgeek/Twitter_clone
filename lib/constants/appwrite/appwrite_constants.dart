class AppwriteConstants {
  static const String databaseId = '65d4e0c50d883be8ddbe';
  static const String projectId = '65d4a97308db45be3fc5';
  static const String endPoint = 'https://cloud.appwrite.io/v1';
  static const String userCollection = '65ef307bea8ad76b2d1b';
  static const String tweetsCollection = '6638b4bc000f221ba926';
  static const String imageBucket = '663642710009e7e54153';
  static String imageUrl(String imageId) =>
      'https://cloud.appwrite.io/v1/storage/buckets/$imageBucket/files/$imageId/view?project=$projectId&mode=admin';
}
