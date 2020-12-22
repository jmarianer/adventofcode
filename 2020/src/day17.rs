use std::collections::{HashMap, HashSet};
use std::convert::TryInto;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn iterate3(pos : HashSet<(i32, i32, i32)>) -> HashSet<(i32, i32, i32)> {
    let mut adjacent : HashMap<(i32, i32, i32), (u32, bool)> = HashMap::new();

    let mut update = |x, y, z| {
        let (ref mut adj, _) = adjacent.entry((x, y, z)).or_insert((0, false));
        *adj += 1;
    };

    pos.iter().for_each(|(x, y, z)| {
        update(*x-1, *y-1, *z-1);
        update(*x-1, *y-1, *z  );
        update(*x-1, *y-1, *z+1);
        update(*x-1, *y  , *z-1);
        update(*x-1, *y  , *z  );
        update(*x-1, *y  , *z+1);
        update(*x-1, *y+1, *z-1);
        update(*x-1, *y+1, *z  );
        update(*x-1, *y+1, *z+1);
        update(*x  , *y-1, *z-1);
        update(*x  , *y-1, *z  );
        update(*x  , *y-1, *z+1);
        update(*x  , *y  , *z-1);
        // update(*x  , *y  , *z  );
        update(*x  , *y  , *z+1);
        update(*x  , *y+1, *z-1);
        update(*x  , *y+1, *z  );
        update(*x  , *y+1, *z+1);
        update(*x+1, *y-1, *z-1);
        update(*x+1, *y-1, *z  );
        update(*x+1, *y-1, *z+1);
        update(*x+1, *y  , *z-1);
        update(*x+1, *y  , *z  );
        update(*x+1, *y  , *z+1);
        update(*x+1, *y+1, *z-1);
        update(*x+1, *y+1, *z  );
        update(*x+1, *y+1, *z+1);
    });

    pos.iter().for_each(|(x, y, z)| {
        let (_, ref mut active) = adjacent.entry((*x, *y, *z)).or_insert((0, false));
        *active = true;
    });

    adjacent
        .iter()
        .filter(|(_, (adj, active))|
                *adj == 3 || (*active && *adj == 2))
        .map(|(pos, _)| *pos)
        .collect()
}

fn iterate4(pos : HashSet<(i32, i32, i32, i32)>) -> HashSet<(i32, i32, i32, i32)> {
    let mut adjacent : HashMap<(i32, i32, i32, i32), (u32, bool)> = HashMap::new();

    let mut update = |x, y, z, w| {
        let (ref mut adj, _) = adjacent.entry((x, y, z, w)).or_insert((0, false));
        *adj += 1;
    };

    pos.iter().for_each(|(x, y, z, w)| {
        update(*x-1, *y-1, *z-1, *w-1);
        update(*x-1, *y-1, *z  , *w-1);
        update(*x-1, *y-1, *z+1, *w-1);
        update(*x-1, *y  , *z-1, *w-1);
        update(*x-1, *y  , *z  , *w-1);
        update(*x-1, *y  , *z+1, *w-1);
        update(*x-1, *y+1, *z-1, *w-1);
        update(*x-1, *y+1, *z  , *w-1);
        update(*x-1, *y+1, *z+1, *w-1);
        update(*x  , *y-1, *z-1, *w-1);
        update(*x  , *y-1, *z  , *w-1);
        update(*x  , *y-1, *z+1, *w-1);
        update(*x  , *y  , *z-1, *w-1);
        update(*x  , *y  , *z  , *w-1);
        update(*x  , *y  , *z+1, *w-1);
        update(*x  , *y+1, *z-1, *w-1);
        update(*x  , *y+1, *z  , *w-1);
        update(*x  , *y+1, *z+1, *w-1);
        update(*x+1, *y-1, *z-1, *w-1);
        update(*x+1, *y-1, *z  , *w-1);
        update(*x+1, *y-1, *z+1, *w-1);
        update(*x+1, *y  , *z-1, *w-1);
        update(*x+1, *y  , *z  , *w-1);
        update(*x+1, *y  , *z+1, *w-1);
        update(*x+1, *y+1, *z-1, *w-1);
        update(*x+1, *y+1, *z  , *w-1);
        update(*x+1, *y+1, *z+1, *w-1);

        update(*x-1, *y-1, *z-1, *w  );
        update(*x-1, *y-1, *z  , *w  );
        update(*x-1, *y-1, *z+1, *w  );
        update(*x-1, *y  , *z-1, *w  );
        update(*x-1, *y  , *z  , *w  );
        update(*x-1, *y  , *z+1, *w  );
        update(*x-1, *y+1, *z-1, *w  );
        update(*x-1, *y+1, *z  , *w  );
        update(*x-1, *y+1, *z+1, *w  );
        update(*x  , *y-1, *z-1, *w  );
        update(*x  , *y-1, *z  , *w  );
        update(*x  , *y-1, *z+1, *w  );
        update(*x  , *y  , *z-1, *w  );
        //update(*x  , *y  , *z  , *w  );
        update(*x  , *y  , *z+1, *w  );
        update(*x  , *y+1, *z-1, *w  );
        update(*x  , *y+1, *z  , *w  );
        update(*x  , *y+1, *z+1, *w  );
        update(*x+1, *y-1, *z-1, *w  );
        update(*x+1, *y-1, *z  , *w  );
        update(*x+1, *y-1, *z+1, *w  );
        update(*x+1, *y  , *z-1, *w  );
        update(*x+1, *y  , *z  , *w  );
        update(*x+1, *y  , *z+1, *w  );
        update(*x+1, *y+1, *z-1, *w  );
        update(*x+1, *y+1, *z  , *w  );
        update(*x+1, *y+1, *z+1, *w  );

        update(*x-1, *y-1, *z-1, *w+1);
        update(*x-1, *y-1, *z  , *w+1);
        update(*x-1, *y-1, *z+1, *w+1);
        update(*x-1, *y  , *z-1, *w+1);
        update(*x-1, *y  , *z  , *w+1);
        update(*x-1, *y  , *z+1, *w+1);
        update(*x-1, *y+1, *z-1, *w+1);
        update(*x-1, *y+1, *z  , *w+1);
        update(*x-1, *y+1, *z+1, *w+1);
        update(*x  , *y-1, *z-1, *w+1);
        update(*x  , *y-1, *z  , *w+1);
        update(*x  , *y-1, *z+1, *w+1);
        update(*x  , *y  , *z-1, *w+1);
        update(*x  , *y  , *z  , *w+1);
        update(*x  , *y  , *z+1, *w+1);
        update(*x  , *y+1, *z-1, *w+1);
        update(*x  , *y+1, *z  , *w+1);
        update(*x  , *y+1, *z+1, *w+1);
        update(*x+1, *y-1, *z-1, *w+1);
        update(*x+1, *y-1, *z  , *w+1);
        update(*x+1, *y-1, *z+1, *w+1);
        update(*x+1, *y  , *z-1, *w+1);
        update(*x+1, *y  , *z  , *w+1);
        update(*x+1, *y  , *z+1, *w+1);
        update(*x+1, *y+1, *z-1, *w+1);
        update(*x+1, *y+1, *z  , *w+1);
        update(*x+1, *y+1, *z+1, *w+1);
    });

    pos.iter().for_each(|(x, y, z, w)| {
        let (_, ref mut active) = adjacent.entry((*x, *y, *z, *w)).or_insert((0, false));
        *active = true;
    });

    adjacent
        .iter()
        .filter(|(_, (adj, active))|
                *adj == 3 || (*active && *adj == 2))
        .map(|(pos, _)| *pos)
        .collect()
}

pub fn day17() {
    let file = File::open("input17").unwrap();
    let reader = BufReader::new(file);
    let mut pos3 : HashSet<(i32, i32, i32)> = HashSet::new();
    let mut pos4 : HashSet<(i32, i32, i32, i32)> = HashSet::new();

    reader
        .lines()
        .enumerate()
        .for_each(|(y, wrapped_line)| {
            wrapped_line
                .unwrap()
                .chars()
                .enumerate()
                .for_each(|(x, ch)| {
                    if ch == '#' {
                        pos3.insert((x.try_into().unwrap(), y.try_into().unwrap(), 0));
                        pos4.insert((x.try_into().unwrap(), y.try_into().unwrap(), 0, 0));
                    }
                });
        });

    // Part 1
    pos3 = iterate3(pos3);
    pos3 = iterate3(pos3);
    pos3 = iterate3(pos3);
    pos3 = iterate3(pos3);
    pos3 = iterate3(pos3);
    pos3 = iterate3(pos3);
    dbg!(pos3.len());

    // Part 2
    pos4 = iterate4(pos4);
    pos4 = iterate4(pos4);
    pos4 = iterate4(pos4);
    pos4 = iterate4(pos4);
    pos4 = iterate4(pos4);
    pos4 = iterate4(pos4);
    dbg!(pos4.len());
}
