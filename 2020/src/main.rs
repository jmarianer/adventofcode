//#[macro_use]
extern crate lazy_static;

use std::io::{self};
mod day5;

fn main() -> io::Result<()> {
    day5::day5()?;
    Ok(())
}
