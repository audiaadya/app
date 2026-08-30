import 'package:appwrite/appwrite.dart';

Future<void> main() async {
  final client = Client()
      .setEndpoint('https://nyc.cloud.appwrite.io/v1')
      .setProject('6a46a91700051cda76aa');

  final account = Account(client);

  const email = 'copilot.demo.user@example.com';
  const password = 'Password123!';

  print('Attempting Appwrite signup...');

  try {
    final user = await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: 'Copilot Demo User',
    );

    print('SUCCESS');
    print('userId=${user.$id}');
    print('email=${user.email}');
  } catch (error) {
    print('ERROR');
    print(error);
    rethrow;
  }
}
