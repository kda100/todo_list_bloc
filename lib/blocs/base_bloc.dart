import 'dart:async';

abstract class BaseBloc<State, Event> {
  BaseBloc() {
    _eventStreamController.stream.listen(mapEventToState);
  }

  final _stateStreamController = StreamController<State>.broadcast();
  Stream<State> get stateStream => _stateStreamController.stream;

  void addState(State state) {
    _stateStreamController.sink.add(state);
  }

  final _eventStreamController = StreamController<Event>();
  void addEvent(Event event) {
    _eventStreamController.sink.add(event);
  }

  mapEventToState(Event event);
}
