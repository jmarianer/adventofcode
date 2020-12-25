use std::collections::HashMap;
use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn iterate_hex(pos : HashSet<(i32, i32)>) -> HashSet<(i32, i32)> {
    let mut adjacent : HashMap<(i32, i32), (u32, bool)> = HashMap::new();

    let mut update = |x, y| {
        let (ref mut adj, _) = adjacent.entry((x, y)).or_insert((0, false));
        *adj += 1;
    };

    pos.iter().for_each(|(x, y)| {
        update(*x  , *y-1);  // NW
        update(*x+1, *y-1);  // NE
        update(*x-1, *y  );  // W
        update(*x+1, *y  );  // E
        update(*x-1, *y+1);  // SW
        update(*x  , *y+1);  // SE
    });

    pos.iter().for_each(|(x, y)| {
        let (_, ref mut active) = adjacent.entry((*x, *y)).or_insert((0, false));
        *active = true;
    });

    adjacent
        .iter()
        .filter(|(_, (adj, active))|
                *adj == 2 || (*active && *adj == 1))
        .map(|(pos, _)| *pos)
        .collect()
}

fn get_coords(s : &str) -> (i32, i32) {
    let mut x = 0;
    let mut y = 0;
    let mut between = false;

    s.chars().for_each(|c| {
        match c {
            'e' => {
                x += 1;
                between = false;
            },
            'w' => {
                if !between {
                    x -= 1;
                }
                between = false;
            },
            'n' => {
                y -= 1;
                between = true;
            },
            's' => {
                y += 1;
                x -= 1;
                between = true;
            },
            _ => ()
        }
    });

    (x, y)
}

pub fn day24() {
    let file = File::open("input24").unwrap();
    let lines = BufReader::new(file)
        .lines()
        .map(|l| l.as_ref().unwrap().to_owned())
        .collect::<Vec<_>>();

    let mut flipped : HashSet<(i32, i32)> = HashSet::new();
    lines.iter().for_each(|l| {
        let (x, y) = get_coords(l);
        if flipped.contains(&(x, y)) {
            flipped.remove(&(x, y));
        } else {
            flipped.insert((x, y));
        }
    });
    println!("{}", &flipped.len());

    for _ in 0..101 {
        flipped = iterate_hex(flipped);
    }
    println!("{}", &flipped.len());
}
