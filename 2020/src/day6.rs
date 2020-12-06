use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

fn calculate_sum<F>(lines: &Vec<String>, func: F) -> usize
    where F: Fn(&HashSet<char>, &HashSet<char>) -> HashSet<char>
{
    lines
        .split(|line| line.is_empty())
        .map(|g| {
            // Boo mutability
            // But this is IMO the best way around the lack of fold_first
            let mut all_sets = g.iter().map(|line| line.chars().collect::<HashSet<_>>());
            let first = all_sets.nth(0).unwrap();

            all_sets
                 .fold(first, |a, b| func(&a, &b))
                 .len()
        })
        .sum()
}

pub fn day6() -> io::Result<()> {
    let file = File::open("input6")?;
    let reader = BufReader::new(file);
    let lines = reader.lines().map(|l| l.as_ref().unwrap().to_owned()).collect::<Vec<_>>();

    println!("{}", calculate_sum(&lines, |a, b| a.union(&b).cloned().collect()));
    println!("{}", calculate_sum(&lines, |a, b| a.intersection(&b).cloned().collect()));

    Ok(())
}
