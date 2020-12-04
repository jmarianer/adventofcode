use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead, BufReader};
use regex::Regex;

pub fn day4() -> io::Result<()> {
    let file = File::open("input4")?;
    let reader = BufReader::new(file);
    let lines_orig = reader.lines().collect::<Vec<_>>();

    let lines = lines_orig.iter().map(|l| l.as_ref().unwrap().to_owned()).collect::<Vec<_>>();

    let batches = lines.split(|line| line.is_empty());
    let single_lines = batches.map(|b| " ".to_owned() + &b.join(" "));

    let required : HashSet<_> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"].iter().cloned().collect();

    let re = Regex::new(r" (...):([^ ])").unwrap();
    //dbg!(single_lines.map(|l| re.captures(&l)).collect::<Vec<_>>());
    println!("{}", single_lines.filter(|l| {
        let elts = re.captures_iter(&l).map(|c| c.get(1).unwrap().as_str()).collect::<HashSet<_>>();
        required.is_subset(&elts)
    }).count());

    Ok(())
}
