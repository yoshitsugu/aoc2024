///|
pub fn part1(input : String) -> Int {
  run(parse_part1(input))
}

///|
pub fn part2(input : String) -> Int {
  run(parse_part2(input))
}

///|
fn run(parsed : Array[Mul]) -> Int {
  parsed.fold(init=0, fn(acc, mul) { acc + mul.left * mul.right })
}

///|
struct Mul {
  left : Int
  right : Int
}

///|
fn parse_part1(input : String) -> Array[Mul] {
  if input.length() == 0 {
    return []
  }
  let rest = @immut/list.from_array(input.to_array())
  parse_mul1([], rest)
}

///|
fn parse_mul1(result : Array[Mul], rest : @immut/list.T[Char]) -> Array[Mul] {
  if rest.length() == 0 {
    return result
  }
  let parsed = Parser::parse(
    pseq([pstring("mul("), pdigits(), pstring(","), pdigits(), pstring(")")]),
    rest,
  )
  match parsed {
    Ok(([_, left, _, right, _], new_rest)) => {
      result.push(Mul::{ left: to_i(left), right: to_i(right) })
      parse_mul1(result, new_rest)
    }
    _ => parse_mul1(result, rest.tail())
  }
}

///|
fn parse_part2(input : String) -> Array[Mul] {
  if input.length() == 0 {
    return []
  }
  let rest = @immut/list.from_array(input.to_array())
  parse_mul2([], rest)
}

///|
fn parse_mul2(result : Array[Mul], rest : @immut/list.T[Char]) -> Array[Mul] {
  if rest.length() == 0 {
    return result
  }
  let parsed = Parser::parse(
    pchoice(
      pseq([pstring("don't()")]),
      pseq([pstring("mul("), pdigits(), pstring(","), pdigits(), pstring(")")]),
    ),
    rest,
  )
  match parsed {
    Ok(([a], new_rest)) =>
      if a == "don't()" {
        parse_do(result, new_rest)
      } else {
        parse_mul2(result, new_rest)
      }
    Ok(([_, left, _, right, _], new_rest)) => {
      result.push(Mul::{ left: to_i(left), right: to_i(right) })
      parse_mul2(result, new_rest)
    }
    _ => parse_mul2(result, rest.tail())
  }
}

///|
fn parse_do(result : Array[Mul], rest : @immut/list.T[Char]) -> Array[Mul] {
  if rest.length() == 0 {
    return result
  }
  match Parser::parse(pstring("do()"), rest) {
    Ok((_, new_rest)) => parse_mul2(result, new_rest)
    _ => parse_do(result, rest.tail())
  }
}

///|
fn to_i(string : String) -> Int {
  @strconv.parse?(string).unwrap()
}
