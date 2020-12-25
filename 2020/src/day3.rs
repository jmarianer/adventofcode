use std::fs::File;
use std::io::{Result, BufRead, BufReader};

//fn check_slope_1<I>(lines: I, right: usize) -> usize where I : Iterator<Item = io::Result<String>> {
fn check_slope_1(lines: &Vec<&Result<String>>, right: usize) -> usize {
    lines.iter().enumerate().filter(|(i, line)| {
        let line = line.as_ref().unwrap();
        let ch   = line.chars().nth((i * right) % line.len()).unwrap();
        ch == '#'
    }).count()
}

pub fn day3() {
    let file = File::open("input3").unwrap();
    let reader = BufReader::new(file);
    let lines_orig = reader.lines().collect::<Vec<_>>();

    let lines = lines_orig.iter().step_by(1).collect::<Vec<_>>();
    println!("{}", check_slope_1(&lines, 3));

    let every_other_line = lines_orig.iter().step_by(2).collect::<Vec<_>>();
    println!("{}",
             check_slope_1(&lines, 1) *
             check_slope_1(&lines, 3) *
             check_slope_1(&lines, 5) *
             check_slope_1(&lines, 7) *
             check_slope_1(&every_other_line, 1));
}
