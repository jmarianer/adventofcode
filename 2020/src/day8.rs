use std::fs::File;
use std::io::{BufRead, BufReader};
use std::collections::HashSet;

fn execute(program: &Vec<(String, i32)>) -> (bool, i32) {
    let mut acc = 0;
    let mut pc = 0;
    let mut executed = HashSet::<usize>::new();

    while pc < program.len() {
        if !executed.insert(pc) {
            return (false, acc);
        }
        let (inst, arg) = &program[pc];
        match inst.as_str() {
            "nop" => pc += 1,
            "acc" => {
                pc += 1;
                acc += arg
            },
            "jmp" => {
                if arg > &0 {
                    pc += arg.wrapping_abs() as usize;
                } else {
                    pc -= arg.wrapping_abs() as usize;
                }
            },
            _ => { dbg!("foo"); }
        }
    }
    (true, acc)
}

pub fn day8() {
    let file = File::open("input8").unwrap();
    let reader = BufReader::new(file);
    let mut program : Vec<(String, i32)> = reader
        .lines()
        .map(|wrapped_line| {
            let line = wrapped_line.unwrap();
            let mut splits = line.split(' ');
            (splits.next().unwrap().to_string(), splits.next().unwrap().parse().unwrap())
        })
        .collect::<Vec<_>>();

    println!("{}", execute(&program).1);

    for i in 0..program.len() {
        match program[i].0.as_str() {
            "nop" => {
                program[i].0 = "jmp".to_string();
                let (term, acc) = execute(&program);
                if term {
                    println!("{}", acc);
                    return;
                }
                program[i].0 = "nop".to_string();
            },
            "jmp" => {
                program[i].0 = "nop".to_string();
                let (term, acc) = execute(&program);
                if term {
                    println!("{}", acc);
                    return;
                }
                program[i].0 = "jmp".to_string();
            },
            _ => ()
        }
    }
}
