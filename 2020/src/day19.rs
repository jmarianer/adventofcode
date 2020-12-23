use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use regex::Regex;

fn get_re(rules : &HashMap<u32, String>, rule_no : u32) -> String {
    lazy_static! {
        static ref TERM : Regex = Regex::new("^\"(.*)\"$").unwrap();
    }
    let rule = &rules[&rule_no];
    if TERM.is_match(rule) {
        let captures = TERM.captures(rule).unwrap();
        return captures.get(1).unwrap().as_str().to_string();
    }


    let alter = rule.split(" | ")
        .map(|conc| {
            conc.split(" ")
                .map(|num| {
                    get_re(rules, num.parse::<u32>().unwrap())
                })
                .collect::<Vec<_>>().join("")
        })
        .collect::<Vec<_>>().join("|");
    format!("({})", alter)
}

pub fn day19() {
    let file = File::open("input19").unwrap();
    let mut lines = BufReader::new(file).lines();
    let re = Regex::new("^(.*): (.*)$").unwrap();

    let mut rules : HashMap<u32, String> = HashMap::new();

    loop {
        let line = lines.next().unwrap().unwrap();
        if line == "" {
            break;
        }
        let captures = re.captures(&line).unwrap();
        let num = captures.get(1).unwrap().as_str().parse::<u32>().unwrap();
        let rule = captures.get(2).unwrap().as_str().to_string();
        rules.insert(num, rule);
    }
    let lines = lines.map(|w| w.unwrap()).collect::<Vec<_>>();

    // Part 1:
    let re = Regex::new(&format!("^{}$", get_re(&rules, 0))).unwrap();
    println!("{}", lines.iter().filter(|l| re.is_match(&l)).count());

    // Part 2:
    // 0: 8 11
    // 8: 42 | 42 8
    // 11: 42 31 | 42 11 31
    //
    // In other words, match any number nonzero of 42s and any smaller nonzero number of 31s.
    let re42 = get_re(&rules, 42);
    let re31 = get_re(&rules, 31);
    let res = (2..15).map(|i| {  // The 15 is arbitrary, but I got the fucking star!
        Regex::new(&format!("^({}{{{}}}{}{{1,{}}})$", re42, i, re31, i-1)).unwrap()
    }).collect::<Vec<_>>();
    println!("{}", lines.iter().filter(|l| {
        res.iter().any(|re| re.is_match(l))
    }).count());
}
