use std::collections::HashMap;
use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn get_all_containment(containment: &HashMap<String, Vec<(usize, String)>>, color: String)
        -> Vec<(usize, String)>
{
    let mut ret = containment[&color].clone();
    let init_vec = ret.clone();
    for (count, other_color) in init_vec {
        ret.extend(get_all_containment(containment, other_color)
                   .into_iter()
                   .map(|(a, b)| (a*count, b)));
    }
    ret
}

pub fn day7() {
    let file = File::open("input7").unwrap();
    let reader = BufReader::new(file);
    let containment = reader
        .lines()
        .map(|wrapped_line| {
            let line = wrapped_line.unwrap();
            let mut splits = line.split(" bags contain ");

            let orig_color = String::from(splits.next().unwrap());
            let contained = splits.next().unwrap();
            if contained == "no other bags." {
                (orig_color, Vec::new())
            } else {
                let contained = contained
                    .split(", ")
                    .map(|elt| {
                        let mut splits = elt.split(" ");
                        let num = splits.next().unwrap().parse().unwrap();
                        let color = splits.next().unwrap().to_string() + " " + splits.next().unwrap();
                        (num, color)
                    })
                    .collect::<Vec<_>>();
                (orig_color, contained)
            }
        })
        .collect::<HashMap<_, _>>();

    let all_colors = containment.keys();
    let have_shiny_gold = all_colors
        .filter(|color| {
            let contained = get_all_containment(&containment, color.to_string())
                .iter()
                .map(|(_, b)| b.clone())
                .collect::<HashSet<_>>();
            contained.contains(&"shiny gold".to_string())
        })
        .count();
    println!("{}", have_shiny_gold);

    let need_shiny_gold : usize = get_all_containment(&containment, "shiny gold".to_string())
        .iter()
        .map(|(a, _)| a)
        .sum();
    println!("{}", need_shiny_gold);
}
