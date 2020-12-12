use std::fs::File;
use std::io::{BufRead, BufReader};

fn rt(dx : &mut i32, dy : &mut i32, degrees : i32) {
    for _ in 0..degrees/90 {
        let tmp = *dy;
        *dy = -*dx;
        *dx = tmp;
    }
}

pub fn day12() {
    let file = File::open("input12").unwrap();
    let reader = BufReader::new(file);
    let instructions = reader
        .lines()
        .map (|wrapped| {
            let l = wrapped.unwrap();
            (l.chars().nth(0).unwrap(),
             l[1..l.len()].parse().unwrap())
        })
        .collect::<Vec<(_, i32)>>();

    let (mut dx, mut dy) = (1, 0);  // East
    let (mut x,  mut y)  = (0, 0);
    for (action, arg) in &instructions {
        match action {
            'F' => { x += dx * arg; y += dy * arg; },
            'N' => { y += arg; },
            'E' => { x += arg; },
            'S' => { y -= arg; },
            'W' => { x -= arg; },
            'R' => rt(&mut dx, &mut dy, *arg),
            'L' => rt(&mut dx, &mut dy, 360 - *arg),
            _   => ()
        }
    }
    println!("{}", x.abs() + y.abs());

    let (mut dx, mut dy) = (10, 1);
    let (mut x,  mut y)  = (0, 0);
    for (action, arg) in &instructions {
        match action {
            'F' => { x += dx * arg; y += dy * arg; },
            'N' => { dy += arg; },
            'E' => { dx += arg; },
            'S' => { dy -= arg; },
            'W' => { dx -= arg; },
            'R' => rt(&mut dx, &mut dy, *arg),
            'L' => rt(&mut dx, &mut dy, 360 - arg),
            _   => ()
        }
    }
    println!("{}", x.abs() + y.abs());
}
