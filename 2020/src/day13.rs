use num_bigint::BigInt;
use num_traits::{Zero, One};
use std::fs::File;
use std::io::{BufRead, BufReader};

fn bezout(a: &BigInt, b: &BigInt) -> (BigInt, BigInt) {
    // https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    let mut r_prev : BigInt = a.clone();
    let mut s_prev : BigInt = One::one();
    let mut t_prev : BigInt = Zero::zero();

    let mut r = b.clone();
    let mut s = Zero::zero();
    let mut t = One::one();

    while r != Zero::zero() {
        let q = &r_prev / &r;

        let r_next = r_prev - &q * &r;
        let s_next = s_prev - &q * &s;
        let t_next = t_prev - &q * &t;

        r_prev = r;
        s_prev = s;
        t_prev = t;

        r = r_next;
        s = s_next;
        t = t_next;
    }
    (s_prev, t_prev)
}

pub fn day13() {
    let file = File::open("input13").unwrap();
    let reader = BufReader::new(file);
    let mut lines = reader.lines();

    let time : u32 = lines.next().unwrap().unwrap().parse().unwrap();

    let orig_bus_times : Vec<String> = lines.next()
        .unwrap().unwrap()
        .split(',')
        .map(|s| s.to_string())
        .collect();

    let bus_times : Vec<BigInt> = orig_bus_times.iter()
        .filter(|t| *t != "x")
        .map(|t| t.parse().unwrap())
        .collect();

    let earliest_time = bus_times.iter()
        .map(|t| {
            if time % t ==  Zero::zero() {
                (t, Zero::zero())
            } else {
                (t, t - (time % t))
            }
        });
    let part1 = {
        let (a, b) = earliest_time.min_by(|(_, b1), (_, b2)| b1.cmp(b2)).unwrap();
        a * b
    };
    println!("{}", part1);


    let remainders = orig_bus_times.iter()
        .enumerate()
        .filter(|(_, b)| *b != "x")
        .map(|(a, b)| (a, b.parse().unwrap()))
        .collect::<Vec<(usize, BigInt)>>();
    let product = bus_times.iter().product::<BigInt>();
    // https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Existence_(direct_construction)
    let mut part2 : BigInt = remainders.iter()
        .map(|(a, n)| {
            let N = &product / n;
            let (M, m) = bezout(&N, n);
            -(a * M * N)
        })
        .sum();
    part2 %= &product;
    if part2 < Zero::zero() {
        part2 = product + part2;
    }
    println!("{}", part2);
}
