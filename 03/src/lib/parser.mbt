///|
typealias LString = @immut/list.T[Char]

///|
struct Parser[T] {
  name : String
  parse : (LString) -> ParseResult[T]
}

///|
impl[T] Show for Parser[T] with output(self, logger) {
  logger.write_string("Parser::\{self.name}")
}

///|
pub typealias ParseResult[T] = Result[(T, LString), String]

///|
pub fn Parser::parse[T](parser : Parser[T], input : LString) -> ParseResult[T] {
  (parser.parse)(input)
}

///|
pub fn pstring(expected : String) -> Parser[String] {
  return Parser::{
    name: "pstring(expected: \"\{expected}\")",
    parse: fn(input : LString) -> ParseResult[String] {
      if @string.from_iter(input.take(expected.length()).iter()) == expected {
        Ok((expected, input.drop(expected.length())))
      } else {
        Err("Cannot parse String \"\{expected}\"")
      }
    },
  }
}

test "pstring" {
  inspect!(
    Parser::parse(pstring("test"), @immut/list.from_array("test123".to_array())),
    content="Ok((\"test\", @list.of(['1', '2', '3'])))",
  )
  inspect!(
    Parser::parse(pstring("t"), @immut/list.from_array("test123".to_array())),
    content="Ok((\"t\", @list.of(['e', 's', 't', '1', '2', '3'])))",
  )
}

///|
pub fn pdigits() -> Parser[String] {
  return Parser::{
    name: "pdigits",
    parse: fn(input : LString) -> ParseResult[String] {
      let digits = @string.from_iter(
        input
        .iter()
        .take_while(fn(c : Char) {
          ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(c)
        }),
      )
      if digits.length() > 0 {
        Ok((digits, input.drop(digits.length())))
      } else {
        Err("Cannot parse Int in \{input}")
      }
    },
  }
}

test "pdigits" {
  let parser = pdigits()
  inspect!(
    Parser::parse(parser, @immut/list.from_array("123,456".to_array())),
    content="Ok((\"123\", @list.of([',', '4', '5', '6'])))",
  )
}

///|
pub fn pseq(parsers : Array[Parser[String]]) -> Parser[Array[String]] {
  return Parser::{
    name: "pseq",
    parse: fn(input) {
      let results = []
      let mut error = ""
      let mut parse_target = input
      parsers.each(fn(parser) {
        match (parser.parse)(parse_target) {
          Ok((result, rest)) => {
            results.push(result)
            parse_target = rest
          }
          Err(err) => {
            error = err
            return
          }
        }
      })
      if error.length() > 0 {
        Err(error)
      } else {
        Ok((results, parse_target))
      }
    },
  }
}

test "pseq" {
  let parser = pseq([pdigits(), pstring(","), pdigits()])
  inspect!(
    Parser::parse(parser, @immut/list.from_array("123,456test".to_array())),
    content="Ok(([\"123\", \",\", \"456\"], @list.of(['t', 'e', 's', 't'])))",
  )
}

///|
pub fn pchoice[T](parser_a : Parser[T], parser_b : Parser[T]) -> Parser[T] {
  return Parser::{
    name: "pchoice",
    parse: fn(input : LString) -> ParseResult[T] {
      match (parser_a.parse)(input) {
        Ok(_) as ok_result => ok_result
        Err(_) => (parser_b.parse)(input)
      }
    },
  }
}

test "pchoice" {
  let parser = pchoice(pstring("abc"), pstring("def"))
  inspect!(
    Parser::parse(parser, @immut/list.from_array("def123".to_array())),
    content="Ok((\"def\", @list.of(['1', '2', '3'])))",
  )
  inspect!(
    Parser::parse(parser, @immut/list.from_array("abc333".to_array())),
    content="Ok((\"abc\", @list.of(['3', '3', '3'])))",
  )
}
