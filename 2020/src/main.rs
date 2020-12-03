use std::io::{self};
mod day1;
mod day2;

fn main() -> io::Result<()> {
    day1::day1();
    day2::day2()?;
    Ok(())
}
