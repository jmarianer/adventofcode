fn get_loop_size(pk : usize) -> usize {
    let mut ls = 0;
    let mut cur = 1;

    while cur != pk {
        cur = cur * 7;
        cur %= 20201227;
        ls += 1;
    }

    ls
}

fn encrypt(subj : usize, ls : usize) -> usize {
    let mut cur = 1;

    for _ in 0..ls {
        cur = cur * subj;
        cur %= 20201227;
    }

    cur
}

pub fn day25() {
    let door_pk = 335121;
    let key_pk = 363891;

    println!("{}", encrypt(key_pk, get_loop_size(door_pk)));
}
