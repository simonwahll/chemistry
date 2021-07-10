import 'package:chemistry/chemistry.dart';
import 'package:test/test.dart';

void main() {
  // Atom
  test('Atom is created', () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    expect(atom.key, equals('atom'));
    expect(atom.state, equals(0));
    expect(atom.stateStream, isA<Stream>());
  });
  test("Atom's state changes", () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    atom.setState(1);
    expect(atom.state, 1);
  });
  test("Atom's .stateStream emits an event on state change", () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    atom.stateStream.first.then((value) => expect(value, 1));
    atom.setState(1);
  });

  // Atom Chemistry
  test('Atom is added to the chemistry store', () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    expect(Chemistry().addAtom(atom), equals(atom));
    expect(Chemistry().getAtom('atom'), equals(atom));
  });
  test('All atoms are cleared from the store when calling .dispose()', () {
    Chemistry().dispose();
    expect(Chemistry().getAtom('atom'), isNull);
  });
  test(
      'Atom with a key that already exist in the store is not added to the store',
      () {
    var first = Atom(defaultValue: 0, key: 'atom');
    var second = Atom(defaultValue: 0, key: 'atom');
    Chemistry().addAtom(first);
    expect(Chemistry().addAtom(second), equals(null));
    Chemistry().dispose();
  });
  test('Atom is removed from the store', () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    Chemistry().addAtom(atom);
    expect(Chemistry().removeAtom('atom'), isTrue);
    expect(Chemistry().getAtom('atom'), isNull);
    Chemistry().dispose();
  });

  // Molecule
  test('Molecule is created', () {
    var atom = Atom(defaultValue: 0, key: 'atom');
    Chemistry().addAtom(atom);
    var molecule =
        Molecule(atoms: [atom], computer: (getAtom) => 0, key: 'molecule');
    expect(molecule.key, 'molecule');
    expect(molecule.state, 0);
    expect(molecule.stateStream, isA<Stream>());
    Chemistry().dispose();
  });
  test("Molecule's state changes", () {
    var atom = Atom(defaultValue: 0, key: 'first');
    Chemistry().addAtom(atom);
    Chemistry().addAtom(Atom<int>(defaultValue: 0, key: 'second'));
    var molecule = Molecule<int>(
        atoms: [atom, Chemistry().getAtom<int>('second')!],
        computer: (getAtom) {
          return getAtom<int>('first')!.state + getAtom<int>('second')!.state;
        },
        key: 'molecule');
    molecule.stateStream.listen((value) {
      expect(value, equals(1));
      expect(molecule.state, equals(1));
      Chemistry().dispose();
    });
    atom.setState(1);
  });

  // Molecule Chemistry
  test('Molecule is added to the chemistry store', () {
    Chemistry().addAtom(Atom<int>(defaultValue: 0, key: 'atom'));
    var molecule = Molecule<int>(
      atoms: [Chemistry().getAtom<int>('atom')!],
      computer: (atoms) => 1,
      key: 'molecule',
    );
    Chemistry().addMolecule<int>(molecule);
    expect(Chemistry().getMolecule<int>('molecule'), equals(molecule));
    Chemistry().dispose();
  });
  test('Molecule is removed from the store', () {
    Chemistry().addAtom(Atom<int>(defaultValue: 0, key: 'atom'));
    Chemistry().addMolecule(Molecule(
        atoms: [Chemistry().getAtom<int>('atom')!],
        computer: (getAtom) => 1,
        key: 'molecule'));
    expect(Chemistry().removeMolecule('molecule'), isTrue);
    expect(Chemistry().getMolecule('molecule'), isNull);
  });
}
