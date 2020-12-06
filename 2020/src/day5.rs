use std::fs::File;
use std::io::{self, BufRead, BufReader};
use itertools::Itertools;

fn find_first_skipped(ids: Vec<usize>) -> usize {
    let mut iter = ids.iter();
    let mut prev = iter.next().unwrap();
    for i in iter {
        if *i == prev + 1 {
            prev = i;
        } else {
            return i - 1;
        }
    }
    0
}

pub fn day5() -> io::Result<()> {
    let file = File::open("input5")?;
    let reader = BufReader::new(file);
    let lines_orig = reader.lines().collect::<Vec<_>>();

    let ids = lines_orig.iter().map(|l| {
        let mut ans=0;
        for c in l.as_ref().unwrap().chars() {
            ans *= 2;
            if c == 'B' || c == 'R' {
                ans += 1;
            }
        }
        ans
    }).sorted().collect::<Vec<_>>();
    println!("{}", ids.iter().max().unwrap());
    println!("{}", find_first_skipped(ids));

    Ok(())
}
