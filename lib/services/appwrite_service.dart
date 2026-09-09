import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteService {
  AppwriteService._();

  static Client? _client;

  static Client get client {
    _client ??= Client()
        .setEndpoint('https://nyc.cloud.appwrite.io/v1')
        .setProject('6a46a91700051cda76aa');
    return _client!;
  }

  static Account get _account => Account(client);

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    await signIn(email: email, password: password);
  }

  static Future<models.User> getCurrentUser() async {
    return _account.get();
  }

  static Future<void> signOut() async {
    await _account.deleteSession(sessionId: 'current');
  }
}
