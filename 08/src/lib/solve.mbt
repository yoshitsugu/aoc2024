///|
pub fn part1(input : String) -> Int {
  let matrix : Array[Array[Char]] = to_matrix(input)
  let positions : @hashmap.T[Char, Array[(Int, Int)]] = symbol_positions(matrix)
  let antinodes : @hashset.T[(Int, Int)] = antinode_positions(
    positions,
    matrix[0].length(),
    matrix.length(),
  )
  // print_antinodes(matrix, antinodes)
  antinodes.size()
}

///|
pub fn part2(input : String) -> Int {
  let matrix : Array[Array[Char]] = to_matrix(input)
  let positions : @hashmap.T[Char, Array[(Int, Int)]] = symbol_positions(matrix)
  let antinodes : @hashset.T[(Int, Int)] = antinode_positions(
    positions,
    matrix[0].length(),
    matrix.length(),
    repeat=true,
  )
  // print_antinodes(matrix, antinodes)
  antinodes.size()
}

///|
fn to_matrix(input : String) -> Array[Array[Char]] {
  input.split("\n").map(fn(line) { line.to_array() }).collect()
}

///|
fn symbol_positions(
  matrix : Array[Array[Char]]
) -> @hashmap.T[Char, Array[(Int, Int)]] {
  let result : @hashmap.T[Char, Array[(Int, Int)]] = @hashmap.new()
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      let symbol = matrix[j][i]
      if symbol == '.' {
        continue
      }
      match result[symbol] {
        Some(ps) => ps.push((i, j))
        None => result[symbol] = [(i, j)]
      }
    }
  }
  result
}

///|
fn antinode_positions(
  position_counts : @hashmap.T[Char, Array[(Int, Int)]],
  width : Int,
  height : Int,
  repeat~ : Bool = false
) -> @hashset.T[(Int, Int)] {
  let result = @hashset.new()
  position_counts.each(fn(_, ps) {
    combination(ps).each(fn(pair) {
      let (p1, p2) = pair
      result.add(p1)
      result.add(p2)
      let diff = (p2.0 - p1.0, p2.1 - p1.1)
      let mut antinode1_x = p2.0 + diff.0
      let mut antinode1_y = p2.1 + diff.1
      if in_bound((antinode1_x, antinode1_y), width, height) {
        result.add((antinode1_x, antinode1_y))
        if repeat {
          antinode1_x += diff.0
          antinode1_y += diff.1
          while in_bound((antinode1_x, antinode1_y), width, height) {
            result.add((antinode1_x, antinode1_y))
            antinode1_x += diff.0
            antinode1_y += diff.1
          }
        }
      }
      let mut antinode2_x = p1.0 - diff.0
      let mut antinode2_y = p1.1 - diff.1
      if in_bound((antinode2_x, antinode2_y), width, height) {
        result.add((antinode2_x, antinode2_y))
        if repeat {
          antinode2_x -= diff.0
          antinode2_y -= diff.1
          while in_bound((antinode2_x, antinode2_y), width, height) {
            result.add((antinode2_x, antinode2_y))
            antinode2_x -= diff.0
            antinode2_y -= diff.1
          }
        }
      }
    })
  })
  result
}

///|
fn combination[T](array : Array[T]) -> Array[(T, T)] {
  let result : Array[(T, T)] = []
  for i in 0..<array.length() {
    for j in (i + 1)..<array.length() {
      result.push((array[i], array[j]))
    }
  }
  result
}

///|
fn in_bound(point : (Int, Int), width : Int, height : Int) -> Bool {
  let (x, y) = point
  0 <= x && x < width && 0 <= y && y < height
}

///|
fn print_antinodes(
  matrix : Array[Array[Char]],
  antinodes : @hashset.T[(Int, Int)]
) -> Unit {
  matrix.eachi(fn(j, line) {
    let mut line_string = ""
    line.eachi(fn(i, char) {
      if antinodes.contains((i, j)) {
        line_string += "#"
      } else {
        line_string += char.to_string()
      }
    })
    println(line_string)
  })
}
