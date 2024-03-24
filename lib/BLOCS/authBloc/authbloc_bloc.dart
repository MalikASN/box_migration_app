import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authbloc_event.dart';
import 'authbloc_state.dart';

final storage = new FlutterSecureStorage();

class AuthBloc extends Bloc<AuthEvents, AuthblocState> {
  AuthBloc(authblocInitial) : super(AuthblocInitial()) {
    on<AuthLogin>((event, emit) async {
      try {
        emit(AuthblocLoadingState());

        var response = await getData(event.email, event.password);

        if (response.toString().compareTo("success") == 0) {
          await storage.write(key: 'isLogged', value: "true");

          emit(AuthblocSuccessState());
        } else if (response.toString().compareTo("No such user") == 0) {
          emit(AuthblocErrorState("Identifiants incorrects"));
        } else if (response.toString().compareTo("wrong password") == 0) {
          emit(AuthblocErrorState("Mot de passe incorrect!"));
        }
      } catch (e) {
        emit(AuthblocErrorState(e.toString()));
      }
    });
  }
}

Future<String> getData(String email, String motDePasse) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var url = Uri.parse("${prefs.get('IP')}/PHPServer/login.php");
  var request = http.Request('POST', url);

  request.bodyFields = {
    "user_email": email,
    "user_password": md5.convert(utf8.encode(motDePasse)).toString()
  };
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // Parse the JSON response
      dynamic data = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = jsonDecode(data);

      // Check if the response contains an error or success message
      if (jsonData.containsKey("error")) {
        // Show error message
        String errorMessage = jsonData["error"];
        return errorMessage;
      } else if (jsonData.containsKey("message")) {
        // Show success message
        String successMessage = jsonData["message"];
        return successMessage;
      } else {
        return "Unknown response format";
      }
    } else {
      return "Failed to load data. Status code: ${response.statusCode}";
    }
  } catch (e) {
    print(e.toString());
  }
  return "";
}
