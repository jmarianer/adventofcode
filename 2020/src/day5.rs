use std::fs::File;
use std::io::{self, BufRead, BufReader};

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
    }).collect::<Vec<_>>();
    println!("{}", ids.iter().max().unwrap());

    Ok(())
}
