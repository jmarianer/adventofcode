#[macro_use]
extern crate lazy_static;

use std::io::{self};
mod day4;

fn main() -> io::Result<()> {
    day4::day4()?;
    Ok(())
}
