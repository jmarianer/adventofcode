require 'set'

track = $stdin.readlines(chomp: true).map &:chars

startpos = endpos = nil
(0...track.length).each do |i|
  (0...track[0].length).each do |j|
    if track[i][j] == 'S'
      startpos = [i, j]
    end
    if track[i][j] == 'E'
      endpos = [i, j]
    end
  end
end

def bfs(track, startpos, endpos)
  dirs = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
  ]
  visited = {}
  i, j = startpos
  queue = [[i, j, 0, 0]]
  until queue.empty?
    i, j, dir, len = queue.shift
    if i > track.length or j > track[i].length or i < 0 or j < 0 or visited.key?([i, j, dir]) or track[i][j] == '#'
      next
    end
    if ['S', 'E', '.'].include? track[i][j]
      track[i][j] = len
    end
    visited[[i, j, dir]] = len
    di, dj = dirs[dir]
    queue.push(
      [i + di, j + dj, dir, len + 1],
      [i, j, (dir + 1) % 4, len + 1000],
      [i, j, (dir - 1) % 4, len + 1000],
    )

    queue.sort_by! { |x| x[3] }
  end

  i, j = endpos
  puts track[i][j]
  backwards = []
  [0, 1, 2, 3].each { |dir|
    if visited[[i, j, dir]] == track[i][j]
      backwards.push([i, j, dir, track[i][j]])
    end
  }

  backwards.each { |xxx|
    i, j, dir, len = xxx
    di, dj = dirs[dir]
    snort = [
      [i - di, j - dj, dir, len - 1],
      [i, j, (dir + 1) % 4, len - 1000],
      [i, j, (dir - 1) % 4, len - 1000],
    ]
    snort.each { |yyy|
      ii, jj, ddir, llen = yyy
      if visited[[ii, jj, ddir]] == llen
        backwards.push [ii, jj, ddir, llen]
      end
    }
  }

  puts backwards.map { |xxx|
    i, j, dir, len = xxx
    [i, j]
  }.to_set.size
end

bfs(track, startpos, endpos)