///|
pub fn part1(input : String) -> Int64 {
  let parsed = parse(input)
  count_op_candidates(parsed)
}

///|
pub fn part2(input : String) -> Int64 {
  let parsed = parse(input)
  count_op_candidates(parsed, with_concat=true)
}

///|
fn parse(input : String) -> @immut/list.T[(Int64, @immut/list.T[Int64])] {
  let parsed = @parsem.parse(parser(), input)
  parsed._.unwrap().0
}

///|
fn parser() -> @parsem.Parser[@immut/list.T[(Int64, @immut/list.T[Int64])]] {
  @parsem.sep_by1(
    @parsem.sequence(
      @parsem.digits().precede(@parsem.string(": ")),
      @parsem.sep_by1(@parsem.digits(), @parsem.char(' ')),
    ),
    @parsem.char('\n'),
  )
}

///|
enum Op {
  Add
  Mul
  Concat
} derive(Show, Eq)

///|
fn count_op_candidates(
  parsed : @immut/list.T[(Int64, @immut/list.T[Int64])],
  with_concat~ : Bool = false
) -> Int64 {
  parsed.fold(init=0, fn(acc, line) {
    let (expected, numbers) = line
    let operators : Array[Array[Op]] = get_operators(
      numbers.length(),
      with_concat~,
    )
    if count_valid_operators_by_line(expected, numbers, operators) > 0 {
      acc + expected
    } else {
      acc
    }
  })
}

///|
fn get_operators(
  numbers_length : Int,
  with_concat~ : Bool = false
) -> Array[Array[Op]] {
  let mut result = [[]]
  (0)
  .until(numbers_length - 1)
  .each(fn(_) {
    let rslt = []
    result.each(fn(ops) {
      rslt.push(ops.copy()..push(Add))
      rslt.push(ops.copy()..push(Mul))
      if with_concat {
        rslt.push(ops.copy()..push(Concat))
      }
    })
    result = rslt
  })
  result
}

///|
fn count_valid_operators_by_line(
  expected : Int64,
  numbers : @immut/list.T[Int64],
  operators : Array[Array[Op]]
) -> Int {
  operators.fold(init=0, fn(valid_count, ops) {
    let head = numbers.head().unwrap()
    let numbers_array = numbers.tail().to_array()
    let result = (0)
      .until(ops.length())
      .fold(init=head, fn(acc, index) {
        let op = ops[index]
        let number = numbers_array[index]
        match op {
          Add => acc + number
          Mul => acc * number
          Concat => to_int64("\{acc}\{number}")
        }
      })
    if result == expected {
      valid_count + 1
    } else {
      valid_count
    }
  })
}

///|
fn to_int64(string : String) -> Int64 {
  @strconv.parse?(string).unwrap()
}
