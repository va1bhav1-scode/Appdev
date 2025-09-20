import 'dart:io';

void main() {
  // INPUT: Ask user for a number
  stdout.write("Enter a number: ");
  String? input = stdin.readLineSync();
  int number = int.tryParse(input ?? '') ?? 0;

  // OUTPUT: Confirm input
  print("You entered: $number");

  // LOOP: Print numbers from 1 to the entered number using a for loop
  print("\nUsing for loop:");
  for (int i = 1; i <= number; i++) {
    print("Count: $i");
  }

  // LOOP: Print numbers from entered number down to 1 using a while loop
  print("\nUsing while loop:");
  int j = number;
  while (j >= 1) {
    print("Reverse Count: $j");
    j--;
  }
}
