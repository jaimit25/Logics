import 'dart:io';
import "dart:math";
import 'dart:collection';

void main() {
  List<int> m = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int list_divison_first = 30;
  // print("Random Element is :  ${getProbablityElement(m, 30)} ");

  List sequence = [];
  for(int i = 0; i  < 20 ; i++){
    sequence.add(getProbablityElement(m, list_divison_first));
  }
  sequence.sort();
  printList( sequence);


}

int getProbablityElement(List<int> m, int list_divison_first) {
  //  List<int> m = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  printList(m);
  int n = m.length; //size of list
  // int list_divison_first = 30; //dividing list elements into 30:70 Ratio
  int szOfFirstHalfOfList = getNoFromPercentage(list_divison_first, n);
//   print(szOfFirstHalfOfList);
  final _random = new Random();

  var phase1_State = [];
  var phase2_State = [];
  List<int> pl1 = [];
  List<int> pl2 = [];
  int i = 0;

  //Set Up - Divide m list elements into 2 different list based on Ratio 3:7 for 30%
  for (i = 0; i < szOfFirstHalfOfList; i++) {
    phase2_State.add(m[i]);
  }
  for (i = i; i < n; i++) {
    phase1_State.add(m[i]);
  }

  ///Phase [1 and 2]
  ///[Phase 1] -  70%
  int secondHalf = (n - szOfFirstHalfOfList);
  int x = 0;
  int index;
  var x_list =
      []; //no of elements we have to choose for every iterations in phase1
  for (int i = 20; i <= 100; i = i + 10) {
    index = ((i / 10) - 2).toInt();
    x = getNoFromPercentage(i, secondHalf);
    x_list.add(x);
  }

  ///   [Reversing] the list
  x_list = new List.from(x_list.reversed);
  // printList(x_list);

  ///Total [9 iterations] to process the [list] [1]
  int start, end;
  bool check;
  int p_index =
      secondHalf; //phase1 index pointer to iterate through phase1 list
  List<int> tempL = [];

  /// [Iterations Start] Zero based Indexing
  for (int i = 8; i >= 0; i--) {
    check = canFitElements(i + 1, phase1_State.length);

    if (check) {
      //Elements are in the Range
      end = p_index - 1;
      start = (p_index - x_list[i].toInt()).toInt();

      ///PROCESSING [TEMPORARY] LIST SO THAT WE CAN CHOOSE RANDOM NUMBER FROM THE LIST
      int k = start;
      do {
        tempL.add(phase1_State[k]);
        k++;
      } while (k <= end);
      // printList(tempL);
      // generate a random index based on the list length
      // and use it to retrieve the element
      int Random_element = tempL[_random.nextInt(tempL.length)];
      pl1.add(Random_element);
      tempL.clear();
      p_index--; //decreasing pointer value
    } else {
      //Elements are not in the Range

      start = 0;
      end = x_list[i] - 1;

      ///PROCESSING [TEMPORARY] LIST SO THAT WE CAN CHOOSE RANDOM NUMBER FROM THE LIST
      int k = start;
      do {
        tempL.add(phase1_State[k]);
        k++;
      } while (k <= end);
      // printList(tempL);
      // generate a random index based on the list length
      // and use it to retrieve the element
      int Random_element = tempL[_random.nextInt(tempL.length)];
      pl1.add(Random_element);

      tempL.clear();
    }
  }
  print("PL1 value is : ");
  printList(pl1);
  int max_Element = getMaxRepeatedElementFromList(pl1, m);
  int max_count = getMaxRepeatedValueFromList(pl1, m);
  print("PHASE 1 : Max Element: $max_Element Max Count: $max_count");

  ///[Phase 2] - 30%
  int prev_time = max_count;
  int times = max_count;
  int start1 = 0, end1 = 0;
  tempL.clear();

  print(" \nphase 2 : ");
  printList(phase2_State);
  //list used in phase 2
  // print("phase 2 last index ${(phase2_State.length -1)}");
  for (int i = phase2_State.length - 1; i >= 0; i--) {
    //creating temp list
    start1 = 0;
    end1 = i;
    // print("start value is : ${start1} end value : ${end1}");
    int k = start1;
    do {
      tempL.add(phase2_State[k]);
      k++;
    } while (k <= end1);
    // printList(tempL);

    //Temporary list is created - now generating probability list 2
    for (int j = 0; j <= (2 * prev_time) - 1; j++) {
      stdout.write("* ");
      int Random_element = tempL[_random.nextInt(tempL.length)];
      pl2.add(Random_element);
    }
    prev_time = prev_time - 1;
    print("\n");
    tempL.clear();
  }

  print("PL2 value is :");
  printList(pl2);
  int max_Element1 = getMaxRepeatedElementFromList(pl2, m);
  int max_count1 = getMaxRepeatedValueFromList(pl2, m);
  print("PHASE 2 : Max Element: $max_Element1 Max Count: $max_count1");

  ///[Phase 3]
  List<int> final_list = [];
  for (int i = 1; i <= max_count; i++) {
    final_list.add(max_Element);
  }
  for (int i = 1; i <= max_count1; i++) {
    final_list.add(max_Element1);
  }

//SHUFFLING THE LIST
  final_list.shuffle();
  printList(final_list);
  int random_ind = _random.nextInt(final_list.length);
  int FINALELEMENT = final_list[random_ind];
  print("INDEX IS ${random_ind} FINAL ELEMENT: $FINALELEMENT");
  return FINALELEMENT;
}

int getMaxRepeatedElementFromList(List<int> lt, List<int> list) {
  // var m = new Map<int, int>();
  SplayTreeMap m = new SplayTreeMap<int, int>();
  for (int i = 0; i < lt.length; i++) {
    //  m.addEntries({lt[i]: 0});
    m[lt[i]] = 0;
  }
  for (int i = 0; i < lt.length; i++) {
    //  m.addEntries({lt[i]: 0});
    m[lt[i]]++;
  }
  int max_repeated_element = 0;
  m.forEach((k, v) => print('${k}: ${v}'));
  m.forEach((k, v) {
    if (v > max_repeated_element) {
      max_repeated_element = v;
    }
  });
  // print("last element is is ${m[list[list.length-1]]}");
  if (m[list[list.length - 1]] != null) {
    if (m[list[list.length - 1]] == getMaxRepeatedValueFromList(lt, list)) {
      return list[list.length - 1];
    }
  }

  var key =
      m.keys.firstWhere((k) => m[k] == max_repeated_element, orElse: () => -1);

  return key;
}

int getMaxRepeatedValueFromList(List<int> lt, List<int> list) {
  // var m = new Map<int, int>();
  SplayTreeMap m = new SplayTreeMap<int, int>();
  for (int i = 0; i < lt.length; i++) {
    //  m.addEntries({lt[i]: 0});
    m[lt[i]] = 0;
  }
  for (int i = 0; i < lt.length; i++) {
    //  m.addEntries({lt[i]: 0});
    m[lt[i]]++;
  }
  int max_repeated_element = 0;
  // m.forEach((k,v) => print('${k}: ${v}'));
  m.forEach((k, v) {
    if (v > max_repeated_element) {
      max_repeated_element = v;
    }
  });

  return max_repeated_element;
}

bool canFitElements(int end_ind, int noOfElements) {
  if (end_ind + 1 < noOfElements) return false;

  if (end_ind + 1 == noOfElements) {
    return true;
  } else if (end_ind + 1 > noOfElements) {
    return true;
  }
  return false;
}

int getNoFromPercentage(int perc, int total) {
  return ((perc * total) / 100).toInt();
}

printList(var l) {
  for (int i = 0; i < l.length; i++) {
//       print("${l[i]} ");
    stdout.write('${l[i]} ');
  }
  print("\n");
}
