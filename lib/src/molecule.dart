import 'dart:async';
import 'package:chemistry/src/atom.dart';

/// A Molecule is a derived state from one or multiple [Atom]s. This is a
/// generic class which allows it to be used very dynamically.
///
/// Example usage:
/// ```dart
/// var myMolecule = Molecule<int>(
///   atomKeys: ['someAtom'],
///   computer: (atoms) => atoms.values.fold<int>(
///     0, (previousValue, element) => previousValue + element.state),
///   key: 'myMolecule'));
/// myMolecule.stateStream.listen((state) => print(state));
/// ```
class Molecule<T> {
  /// Used to broadcast changes to this [Molecule]'s [_state] to all listeners.
  final StreamController<T> _controller = StreamController<T>.broadcast();

  /// A globally unique key. Usually the same as the name of this [Molecule].
  late final String key;

  /// The function used to compute the value of this [Molecule].
  late final T Function(Atom<E>? Function<E>(String key) getAtom) _computer;

  /// The keys of all atoms that should be used when calculating the value of
  /// this [Molecule].
  late final List<Atom> _atoms;

  /// This [Molecule]s state.
  late T _state;

  /// A broadcast stream that can be listened to. Whenever the state of this
  /// [Molecule] changes a new event will be emited on this stream providing the
  /// listener with the new state.
  Stream<T> get stateStream => _controller.stream;

  /// Get the state of this [Molecule].
  T get state => _state;

  /// Constructor.
  /// [atoms] the [Atom]s to be used when computing this [Molecule]'s value.
  /// [computer] the function that computes this [Molecule]'s value.
  /// [key] this [Molecule]'s globally unique key.
  ///
  /// Returns the newly created [Molecule].
  Molecule(
      {required List<Atom> atoms,
      required T Function(Atom<E>? Function<E>(String getAtom)) computer,
      required String key})
      : _atoms = atoms,
        _computer = computer,
        key = key {
    _atoms.forEach((atom) {
      atom.stateStream.listen((value) {
        _computeValue();
      });
    });

    _computeValue();
  }

  /// Called when the value of an [Atom] that exists in [_atoms] changes.
  /// It computes the new state of this [Molecule].
  void _computeValue() {
    _state = _computer(<E>(String key) {
      if (_atoms.indexWhere((atom) => atom.key == key) == -1) {
        return null;
      }

      var atom = _atoms.firstWhere((atom) => atom.key == key);

      if (atom is! Atom<E>) {
        return null;
      }

      return atom;
    });
    _controller.add(_state);
  }

  /// The [dispose] method should always be called before this [Molecule] is
  /// destroyed. It will close [_controller]. Think of this as a destructor that
  /// you have to manually call.
  void dispose() {
    _controller.close();
  }
}
