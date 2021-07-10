import 'dart:async';

/// An atom is a single piece of state. It can be used independently or combined
/// with [Chemistry]. This is a generic class which allows it to be used very
/// dynamically.
///
/// Example usage:
/// ```dart
/// var myAtom = Atom<String>(defaultValue: 'Welcome', key: 'myAtom');
/// myAtom.stateStream.listen((state) => print(state));
/// ```
class Atom<T> {
  /// A globally unique key. Usually the same as the name of this [Atom].
  late final String key;

  /// Used to broadcast changes to this [Atom]'s [_state] to all listeners.
  final StreamController<T> _controller = StreamController<T>.broadcast();

  /// This [Atom]'s state.
  late T _state;

  /// A broadcast stream that can be listened to. Whenever the state of this
  /// [Atom] changes a new event will be emited on this stream providing the
  /// listener with the new state.
  Stream<T> get stateStream => _controller.stream;

  /// Get the state of this [Atom].
  T get state => _state;

  /// Set the state of this atom. This will emit an event on the [stateStream]
  /// stream.
  /// [newState] the state to be set as this [Atom]'s state.
  void setState(T newState) {
    _state = newState;
    _controller.add(_state);
  }

  /// Constructor that returns a new atom.
  /// [defaultValue] the default value of this [Atom], used to avoid setting
  /// null as the default value.
  /// [key] a globally unique key that identifies this [Atom].
  ///
  /// Returns the newly created [Atom].
  Atom({required T defaultValue, required String key}) : key = key {
    setState(defaultValue);
  }

  /// The [dispose] method should always be called before this atom is
  /// destroyed. It will close [_controller]. Think of this as a destructor
  /// that you have to manually call.
  void dispose() {
    _controller.close();
  }
}
