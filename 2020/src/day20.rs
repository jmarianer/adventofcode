use std::cmp::min;
use std::collections::HashMap;
use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};
use num_bigint::BigUint;
use num_traits::One;

fn chars_to_u32<'a>(cs : impl Iterator<Item = &'a char>) -> u32 {
    let mut i = 0;
    for c in cs {
        i *= 2;
        if *c == '#' {
            i += 1;
        }
    }
    i
}

fn chars_to_min_u32(cs : &Vec<char>) -> u32 {
    let i1 = chars_to_u32(cs.iter());
    let i2 = chars_to_u32(cs.iter().rev());
    min(i1, i2)
}

pub fn day20() {
    let file = File::open("input20").unwrap();
    let lines = BufReader::new(file)
        .lines()
        .map(|l| l.as_ref().unwrap().to_owned())
        .collect::<Vec<_>>();

    let mut tile_edges : HashMap<u32, HashSet<u32>> = HashMap::new();

    for tile in lines.split(|line| line.is_empty()) {
        let tile_number = tile[0][5..9].parse::<u32>().unwrap();

        let top_edge = tile[1].chars().collect();
        let bottom_edge = tile[10].chars().collect();
        let left_edge = tile[1..11].iter().map(|row| row.chars().nth(0).unwrap()).collect();
        let right_edge = tile[1..11].iter().map(|row| row.chars().nth(9).unwrap()).collect();
        [top_edge, bottom_edge, left_edge, right_edge].iter().for_each(|edge| {
            tile_edges.entry(chars_to_min_u32(edge)).or_insert(HashSet::new()).insert(tile_number);
        });
    }

    let mut tile_edge_count : HashMap<u32, u32> = HashMap::new();
    for v in tile_edges.values() {
        if v.len() == 1 {
            *tile_edge_count.entry(*v.iter().next().unwrap()).or_insert(0) += 1;
        }
    }

    let mut part1 : BigUint = One::one();
    for (k, v) in tile_edge_count {
        if v == 2 {
            part1 *= k;
        }
    }
    println!("{}", part1);
}
