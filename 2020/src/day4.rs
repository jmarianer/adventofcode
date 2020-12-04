use std::collections::HashMap;
use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead, BufReader};
use regex::Regex;

fn is_valid(passport: &HashMap<std::string::String, std::string::String>) -> bool {
    let byr: u32 = passport["byr"].parse().unwrap();
    let iyr: u32 = passport["iyr"].parse().unwrap();
    let eyr: u32 = passport["eyr"].parse().unwrap();
    let hgt = &passport["hgt"];
    let hcl = &passport["hcl"];
    let ecl = &passport["ecl"];
    let pid = &passport["pid"];

    let hgt_valid = if hgt.ends_with("cm") {
        let hgt_cm : u32 = hgt.strip_suffix("cm").unwrap().parse().unwrap();
        hgt_cm >= 150 && hgt_cm <= 193
    } else if hgt.ends_with("in") {
        let hgt_in : u32 = hgt.strip_suffix("in").unwrap().parse().unwrap();
        hgt_in >= 59 && hgt_in <= 76
    } else {
        false
    };

    lazy_static! {
        static ref HCL_RE : Regex = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
        static ref ECL_SET : HashSet<std::string::String> = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].iter().map(|s| String::from(*s)).collect();
        static ref PID_RE : Regex = Regex::new(r"^[0-9]{9}$").unwrap();
    }

    byr >= 1920 && byr <= 2002 && iyr >= 2010 && iyr <= 2020 && eyr >= 2020 && eyr <= 2030
    && HCL_RE.is_match(hcl) && ECL_SET.contains(ecl) && PID_RE.is_match(pid) && hgt_valid
}

pub fn day4() -> io::Result<()> {
    let file = File::open("input4")?;
    let reader = BufReader::new(file);
    let lines_orig = reader.lines().collect::<Vec<_>>();

    let lines = lines_orig.iter().map(|l| l.as_ref().unwrap().to_owned()).collect::<Vec<_>>();

    let re = Regex::new(r" (...):([^ ]*)").unwrap();
    let passports = lines
        .split(|line| line.is_empty())
        .map(|batch| {
            let single_line = " ".to_owned() + &batch.join(" ");
            re.captures_iter(&single_line)
                .map(|c| (c.get(1).unwrap().as_str().to_owned(),
                          c.get(2).unwrap().as_str().to_owned()))
                .collect::<HashMap<_, _>>()
        }).collect::<Vec<_>>();

    let required : HashSet<std::string::String> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"].iter().map(|s| String::from(*s)).collect();
    let has_required = passports.iter().filter(|passport| {
        let elts = passport.keys().cloned().collect::<HashSet<_>>();
        required.is_subset(&elts)
    }).collect::<Vec<_>>();
    println!("{}", has_required.len());

    
    println!("{}", has_required.iter().filter(|passport| {
        is_valid(*passport)
    }).count());

    Ok(())
}
