///|
pub fn aoc2024_02(input : String) -> Int {
  input.split("\n").filter(safe).count()
}

///|
fn safe(line : String) -> Bool {
  let numbers : @immut/list.T[Int] = @immut/list.from_array(
    line.split(" ").map(fn(n) { @strconv.parse?(n).unwrap() }).collect(),
  )
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
