///|
pub fn part1(input : String) -> Int {
  let matrix = input.split("\n").map(fn(line) { line.to_array() }).collect()
  let initial_position = search_initial_position(matrix)
  let routes : @immut/hashset.T[(Int, Int)] = route(
    matrix,
    initial_position,
    UP,
    @immut/hashset.from_array([initial_position]),
  )
  routes.size()
}

///|
pub fn part2(input : String) -> Int {
  let matrix = input.split("\n").map(fn(line) { line.to_array() }).collect()
  let initial_position = search_initial_position(matrix)
  loop_obstacle_count(matrix, initial_position)
}

///|
enum Origin {
  UP
  DOWN
  LEFT
  RIGHT
} derive(Show, Eq, Hash)

///|
fn search_initial_position(matrix : Array[Array[Char]]) -> (Int, Int) {
  let mut position = (-1, -1)
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      if matrix[j][i] == '^' {
        position = (i, j)
        break
      }
    }
    if position != (-1, -1) {
      break
    }
  }
  position
}

///|
fn route(
  matrix : Array[Array[Char]],
  position : (Int, Int),
  origin : Origin,
  routes : @immut/hashset.T[(Int, Int)]
) -> @immut/hashset.T[(Int, Int)] {
  match move_route(matrix, position, origin) {
    None => routes
    Some((x, y, o)) => route(matrix, (x, y), o, routes.add((x, y)))
  }
}

///|
fn move_route(
  matrix : Array[Array[Char]],
  position : (Int, Int),
  origin : Origin
) -> (Int, Int, Origin)? {
  let diff = origin_to_diff(origin)
  let new_position = (position.0 + diff.0, position.1 + diff.1)
  if new_position.0 < 0 ||
    matrix[0].length() <= new_position.0 ||
    new_position.1 < 0 ||
    matrix.length() <= new_position.1 {
    return None
  }
  if matrix[new_position.1][new_position.0] == '#' {
    return Some((position.0, position.1, turn_right(origin)))
  }
  Some((new_position.0, new_position.1, origin))
}

///|
fn origin_to_diff(origin : Origin) -> (Int, Int) {
  match origin {
    UP => (0, -1)
    RIGHT => (1, 0)
    LEFT => (-1, 0)
    DOWN => (0, 1)
  }
}

///|
fn turn_right(origin : Origin) -> Origin {
  match origin {
    UP => RIGHT
    RIGHT => DOWN
    LEFT => UP
    DOWN => LEFT
  }
}

///|
fn loop_obstacle_count(
  matrix : Array[Array[Char]],
  initial_position : (Int, Int)
) -> Int {
  let mut count = 0
  for j in 0..<matrix.length() {
    for i in 0..<matrix[0].length() {
      if has_loop(
          matrix,
          (i, j),
          initial_position,
          UP,
          @immut/hashset.from_array([
            (initial_position.0, initial_position.1, UP),
          ]),
        ) {
        count += 1
      }
    }
  }
  count
}

///|
fn has_loop(
  matrix : Array[Array[Char]],
  obstacle : (Int, Int),
  current : (Int, Int),
  origin : Origin,
  position_history : @immut/hashset.T[(Int, Int, Origin)]
) -> Bool {
  if matrix[obstacle.1][obstacle.0] == '#' {
    return false
  }
  match move_route_with_obstacle(matrix, current, origin, obstacle) {
    Some((x, y, o) as new_position) =>
      if position_history.contains(new_position) {
        true
      } else {
        has_loop(
          matrix,
          obstacle,
          (x, y),
          o,
          position_history.add(new_position),
        )
      }
    None => false
  }
}

///|
fn move_route_with_obstacle(
  matrix : Array[Array[Char]],
  position : (Int, Int),
  origin : Origin,
  obstacle : (Int, Int)
) -> (Int, Int, Origin)? {
  let diff = origin_to_diff(origin)
  let new_position = (position.0 + diff.0, position.1 + diff.1)
  if new_position.0 < 0 ||
    matrix[0].length() <= new_position.0 ||
    new_position.1 < 0 ||
    matrix.length() <= new_position.1 {
    return None
  }
  if matrix[new_position.1][new_position.0] == '#' || new_position == obstacle {
    return Some((position.0, position.1, turn_right(origin)))
  }
  Some((new_position.0, new_position.1, origin))
}
