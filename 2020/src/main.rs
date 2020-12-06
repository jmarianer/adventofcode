//#[macro_use]
extern crate lazy_static;

use std::io::{self};
mod day6;

fn main() -> io::Result<()> {
    day6::day6()?;
    Ok(())
}
