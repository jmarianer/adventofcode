use std::fs::File;
use std::io::{self, BufRead, BufReader};
use regex::Regex;

pub fn day2() -> io::Result<()> {
    let file = File::open("input2")?;
    let reader = BufReader::new(file);
    let lines = reader.lines();

    let re = Regex::new(r"^(\d+)-(\d+) (.): (.*)").unwrap();
    println!("{}", lines.filter(|line| {
        let line = line.as_ref().unwrap();
        let captures = re.captures(&line).unwrap();
        let min: usize = captures.get(1).unwrap().as_str().parse().unwrap();
        let max: usize = captures.get(2).unwrap().as_str().parse().unwrap();
        let letter = captures.get(3).unwrap().as_str().chars().nth(0).unwrap();

        let count = captures.get(4).unwrap().as_str().char_indices().filter(|(_, l)| *l == letter).count();
        min <= count && count <= max
    }).count());

    let file = File::open("input2")?;
    let reader = BufReader::new(file);
    let lines = reader.lines();
    println!("{}", lines.filter(|line| {
        let line = line.as_ref().unwrap();
        let captures = re.captures(&line).unwrap();
        let first: usize = captures.get(1).unwrap().as_str().parse().unwrap();
        let second: usize = captures.get(2).unwrap().as_str().parse().unwrap();
        let letter = captures.get(3).unwrap().as_str().chars().nth(0).unwrap();

        let passwd = captures.get(4).unwrap().as_str();
        let first_char = passwd.chars().nth(first - 1).unwrap();
        let second_char = passwd.chars().nth(second - 1).unwrap();

        (first_char == letter || second_char == letter) && first_char != second_char
    }).count());
    Ok(())
}
