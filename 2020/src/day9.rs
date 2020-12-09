use std::fs::File;
use std::io::{BufRead, BufReader};

fn check(slice: &[u64], num: u64) -> bool {
    for i in 0..slice.len() {
        for j in i+1..slice.len() {
            if num == slice[i] + slice[j] {
                return true;
            }
        }
    }
    return false;
}

pub fn day9() {
    let file = File::open("input9").unwrap();
    let reader = BufReader::new(file);
    let numbers = reader
        .lines()
        .map (|l| l.unwrap().parse().unwrap())
        .collect::<Vec<u64>>();

    for i in 25..numbers.len() {
        if !check(&numbers[i-25..i], numbers[i]) {
            println!("{}", numbers[i]);
            break;
        }
    }
    for i in 1..numbers.len() {
        for j in i+2..numbers.len() {
            let slice = &numbers[i..j];
            if slice.iter().sum::<u64>() == 23278925 {
                println!("{}", slice.iter().min().unwrap() + slice.iter().max().unwrap());
            }
        }
    }
}
