fn display(order : &Vec<(usize, usize)>) {
    let mut idx = 0;
    loop {
        print!("{} ", order[idx].0);
        idx = order[idx].1;
        if idx == 0 {
            break;
        }
    }
    println!("");
}

pub fn day23() {
    // Real input
    let mut order = vec![3, 1, 8, 9, 4, 6, 5, 7, 2];

    // Naive version using vectors and way too many vector copies
    (0..100).for_each(|_| {
        let cur = order.remove(0);
        let mut dest_cup = cur;
        let picked_up = order.splice(0..3, vec![]).collect::<Vec<_>>();
        loop {
            dest_cup -= 1;
            if dest_cup == 0 {
                dest_cup = 9;
            }
            if !picked_up.contains(&dest_cup) {
                break;
            }
        }
        let pos = order.iter().position(|x| *x == dest_cup).unwrap() + 1;
        order.splice(pos..pos, picked_up);
        order.push(cur);
    });
    loop {
        let cur = order.remove(0);
        if cur == 1 {
            break;
        }
        order.push(cur);
    }
    println!("{}", order.iter().map(|n| n.to_string()).collect::<Vec<_>>().join(""));

    // Part II
    let mut order : Vec<(usize, usize)> = Vec::new();
    for i in &[3, 1, 8, 9, 4, 6, 5, 7, 2] {
        order.push((*i, order.len() + 1));
    }
    for i in 10..1000001 {
        order.push((i, order.len() + 1));
    }
    let last_idx = order.len() - 1;
    order[last_idx].1 = 0;

    let last_cup = order.len();

    let mut cur_cup_idx = 0;
    (0..10000000).for_each(|_| {
        let cur = order[cur_cup_idx];
        let mut dest_cup = cur.0;

        let first_picked_up_idx = cur.1;
        let mut picked_up : Vec<usize> = Vec::new();
        let next_picked_up = order[first_picked_up_idx];
        picked_up.push(next_picked_up.0);
        let next_picked_up_idx = next_picked_up.1;
        let next_picked_up = order[next_picked_up_idx];
        picked_up.push(next_picked_up.0);
        let last_picked_up_idx = next_picked_up.1;
        let last_picked_up = order[last_picked_up_idx];
        picked_up.push(last_picked_up.0);

        loop {
            dest_cup -= 1;
            if dest_cup == 0 {
                dest_cup = last_cup;
            }
            if !picked_up.contains(&dest_cup) {
                break;
            }
        }

        let dest_cup_position = 
            if dest_cup > 100 {
                dest_cup - 1
            } else {
                order.iter().position(|(cup, _next)| *cup == dest_cup).unwrap()
            };
        let dest_cup = &mut order[dest_cup_position];

        let after_dest_idx = dest_cup.1;
        dest_cup.1 = first_picked_up_idx;
        let after_picked_up_idx = last_picked_up.1;
        order[last_picked_up_idx].1 = after_dest_idx;
        order[cur_cup_idx].1 = after_picked_up_idx;

        cur_cup_idx = after_picked_up_idx;
    });
    let cup_1_pos = order.iter().position(|(cup, _next)| *cup == 1).unwrap();
    let next = order[cup_1_pos].1;
    let cup1 = order[next].0;
    let next = order[next].1;
    let cup2 = order[next].0;

    println!("{}", cup1 as u64 * cup2 as u64);
}
