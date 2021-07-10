import 'package:chemistry/src/atom.dart';
import 'package:chemistry/src/molecule.dart';

/// A singleton store of [Atom]s and [Molecule]s. [Atom]s and [Molecule]s
/// can be added and used from anywhere in the program.
///
/// Example usage:
/// ```dart
/// var chemistry = Chemistry();
/// chemistry.addAtom(Atom<int>(defaultValue: 0, key: 'someNumber'));
/// chemistry.addAtom(Atom<int>(defaultValue: 4, key: 'someOtherNumber'));
/// chemistry.addMolecule(Molecule<int>(
///   atoms: [
///     chemistry.getAtom<int>('someNumber'),
///     chemistry.getAtom<int>('someOtherNumber')
///   ],
///   computer: (getAtom) => getAtom<int>('someNumber')!.state +
///     getAtom<int>('someOtherNumber')!.state,
///   key: 'someMolecule',
/// ));
///
/// // Somewhere else in the program.
/// print(chemistry.getMolecule<int>('someMolecule')!.state);
/// ```
class Chemistry {
  /// The instance of this singleton.
  static Chemistry? _instance;

  /// All [Atom]s in the store. The key in this map is the key of the value
  /// [Atom].
  final _atoms = <String, Atom>{};

  /// All [Molecule]s in the store. The key in this map is the key of the value
  /// [Molecule].
  final _molecules = <String, Molecule>{};

  /// Internal constructor. Sets [_instance] to this instance.
  Chemistry._internal() {
    _instance = this;
  }

  /// Returns the instance of this store if it exists, otherwise creates it
  /// and returns the newly created instance.
  factory Chemistry() => _instance ?? Chemistry._internal();

  /// Adds an [Atom] to the store.
  /// [atom] is the [Atom] to be added to the store.
  ///
  /// Returns the [Atom] added to the store if no [Atom] with the same key
  /// exists, otherwise returns null.
  Atom<T>? addAtom<T>(Atom<T> atom) {
    if (_atoms.containsKey(atom.key)) {
      return null;
    }

    return _atoms.putIfAbsent(atom.key, () => atom) as Atom<T>;
  }

  /// Remove an [Atom] from the store.
  /// [key] the key of the [Atom] to remove.
  ///
  /// Returns `true` if an [Atom] with the key [key] could be removed, otherwise
  /// `false`.
  bool removeAtom(String key) {
    _atoms[key]?.dispose();
    return _atoms.remove(key) != null;
  }

  /// Gets an [Atom] from the store.
  /// [key] the key of the [Atom] to get.
  ///
  /// Returns the [Atom] with the key [key] from the store if it exist and if
  /// the [Atom] is of the type Atom<T>. Otherwise, returns null.
  Atom<T>? getAtom<T>(String key) {
    if (!_atoms.containsKey(key)) {
      return null;
    }

    var atom = _atoms[key];

    if (atom is! Atom<T>) {
      return null;
    }

    return _atoms[key] as Atom<T>;
  }

  /// Adds a [Molecule] to the store.
  /// [molecule] the [Molecule] to be added to the store.
  ///
  /// Returns the [Molecule] added to the store if no [Molecule] with the same
  /// key exists, otherwise returns null.
  Molecule<T>? addMolecule<T>(Molecule<T> molecule) {
    if (_molecules.containsKey(molecule.key)) {
      return null;
    }

    return _molecules.putIfAbsent(molecule.key, () => molecule) as Molecule<T>;
  }

  /// Remove a [Molecule] from the store.
  /// [key] the key of the [Molecule] to remove.
  ///
  /// Returns `true` if a [Molecule] with the key [key] could be removed,
  /// otherwise false.
  bool removeMolecule(String key) {
    _molecules[key]?.dispose();
    return _molecules.remove(key) != null;
  }

  /// Gets a [Molecule] from the store.
  /// [key] the key of the [Molecule] to get.
  ///
  /// Returns the [Molecule] with the key [Molecule] from the store if it exist
  /// and if the [Molecule] is of the type Molecule<T>. Otherwise, returns null.
  Molecule<T>? getMolecule<T>(String key) {
    if (!_molecules.containsKey(key)) {
      return null;
    }

    var molecule = _molecules[key];

    if (molecule is! Molecule<T>) {
      return null;
    }

    return _molecules[key] as Molecule<T>;
  }

  /// Calls the dispose() method and all atoms and molecules and then removes
  /// them. Think of this as a destructor that you have to call.
  void dispose() {
    _atoms.entries.forEach((element) {
      element.value.dispose();
    });
    _molecules.entries.forEach((element) {
      element.value.dispose();
    });

    _atoms.clear();
    _molecules.clear();
  }
}
