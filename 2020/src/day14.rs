use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use regex::Regex;

fn get_addrs(addr : String, mask : &String) -> Vec<String> {
    let mut addrs = vec!["".to_string()];

    for (a, m) in addr.chars().zip(mask.chars()) {
        if m == '0' {
            addrs = addrs.iter().map(|s| s.to_owned() + &a.to_string()).collect();
        } else if m == '1' {
            addrs = addrs.iter().map(|s| s.to_owned() + "1").collect();
        } else {
            addrs = addrs.iter().map(|s| s.to_owned() + "0")
                .chain(addrs.iter().map(|s| s.to_owned() + "1")).collect();
        }
    }
    addrs
}

pub fn day14() {
    let file = File::open("input14").unwrap();
    let lines = BufReader::new(file).lines().collect::<Vec<_>>();

    let re = Regex::new("^(mem\\[(.*)\\]|mask) = (.*)$").unwrap();
    let mut mask : String = "".to_string();

    // Part 1
    let mut mem : HashMap<u64, u64> = HashMap::new();
    for wrapped_line in lines.iter() {
        let line = wrapped_line.as_ref().unwrap();
        let captures = re.captures(line).unwrap();
        if captures.get(1).unwrap().as_str() == "mask" {
            mask = captures.get(3).unwrap().as_str().to_string();
        } else {
            let addr : u64 = captures.get(2).unwrap().as_str().parse().unwrap();
            let val : u64  = captures.get(3).unwrap().as_str().parse().unwrap();
            let val_string = format!("{:036b}", val);
            let new_val_string = mask.chars().zip(val_string.chars())
                .map(|(m, v)|
                     if m == 'X' { v } else { m }
                 ).collect::<String>();
            let new_val = u64::from_str_radix(&new_val_string, 2).unwrap();
            mem.insert(addr, new_val);
        }
    }
    let part1 = mem.iter().map(|(_, v)| v).sum::<u64>();
    println!("{}", part1);

    // Part 2
    let mut mem : HashMap<u64, u64> = HashMap::new();
    for wrapped_line in lines.iter() {
        let line = wrapped_line.as_ref().unwrap();
        let captures = re.captures(line).unwrap();
        if captures.get(1).unwrap().as_str() == "mask" {
            mask = captures.get(3).unwrap().as_str().to_string();
        } else {
            let addr : u64 = captures.get(2).unwrap().as_str().parse().unwrap();
            let val : u64  = captures.get(3).unwrap().as_str().parse().unwrap();
            let addr_string = format!("{:036b}", addr);
            for addr in get_addrs(addr_string, &mask) {
                mem.insert(u64::from_str_radix(&addr, 2).unwrap(), val);
            }
        }
    }
    let part2 = mem.iter().map(|(_, v)| v).sum::<u64>();
    println!("{}", part2);
}
