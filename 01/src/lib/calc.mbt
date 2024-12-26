///|
pub fn part1(input : String) -> Int {
  let (lefts, rights) = input
    .split("\n")
    .fold(init=(@immut/list.from_array([]), @immut/list.from_array([])), fn(
      acc,
      line
    ) {
      let { left, right } = parse(line).unwrap()
      (acc.0.add(left), acc.1.add(right))
    })
  let sorted_lefts = lefts.sort()
  let sorted_rights = rights.sort()
  sorted_lefts
  .zip(sorted_rights)
  .unwrap()
  .fold(init=0, fn(acc : Int, lr : (Int, Int)) -> Int {
    let (left, right) = lr
    acc + (left - right).abs()
  })
}

///|
pub fn part2(input : String) -> Int {
  let (lefts, rights) = input
    .split("\n")
    .fold(init=(@immut/list.from_array([]), @immut/list.from_array([])), fn(
      acc,
      line
    ) {
      let { left, right } = parse(line).unwrap()
      (acc.0.add(left), acc.1.add(right))
    })
  let count_map : @hashmap.T[Int, Int] = rights.fold(init=@hashmap.new(), fn(
    m,
    i
  ) {
    match m[i] {
      Some(n) => m.set(i, n + 1)
      None => m.set(i, 1)
    }
    m
  })
  lefts.fold(init=0, fn(acc, left_number) {
    match count_map[left_number] {
      Some(n) => acc + left_number * n
      None => acc
    }
  })
}

///|
struct Line {
  left : Int
  right : Int
}

///|
fn parse(line : String) -> Result[Line, String] {
  match line.split("   ").collect() {
    [left, right] =>
      match (@strconv.parse?(left), @strconv.parse?(right)) {
        (Ok(l), Ok(r)) => Ok(Line::{ left: l, right: r })
        _ => Err("Cannot Parse line \{line}")
      }
    _ => Err("Cannot Parse line \{line}")
  }
}
