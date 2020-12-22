use std::collections::{HashMap, HashSet};
use std::fs::File;
use std::io::{BufRead, BufReader};
use num_bigint::BigUint;
use num_traits::One;
use regex::Regex;

fn ticket(line : String) -> Vec<u32> {
    line
        .split(',')
        .map(|n| n.parse::<u32>().unwrap())
        .collect::<Vec<_>>()
}

pub fn day16() {
    let file = File::open("input16").unwrap();
    let mut rules : HashMap<String, HashSet<u32>> = HashMap::new();
    let re = Regex::new("^(.*): (.*)-(.*) or (.*)-(.*)$").unwrap();
    let mut lines = BufReader::new(file).lines();
    
    loop {
        let line = lines.next().unwrap().unwrap();
        if line == "" {
            break;
        }

        let captures = re.captures(&line).unwrap();
        let rule_name = captures.get(1).unwrap().as_str();
        let a1 = captures.get(2).unwrap().as_str().parse::<u32>().unwrap();
        let b1 = captures.get(3).unwrap().as_str().parse::<u32>().unwrap();
        let a2 = captures.get(4).unwrap().as_str().parse::<u32>().unwrap();
        let b2 = captures.get(5).unwrap().as_str().parse::<u32>().unwrap();
        rules.insert(rule_name.to_string(), (a1..b1+1).chain(a2..b2+1).collect());
    }

    lines.next();
    let your_ticket = ticket(lines.next().unwrap().unwrap());

    lines.next();
    lines.next();
    let other_tickets = lines
        .map(|wrapped_line| {
            ticket(wrapped_line.unwrap())
        }).collect::<Vec<_>>();

    // Part 1
    let all_valid_nums = rules
        .values()
        .fold(HashSet::new(), |a, b| a.union(b).cloned().collect());
    let all_ticket_items = other_tickets
        .iter()
        .fold(vec![], |a, b| a.iter().copied().chain(b.iter().copied()).collect());
    let bad = all_ticket_items
        .iter()
        .filter(|i|
                !all_valid_nums.contains(i))
        .sum::<u32>();
    println!("{}", bad);


    // Part 2
    let other_valid_tickets = other_tickets
        .iter()
        .filter(|ticket| {
            ticket
                .iter()
                .all(|i| all_valid_nums.contains(i))
        }).collect::<Vec<_>>();
    let item_count = other_valid_tickets[0].len();

    let mut item_placement = rules
        .iter()
        .map(|(k, v)| {
            // dbg!(k, v.iter().sorted().collect::<Vec<_>>());
            let pos = (0..item_count)
                .filter(|i| {
                    other_valid_tickets
                        .iter()
                        .all(|ticket|
                             v.contains(&ticket[*i]))
                });
            (k, pos.collect::<HashSet<_>>())
        })
        .collect::<HashMap<_, _>>();

    loop {
        let single_values = item_placement
            .values()
            .filter(|s| s.len() == 1)
            .fold(HashSet::new(), |a, b| a.union(b).cloned().collect());

        item_placement
            .values_mut()
            .for_each(|v| {
                if v.len() > 1 {
                    v.retain(|i| !single_values.contains(i))
                }
            });

        if single_values.len() == item_count {
            break;
        }
    }


    let departures = item_placement
        .iter()
        .filter(|(k, _)| k.starts_with("departure"))
        .map(|(_, v)| v.iter().next().unwrap());


    let mut product : BigUint = One::one();
    departures.for_each(|i| product *= your_ticket[*i]);
    println!("{}", product);
}
