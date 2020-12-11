use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};
use itertools::Itertools;
use num_bigint::BigUint;
use num_traits::{Zero, One};

pub fn day10() {
    let file = File::open("input10").unwrap();
    let reader = BufReader::new(file);
    let jolts = reader
        .lines()
        .map (|l| l.unwrap().parse().unwrap())
        .sorted()
        .collect::<Vec<usize>>();

    let mut diff1 = 0;
    let mut diff3 = 0;
    for i in 1..jolts.len() {
        match jolts[i] - jolts[i-1] {
            1 => diff1 += 1,
            3 => diff3 += 1,
            _ => ()
        }
    }
    println!("{}", (diff1 + 1) * (diff3 + 1));

    let jolts = jolts.iter().collect::<HashSet<_>>();
    let target = jolts.iter().max().unwrap();
    let mut pos : Vec<BigUint> = Vec::new();
    pos.push(One::one());

    let zero = Zero::zero();

    for i in 1..*target+1 {
        if jolts.contains(&i) {
            let new_val = {
                let diff1 = &pos[i-1];
                let diff2 = if i >= 2 { &pos[i-2] } else { &zero };
                let diff3 = if i >= 3 { &pos[i-3] } else { &zero };
                diff1+diff2+diff3
            };
            pos.push(new_val);
        } else {
            pos.push(Zero::zero());
        }
    }
    println!("{}", pos[**target])
}
