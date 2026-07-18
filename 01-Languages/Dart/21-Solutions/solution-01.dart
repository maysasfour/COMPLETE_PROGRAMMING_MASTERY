// solution-01.dart - Exercise 01: Null Safety & Validation.

class InvalidUsernameException implements Exception {
  final String message;
  InvalidUsernameException(this.message);
  @override
  String toString() => 'InvalidUsernameException: $message';
}

class UserProfile {
  final String username;
  final String? bio;
  // late final: the DECLARATION promises a DateTime will exist, but the actual
  // assignment happens in the constructor BODY (after validation), not the
  // initializer list -- proving `late` genuinely defers initialization.
  late final DateTime registeredAt;

  UserProfile(this.username, {this.bio}) {
    if (username.trim().isEmpty) {
      throw InvalidUsernameException('username cannot be blank');
    }
    registeredAt = DateTime.now();
  }

  String displayBio() => bio ?? 'No bio provided';
}

void main() {
  print('--- Profile with a bio ---');
  var withBio = UserProfile('ada', bio: 'Mathematician and programmer.');
  print(withBio.displayBio());

  print('\n--- Profile with bio: null ---');
  var noBio = UserProfile('grace');
  print(noBio.displayBio());

  print('\n--- Blank username caught ---');
  try {
    UserProfile('   ');
  } on InvalidUsernameException catch (e) {
    print('Caught expected error: $e');
  }

  print('\n--- Narrowing String? via ?. and ! ---');
  String? maybeName = withBio.bio;
  print('maybeName?.toUpperCase(): ${maybeName?.toUpperCase()}');
  // Safe here ONLY because we already know withBio.bio is non-null (set above with a bio) --
  // ! throws "Null check operator used on a null value" if the assumption is ever wrong.
  String definitelyName = maybeName!;
  print('definitelyName (after !): $definitelyName');
}
