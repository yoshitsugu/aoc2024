///|
pub fn part1(input : String) -> Int64 {
  let matrix = to_matrix(input)
  let cache = @hashmap.new()
  calc_paths(matrix, cache)
  count_routes(matrix, cache)
}

///|
pub fn part2(input : String) -> Int64 {
  2
}

///|
fn to_matrix(input : String) -> Array[Array[Int]] {
  input.split("\n").map(fn(line) { line.to_array().map(to_i) }).collect()
}

///|
fn to_i(c : Char) -> Int {
  @strconv.parse?("\{c}").unwrap()
}

///|
fn calc_paths(
  matrix : Array[Array[Int]],
  cache : @hashmap.T[(Int, Int), Array[Array[(Int, Int)]]]
) -> Unit {
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      let value = matrix[j][i]
      if value == 9 {
        paths(matrix, i, j, cache)
      }
    }
  }
}

///|
fn paths(
  matrix : Array[Array[Int]],
  i : Int,
  j : Int,
  cache : @hashmap.T[(Int, Int), Array[Array[(Int, Int)]]]
) -> Unit {
  let value = matrix[j][i]
  let current_paths : Array[Array[(Int, Int)]] = []
  if not(cache.get((i, j)).is_empty()) {
    return
  }
  if value == 0 {
    cache.set((i, j), [[(i, j)]])
    return
  }
  [(1, 0), (-1, 0), (0, 1), (0, -1)].each(fn(xy) {
    let (x, y) = xy
    let focus_point = (i + x, j + y)
    if in_bounds(matrix, focus_point) {
      let focus_value = matrix[focus_point.1][focus_point.0]
      if focus_value + 1 == value {
        if cache[focus_point].is_empty() {
          paths(matrix, focus_point.0, focus_point.1, cache)
        }
        cache[focus_point]
        .unwrap()
        .each(fn(paths) {
          let new_paths = paths.copy()
          new_paths.push((i, j))
          current_paths.push(new_paths)
        })
      }
    }
  })
  cache.set((i, j), current_paths..sort()..dedup())
}

///|
fn count_routes(
  matrix : Array[Array[Int]],
  cache : @hashmap.T[(Int, Int), Array[Array[(Int, Int)]]]
) -> Int64 {
  let mut sum : Int64 = 0
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      let value = matrix[j][i]
      if value == 9 {
        let ten_node_paths = cache[(i, j)]
          .unwrap()
          .filter(fn(paths) { paths.length() == 10 })
        let start_points = ten_node_paths.map(fn(pt) { pt[0] })
        sum += start_points..sort()..dedup().length().to_int64()
      }
    }
  }
  sum
}

///|
fn in_bounds(matrix : Array[Array[Int]], focus_point : (Int, Int)) -> Bool {
  let (x, y) = focus_point
  0 <= x && x < matrix[0].length() && 0 <= y && y < matrix.length()
}
