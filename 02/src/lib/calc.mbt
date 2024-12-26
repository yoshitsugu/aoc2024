///|
pub fn part1(input : String) -> Int {
  input.split("\n").filter(safe).count()
}

///|
pub fn part2(input : String) -> Int {
  input.split("\n").filter(safe_with_single_tolerance).count()
}

///|
fn safe(line : String) -> Bool {
  let numbers : @immut/list.T[Int] = @immut/list.from_array(
    line.split(" ").map(fn(n) { @strconv.parse?(n).unwrap() }).collect(),
  )
  safe_numbers(numbers)
}

///|
fn safe_with_single_tolerance(line : String) -> Bool {
  let numbers : @immut/list.T[Int] = @immut/list.from_array(
    line.split(" ").map(fn(n) { @strconv.parse?(n).unwrap() }).collect(),
  )
  if safe_numbers(numbers) {
    true
  } else {
    for i in 0..<numbers.length() {
      if safe_numbers(numbers.take(i).concat(numbers.drop(i + 1))) {
        return true
      }
    }
    false
  }
}

///|
fn safe_numbers(numbers : @immut/list.T[Int]) -> Bool {
  let tuples = numbers.take(numbers.length() - 1).zip(numbers.tail()).unwrap()
  tuples.all(in_safe_range) ||
  tuples.rev().map(fn(tuple) { (tuple.1, tuple.0) }).all(in_safe_range)
}

///|
fn in_safe_range(ab : (Int, Int)) -> Bool {
  let (a, b) = ab
  let diff = b - a
  0 < diff && diff < 4
}
