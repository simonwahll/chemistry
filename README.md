# Chemistry

If you intend to use this package with Flutter you should also take a look at the flutter_chemistry package.

## About

Chemistry is a state management library highly inspired by Recoil for React. It aims to be easy to use and integrate well with the Flutter platform.

Chemistry separates pure state from derived state. Pure state is called Atoms and derived state is called Molecules. A store, called Chemistry, is provided where all atoms and molecules can be stored and accessed anywhere in the program. This allows state to be accessed and modified in any widget without passing any state as parameters between them.

See the example for an example.

## Installation

```
pub flutter pub add chemistry
```

## Usage

### Importing

```dart
import 'package:chemistry/chemistry.dart';
```

### Atom

An atom is a pure state. It's a generic class that should be provided with the type of the data to be stored. It requires a default value and a key. The key must be globally unique among all atoms. Most of the time, the key will be the same as the name of the atom.

Creating an atom:

```dart
var myAtom = Atom<String>(defaultValue: 'Welcome', key: 'myAtom');
```

The value of an atom can be accessed with the `.state` getter. 

```dart
print(myAtom.state);
```

Changes to the state can be listened to with the `.stateStream` getter. This stream will emit an event every time the state of the atom changes.

```dart
myAtom.stateStream.listen((state) => print(state));
```

The state of the atom can be changed with the `.setState()` method.

```dart
myAtom.setState('Chemistry');
```

### Atom Chemistry

The `Chemistry()` class is a singleton that can store atoms and molecules. This allows it to be initialized anywhere in the program and all instances of it will be the same.

Adding an atom to the store:

```dart
var chemistry = Chemistry();
chemistry.addAtom<String>(myAtom);
```

Removing an atom from the store (note that the key of the atom to remove is passed as the argument):

```dart
chemistry.removeAtom('myAtom');
```

Getting an atom from the store (note that the key of the atom to get is passed as the argument):

```dart
var myAtom = chemistry.getAtom<String>('myAtom');
```

The `.getAtom<T>()` method will return the atom if it exists and it is of the type Atom<T>, otherwise it will return null.

### Molecule

A molecule is state derived from one or multiple atoms. It's a generic class that should be provided with the type of the data to be stored. It requires a list of atoms, computer function and a key. The key must be globally unique among all atoms. Most of the time, the key will be the same as the name of the atom.

The list of atoms are used when the value of the molecule is calculated. The value of the molecule is automatically recalculated when one of the atoms's state changes. These are then passed to the computer function. 

The computer function is a function that takes one argument: a function that can be used to retreive the atoms provided in the constructor of the molecule.

Creating a molecule:

```dart
var myMolecule = Molecule<int>(
    atoms: [firstAtom, secondAtom],
    computer: (getAtom) =>
        getAtom<int>('firstAtom')!.state + getAtom<int>('secondAtom')!.state,
    key: 'myMolecule');
```

The value of a molecule can be accessed with the `.state` getter. 

```dart
print(myMolecule.state);
```

Changes to the state can be listened to with the `.stateStream` getter. This stream will emit an event every time the state of the molecule changes.

```dart
myMolecule.stateStream.listen((state) => print(state));
```

### Molecule Chemistry

Similar to how atoms can be stored in the Chemistry store, molecules can also be stored in the Chemistry store. 

Adding a molecule to the store:

```dart
var chemistry = Chemistry();
chemistry.addMolecule<int>(myMolecule);
```

Removing a molecule from the store (note that the key of the molecule to remove is passed as the argument):

```dart
chemistry.removeMolecule('myMolecule');
```

Getting a molecule from the store (note that the key of the molecule to get is passed as the argument):

```dart
var myMolecule = chemistry.getMolecule<String>('myMolecule');
```

The `.getMolecule<T>()` method will return the molecule if it exists and if it is of the type Molecule<T>, otherwise it will return null.