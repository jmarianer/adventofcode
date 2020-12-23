use std::collections::HashSet;

fn regular_combat(player1 : &[usize], player2 : &[usize]) -> Vec<usize> {
    let mut player1 = player1.to_vec();
    let mut player2 = player2.to_vec();

    while !player1.is_empty() && !player2.is_empty() {
        let card1 = player1.remove(0);
        let card2 = player2.remove(0);
        if card1 > card2 {
            player1.push(card1);
            player1.push(card2);
        } else {
            player2.push(card2);
            player2.push(card1);
        }
    }

    let mut winner = vec![];
    winner.append(&mut player1);
    winner.append(&mut player2);
    winner
}

fn recursive_combat(player1 : &[usize], player2 : &[usize]) -> (bool, Vec<usize>) {
    let mut seen_configs : HashSet<(Vec<usize>, Vec<usize>)> = HashSet::new();

    let mut player1 = player1.to_vec();
    let mut player2 = player2.to_vec();

    while !player1.is_empty() && !player2.is_empty() {
        if seen_configs.contains(&(player1.clone(), player2.clone())) {
            return (true, vec![]);
        }
        seen_configs.insert((player1.clone(), player2.clone()));

        let card1 = player1.remove(0);
        let card2 = player2.remove(0);

        let winner_is_p1 =
            if player1.len() >= card1 && player2.len() >= card2 {
                let (winner_is_p1, _) = recursive_combat(&player1[0..card1], &player2[0..card2]);
                winner_is_p1
            } else {
                card1 > card2
            };

        if winner_is_p1 {
            player1.push(card1);
            player1.push(card2);
        } else {
            player2.push(card2);
            player2.push(card1);
        }
    }

    if player1.is_empty() {
        (false, player2)
    } else {
        (true, player1)
    }
}

pub fn day22() {
    // Sample input
    let _player1 = vec![9, 2, 6, 3, 1];
    let _player2 = vec![5, 8, 4, 7, 10];

    // Real input
    let player1 = vec![18, 19, 16, 11, 47, 38, 6, 27, 9, 22, 15, 42,
                           3, 4, 21, 41, 14, 8, 23, 30, 40, 13, 35, 46, 50];
    let player2 = vec![39, 1, 29, 20, 45, 43, 12, 2, 37, 33, 49, 32,
                           10, 26, 36, 17, 34, 44, 25, 28, 24, 5, 48, 31, 7];

    let winner = regular_combat(&player1, &player2);
    let score : usize = winner.iter().rev().enumerate().map(|(i, j)| (i+1) * j).sum();
    println!("{}", score);

    let (_, winner) = recursive_combat(&player1, &player2);
    let score : usize = winner.iter().rev().enumerate().map(|(i, j)| (i+1) * j).sum();
    println!("{}", score);
}
