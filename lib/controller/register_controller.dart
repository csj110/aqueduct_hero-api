import 'package:first_aqueduct/first_aqueduct.dart';
import 'package:first_aqueduct/model/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);
  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest()
        ..body({"error": "username and password is required"});
    }
    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    return Response.ok(await Query(context, values: user).insert());
  }
}
