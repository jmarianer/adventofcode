use std::fs::File;
use std::io::{BufRead, BufReader};

/*
fn dbg_seats(seats : &Vec<Vec<char>>) {
    for row in seats {
        println!("{}", row.iter().collect::<String>());
    }
    println!("");
}
*/

fn sees_neighbor(seats : &Vec<Vec<char>>, i : usize, j : usize,
                  di : &i32, dj : &i32) -> bool {
    let ii = (i as i32) + di;
    let jj = (j as i32) + dj;
    if ii >= 0 && ii < (seats.len() as i32) && jj >= 0 && jj < (seats[0].len() as i32) {
        seats[ii as usize][jj as usize] == '#'
    } else {
        false
    }
}

fn sees_any(seats : &Vec<Vec<char>>, mut i : usize, mut j : usize,
                  di : &i32, dj : &i32) -> bool {
    loop {
        let ii = (i as i32) + di;
        let jj = (j as i32) + dj;
        if ii >= 0 && ii < (seats.len() as i32) && jj >= 0 && jj < (seats[0].len() as i32) {
            i = ii as usize;
            j = jj as usize;
            if seats[i][j] == '#' {
                return true;
            }
            if seats[i][j] == 'L' {
                return false;
            }
        } else {
            return false;
        }
    }
}

fn seated_neighbors(seats : &Vec<Vec<char>>, i : usize, j : usize, part2 : bool) -> usize {
    let directions = vec![
        (-1, -1),
        (-1,  0),
        (-1,  1),

        ( 0, -1),
        ( 0,  1),

        ( 1, -1),
        ( 1,  0),
        ( 1,  1),
    ];

    let neighbors = directions.iter().filter(|(di, dj)| {
        if part2 {
            sees_any(seats, i, j, di, dj)
        } else {
            sees_neighbor(seats, i, j, di, dj)
        }
    });
    neighbors.count()
}

fn iterate(seats : &Vec<Vec<char>>, part2 : bool) -> Vec<Vec<char>> {
    let mut ret : Vec<Vec<char>> = Vec::new();
    let tolerance = if part2 { 5 } else { 4 };
    for i in 0..seats.len() {
        let mut new_row : Vec<char> = Vec::new();
        for j in 0..seats[0].len() {
            new_row.push(
                match seats[i][j] {
                    'L' => if seated_neighbors(seats, i, j, part2) == 0 { '#' } else { 'L' },
                    '#' => if seated_neighbors(seats, i, j, part2) >= tolerance { 'L' } else { '#' },
                    _ => seats[i][j]
                }
            );
        }
        ret.push(new_row);
    }
    ret
}

fn iterate_and_count(original_layout : &Vec<Vec<char>>, part2 : bool) -> usize {
    let mut seats = original_layout.clone();

    loop {
        let new_seats = iterate(&seats, part2);
        if seats == new_seats {
            return seats.iter()
                .map(|vec| {
                    vec.iter()
                        .filter(|c| **c == '#')
                        .count()
                })
                .sum();
        }
        seats = new_seats;
    }
}

pub fn day11() {
    let file = File::open("input11").unwrap();
    let reader = BufReader::new(file);
    let seats = reader
        .lines()
        .map (|l| l.unwrap().chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    println!("{}", iterate_and_count(&seats, false));
    println!("{}", iterate_and_count(&seats, true));
}
