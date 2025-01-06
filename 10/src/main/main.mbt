///|
fn main {
  let input = @fs.read_file_to_string?(path="src/main/input.txt").unwrap()
  println(@lib.part1(input))
}
