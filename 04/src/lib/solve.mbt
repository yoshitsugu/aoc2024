///|
pub fn part1(input : String) -> Int {
  count_xmas(input_to_matrix(input))
}

///|
pub fn part2(input : String) -> Int {
  count_x_mas(input_to_matrix(input))
}

///|
fn input_to_matrix(input : String) -> Array[Array[Char]] {
  input.split("\n").map(fn(line) { line.to_array() }).collect()
}

///|
fn count_xmas(matrix : Array[Array[Char]]) -> Int {
  let mut sum = 0
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      if matrix[j][i] != 'X' {
        continue
      }
      [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)].each(fn(
          dxdy
        ) {
          let (dx, dy) = dxdy
          let mut xmas = true
          ['M', 'A', 'S'].eachi(fn(diff, c) {
            match
              matrix
              .get(j + dy * (diff + 1))
              .bind(fn(l) { l.get(i + dx * (diff + 1)) }) {
              Some(tc) => if c != tc { xmas = false }
              None => xmas = false
            }
          })
          if xmas {
            sum += 1
          }
        },
      )
    }
  }
  sum
}

///|
fn count_x_mas(matrix : Array[Array[Char]]) -> Int {
  let mut sum = 0
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      if matrix[j][i] != 'A' {
        continue
      }
      let right_bottom_cell = get_relative_cell(matrix, i, j, 1, 1)
      let right_top_cell = get_relative_cell(matrix, i, j, 1, -1)
      let left_bottom_cell = get_relative_cell(matrix, i, j, -1, 1)
      let left_top_cell = get_relative_cell(matrix, i, j, -1, -1)
      let has_empty = [
        right_bottom_cell, right_top_cell, left_bottom_cell, left_top_cell,
      ].fold(init=false, fn(acc, cell) { acc || cell.is_empty() })
      if has_empty {
        continue
      }
      let [rb, rt, lb, lt] = [
        right_bottom_cell, right_top_cell, left_bottom_cell, left_top_cell,
      ].map(unwrap)
      let d1 = @hashset.from_array([rb, lt])
      let d2 = @hashset.from_array([rt, lb])
      if d1.contains('M') &&
        d1.contains('S') &&
        d2.contains('M') &&
        d2.contains('S') {
        sum += 1
      }
    }
  }
  sum
}

///|
fn get_relative_cell(
  matrix : Array[Array[Char]],
  i : Int,
  j : Int,
  dx : Int,
  dy : Int
) -> Char? {
  matrix.get(j + dy).bind(fn(l) { l.get(i + dx) })
}
