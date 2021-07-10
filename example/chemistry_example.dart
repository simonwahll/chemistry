import 'dart:io';
import 'package:chemistry/chemistry.dart';

void main() async {
  var firstNumber = Atom<int>(defaultValue: 0, key: 'firstNumber');
  var secondNumber = Atom<int>(defaultValue: 0, key: 'secondNumber');
  var operator = Atom<String>(defaultValue: '+', key: 'operator');
  var result = Molecule(
      atoms: [firstNumber, secondNumber, operator],
      computer: (getAtom) {
        var firstNumber = getAtom<int>('firstNumber');
        var secondNumber = getAtom<int>('secondNumber');
        var operator = getAtom<String>('operator');

        if (firstNumber == null || secondNumber == null || operator == null) {
          return 'Error';
        }

        switch (operator.state) {
          case '+':
            return firstNumber.state + secondNumber.state;
          case '-':
            return firstNumber.state - secondNumber.state;
          case '*':
            return firstNumber.state * secondNumber.state;
          case '/':
            return firstNumber.state / secondNumber.state;
        }

        return 'Error';
      },
      key: 'sum');

  print('Enter an integer: ');

  var input = stdin.readLineSync() ?? '';
  var first = int.tryParse(input);

  if (first == null) {
    print('You must enter an integer...');
    return;
  }

  firstNumber.setState(first);

  print('Enter another integer: ');

  input = stdin.readLineSync() ?? '';
  var second = int.tryParse(input);

  if (second == null) {
    print('You must eneter an integer...');
    return;
  }

  secondNumber.setState(second);

  print('Enter an operator (+, -, *, /): ');

  input = stdin.readLineSync() ?? '';

  operator.setState(input);

  var res = await result.stateStream.first;
  print(res);
}
