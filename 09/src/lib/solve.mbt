///|
pub fn part1(input : String) -> Int64 {
  let blocks = make_blocks(input)
  sort_blocks(blocks)
  calc_checksum(blocks)
}

///|
pub fn part2(input : String) -> Int64 {
  let blocks = make_blocks(input)
  sort_blocks2(blocks)
  calc_checksum(blocks)
}

///|
fn make_blocks(input : String) -> Array[String] {
  let blocks : Array[String] = []
  let mut is_blank = false
  let mut block_id = 0
  input
  .iter()
  .filter_map(fn(c : Char) -> Int? { @strconv.parse?("\{c}").to_option() })
  .each(fn(i) {
    if is_blank {
      blocks.append(Array::make(i, "."))
    } else {
      blocks.append(Array::make(i, "\{block_id}"))
      block_id += 1
    }
    is_blank = not(is_blank)
  })
  blocks
}

///|
fn sort_blocks(blocks : Array[String]) -> Unit {
  let mut first_cursor = 0
  let mut last_cursor = blocks.length() - 1
  while first_cursor < last_cursor {
    if blocks[first_cursor] == "." {
      if blocks[last_cursor] != "." {
        blocks.swap(first_cursor, last_cursor)
        first_cursor += 1
        last_cursor -= 1
      } else {
        last_cursor -= 1
      }
    } else {
      first_cursor += 1
    }
  }
}

///|
fn calc_checksum(blocks : Array[String]) -> Int64 {
  let mut result : Int64 = 0
  blocks.eachi(fn(index : Int, content : String) {
    if content != "." {
      let id : Int64 = @strconv.parse?(content).unwrap()
      result += id * index.to_int64()
    }
  })
  result
}

///|
fn sort_blocks2(blocks : Array[String]) -> Unit {
  let mut last_cursor = blocks.length() - 1
  while last_cursor > 0 {
    if blocks[last_cursor] == "." {
      last_cursor -= 1
      continue
    }
    let id = blocks[last_cursor]
    let mut start_chunk_cursor = last_cursor
    while start_chunk_cursor >= 0 && blocks[start_chunk_cursor] == id {
      start_chunk_cursor -= 1
    }
    start_chunk_cursor += 1
    let mut start_free_cursor = 0
    let mut end_free_cursor = start_free_cursor
    let mut found = false
    while start_free_cursor < start_chunk_cursor {
      while start_free_cursor < start_chunk_cursor &&
            blocks[start_free_cursor] != "." {
        start_free_cursor += 1
      }
      if blocks[start_free_cursor] != "." {
        break
      }
      end_free_cursor = start_free_cursor
      while end_free_cursor <= start_chunk_cursor &&
            blocks[end_free_cursor] == "." {
        end_free_cursor += 1
      }
      if end_free_cursor - start_free_cursor <
        last_cursor - start_chunk_cursor + 1 {
        start_free_cursor = end_free_cursor
        continue
      }
      found = true
      break
    }
    if not(found) || start_free_cursor >= start_chunk_cursor {
      last_cursor = start_chunk_cursor - 1
      continue
    }
    (0)
    .until(last_cursor - start_chunk_cursor + 1)
    .each(fn(i) { blocks.swap(start_free_cursor + i, start_chunk_cursor + i) })
    last_cursor = start_chunk_cursor - 1
  }
}
