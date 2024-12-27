///|
pub fn part1(input : String) -> Int {
  let (rules, tests) = parse(input)
  let valid_tests = tests.filter(fn(t) { is_valid(rules, t) })
  valid_tests.fold(init=0, fn(acc, valid_test) {
    acc + valid_test[valid_test.length() / 2]
  })
}

///|
pub fn part2(input : String) -> Int {
  10
}

///|
fn to_i(string : String) -> Int {
  @strconv.parse?(string).unwrap()
}

///|
fn parse(input : String) -> (Array[(Int, Int)], Array[Array[Int]]) {
  match input.split("\n\n").collect() {
    [rules_input, tests_input] =>
      return (
        rules_input
        .split("\n")
        .map(fn(rule_input) {
          match rule_input.split("|").collect() {
            [l, r] => (to_i(l), to_i(r))
            _ => (0, 0)
          }
        })
        .collect(),
        tests_input
        .split("\n")
        .map(fn(test_input) {
          test_input.split(",").map(fn(n) { to_i(n) }).collect()
        })
        .collect(),
      )
    _ => {
      println("Cannot parse")
      ([], [])
    }
  }
}

///|
fn is_valid(rules : Array[(Int, Int)], test_case : Array[Int]) -> Bool {
  if test_case.length() == 0 {
    return true
  }
  let (head, tail) = test_case.split_at(1)
  tail.fold(init=true, fn(result, t) {
    result && not(rules.contains((t, head[0])))
  }) &&
  is_valid(rules, tail)
}
