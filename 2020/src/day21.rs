use std::collections::HashMap;
use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};
use itertools::Itertools;

pub fn day21() {
    let file = File::open("input21").unwrap();
    let mut possible_allergen : HashMap<String, HashSet<String>> = HashMap::new();
    let mut all_ingredients : Vec<String> = vec![];

    for wrapped_line in BufReader::new(file).lines() {
        let line = wrapped_line.unwrap();
        let mut splits = line.split(" (contains ");
        let ingredients = splits.next().unwrap().split(" ").map(|s| s.to_string()).collect::<HashSet<String>>();
        for i in &ingredients {
            all_ingredients.push(i.to_string());
        }

        let mut allergens = splits.next().unwrap().to_string();
        allergens.pop();
        for a in allergens.split(", ") {
            possible_allergen.entry(a.to_string()).or_insert(ingredients.clone()).retain(|i| ingredients.contains(i));
        }
    }

    // Part 1
    let all_possible_allergens = possible_allergen
        .values()
        .fold(HashSet::new(), |a, b| a.union(&b).cloned().collect());
    println!("{}", all_ingredients
         .iter()
         .filter(|i| !(&all_possible_allergens).contains(&i.to_string()))
         .count());

    // Part 2
    loop {
        let single_values = possible_allergen
            .values()
            .filter(|s| s.len() == 1)
            .fold(HashSet::new(), |a, b| a.union(b).cloned().collect());

        possible_allergen
            .values_mut()
            .for_each(|v| {
                if v.len() > 1 {
                    v.retain(|i| !single_values.contains(i))
                }
            });

        if single_values.len() == possible_allergen.iter().count() {
            break;
        }
    }
    println!("{}", possible_allergen
         .iter()
         .sorted_by_key(|(k, _)| k.clone())
         .map(|(_, v)| v.iter().next().unwrap().clone())
         .join(","));
}
