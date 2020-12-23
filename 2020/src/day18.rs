use std::fs::File;
use std::io::{BufRead, BufReader};
use std::iter::Peekable;
use num_bigint::BigUint;

fn maybe_paren(iter : &mut impl Iterator<Item = char>) -> BigUint {
    let c = iter.next().unwrap();
    if c == '(' {
        let mut result = maybe_paren(iter);

        loop {
            match iter.next().unwrap() {
                '+' => {
                    result += maybe_paren(iter);
                },
                '*' => {
                    result *= maybe_paren(iter);
                },
                ')' => {
                    return result;
                },
                _ => (),
            }
        }
    }

    BigUint::from_slice(&[c.to_digit(10).unwrap()])
}

fn eval(expr : &str) -> BigUint {
    let paren_expr = "(".to_owned() + expr + ")";
    let mut iter = paren_expr.chars().filter(|c| *c != ' ');
    maybe_paren(&mut iter)
}

fn addition_only(iter : &mut Peekable<impl Iterator<Item = char>>) -> BigUint {
    let mut result = paren_or_number(iter);
    loop {
        match *iter.peek().unwrap() {
            '+' => {
                iter.next();
                result += paren_or_number(iter);
            }
            _ => {
                return result;
            }
        }
    }
}

fn paren_or_number(iter : &mut Peekable<impl Iterator<Item = char>>) -> BigUint {
    let c = iter.next().unwrap();
    if c == '(' {
        return addition_and_mult(iter);
    }

    BigUint::from_slice(&[c.to_digit(10).unwrap()])
}

fn addition_and_mult(iter : &mut Peekable<impl Iterator<Item = char>>) -> BigUint {
    let mut result = addition_only(iter);
    loop {
        match iter.next().unwrap() {
            '*' => {
                result *= addition_only(iter);
            },
            ')' => {
                return result;
            }
            _ => (),
        }
    }
}

fn eval2(expr : &str) -> BigUint {
    let paren_expr = "(".to_owned() + expr + ")";
    let mut iter = paren_expr.chars().filter(|c| *c != ' ').peekable();
    paren_or_number(&mut iter)
}

pub fn day18() {
    let file = File::open("input18").unwrap();
    let lines = BufReader::new(file).lines().map(|w| w.unwrap()).collect::<Vec<_>>();
    println!("{}", lines.iter().map(|w| eval(&w)).sum::<BigUint>());
    println!("{}", lines.iter().map(|w| eval2(&w)).sum::<BigUint>());

}
