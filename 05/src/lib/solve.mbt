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
  let (rules, tests) = parse(input)
  let corrected_tests = tests
    .filter(fn(t) { not(is_valid(rules, t)) })
    .map(fn(t) { correct(rules, t) })
  corrected_tests.fold(init=0, fn(acc, corrected_test) {
    acc + corrected_test[corrected_test.length() / 2]
  })
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
    _ => ([], [])
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

///|
fn correct(rules : Array[(Int, Int)], test_case : Array[Int]) -> Array[Int] {
  if test_case.length() <= 1 {
    return test_case
  }
  let test_case_indices = @immut/list.from_array(
    (0).until(test_case.length()).to_array(),
  )
  match
    search_correct_target(
      rules,
      test_case,
      test_case_indices.head().unwrap(),
      test_case_indices.tail(),
      test_case_indices.tail(),
    ) {
    Some((i, j)) => {
      test_case.swap(i, j)
      correct(rules, test_case) |> ignore
    }
    None => ignore(0)
  }
  test_case
}

///|
fn search_correct_target(
  rules : Array[(Int, Int)],
  test_case : Array[Int],
  target_index : Int,
  target_indices : @immut/list.T[Int],
  memorized_indices : @immut/list.T[Int]
) -> (Int, Int)? {
  if target_indices.length() == 0 {
    if memorized_indices.length() == 0 {
      return None
    } else {
      return search_correct_target(
        rules,
        test_case,
        memorized_indices.head().unwrap(),
        memorized_indices.tail(),
        memorized_indices.tail(),
      )
    }
  }
  let t = target_indices.head().unwrap()
  if rules.contains((test_case[t], test_case[target_index])) {
    Some((t, target_index))
  } else {
    search_correct_target(
      rules,
      test_case,
      target_index,
      target_indices.tail(),
      memorized_indices,
    )
  }
}
