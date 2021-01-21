import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kifcab/screens/index.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key key,
    @required RegisterBloc registerBloc,
  })  : _registerBloc = registerBloc,
        super(key: key);

  final RegisterBloc _registerBloc;

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  RegisterScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        cubit: widget._registerBloc,
        builder: (
          BuildContext context,
          RegisterState currentState,
        ) {
          if (currentState is UnRegisterState) {
            return Center(
              child: Text("Loading page..."),
              //child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorRegisterState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InRegisterState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return Container(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._registerBloc.add(LoadRegisterEvent());
  }
}
