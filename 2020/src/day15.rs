use std::collections::HashMap;

pub fn day15() {
    let input = [1,12,0,20,8,16];

    let mut last_time_spoken : HashMap<usize, usize> = HashMap::new();
    let mut last_spoken = 0;
    for i in 0..30000000 {
        let next_to_speak = 
            if i < input.len() {
                input[i] 
            } else if last_time_spoken.contains_key(&last_spoken) {
                i - last_time_spoken[&last_spoken]
            } else {
                0
            };
        if i > 0 {
            last_time_spoken.insert(last_spoken, i);
        }
        last_spoken = next_to_speak;
    }
    println!("{}", last_spoken);
}
