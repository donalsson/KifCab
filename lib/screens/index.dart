import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(RegisterState initialState) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'RegisterBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}

@immutable
abstract class RegisterEvent {
  Stream<RegisterState> applyAsync({RegisterState currentState, RegisterBloc bloc});
}

class UnRegisterEvent extends RegisterEvent {
  @override
  Stream<RegisterState> applyAsync({RegisterState currentState, RegisterBloc bloc}) async* {
    yield UnRegisterState();
  }
}

class LoadRegisterEvent extends RegisterEvent {
  @override
  Stream<RegisterState> applyAsync({RegisterState currentState, RegisterBloc bloc}) async* {
    try {
      yield UnRegisterState();
      await Future.delayed(Duration(seconds: 1));
      yield InRegisterState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadRegisterEvent', error: _, stackTrace: stackTrace);
      yield ErrorRegisterState(_?.toString());
    }
  }
}

abstract class RegisterState extends Equatable {
  final List propss;
  RegisterState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnRegisterState extends RegisterState {
  UnRegisterState();

  @override
  String toString() => 'UnRegisterState';
}

/// Initialized
class InRegisterState extends RegisterState {
  final String hello;

  InRegisterState(this.hello) : super([hello]);

  @override
  String toString() => 'InRegisterState $hello';
}

class ErrorRegisterState extends RegisterState {
  final String errorMessage;

  ErrorRegisterState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorRegisterState';
}
