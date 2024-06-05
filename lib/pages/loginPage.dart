import 'package:box_migration_app/BLOCS/authBloc/authbloc_bloc.dart';
import 'package:box_migration_app/flutter_flow/flutter_flow_util.dart';
import 'package:box_migration_app/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BLOCS/authBloc/authbloc_event.dart';
import '../BLOCS/authBloc/authbloc_state.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isconnecting = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController IpController = TextEditingController();
  final TextEditingController BScontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fillText();
  }

  void fillText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      IpController.text = prefs.get('IP').toString();
      BScontroller.text = prefs.get('batchSize').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocListener<AuthBloc, AuthblocState>(
              listener: (context, state) {
                if (state is AuthblocErrorState) {
                  setState(() {
                    isconnecting = false;
                  });
                  final snackbar = SnackBar(
                    backgroundColor: Color.fromARGB(255, 190, 1, 1),
                    content: Row(
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        SizedBox(width: 10),
                        Text(state.errorMessage,
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else if (state is AuthblocSuccessState) {
                  // Navigate to the homepage
                  context.go("/homepage");
                }
              },
              child: Container(),
            ),
            Text(
              "Migration App",
              style: TextStyle(
                fontFamily: "Outfit",
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            Material(
              color: FlutterFlowTheme.of(context).primaryBackground,
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 22.0, 8.0, 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "S'authentifier",
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // Wrap the first widget with Expanded
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 2,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 55,
                                      child: TextFormField(
                                        controller: IpController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '10.xx.xx.xx',
                                          icon: Icon(
                                            Icons.numbers,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter the IP';
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'IP', IpController.text.toString());
                                    final snackbar = SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 42, 190, 1),
                                      content: Row(
                                        children: [
                                          Icon(Icons.error,
                                              color: Colors.white),
                                          SizedBox(width: 10),
                                          Text("Adresse IP sauvegardée",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // Wrap the first widget with Expanded
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 2,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 55,
                                      child: TextFormField(
                                        controller: BScontroller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'ex : 10',
                                          icon: Icon(
                                            Icons.numbers,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              int.parse(value) <= 0) {
                                            return 'Please entera valid batch size';
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('batchSize',
                                        BScontroller.text.toString());
                                    final snackbar = SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 42, 190, 1),
                                      content: Row(
                                        children: [
                                          Icon(Icons.error,
                                              color: Colors.white),
                                          SizedBox(width: 10),
                                          Text("Taille du lot sauvegardée",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 55,
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    icon: Icon(
                                      Icons.email,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 55,
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    icon: Icon(
                                      Icons.lock,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: FFButtonWidget(
                          text: isconnecting ? "patientez..." : "Se connecter",
                          onPressed: () {
                            if (isconnecting) {
                              return; // Return early if isconnecting is true
                            }

                            setState(() {
                              isconnecting = true;
                            });

                            context.read<AuthBloc>().add(AuthLogin(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          options: FFButtonOptions(
                            width: 340.0,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
