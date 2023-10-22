// add sub mul div on command line (in rust)
// davep 20230222
// davep 20231022 ; finally a nice working version!
//
// duplicates a python program I wrote ~2011
//
// Create links to 'op':
//for f in add sub mul div ; do ln -s op $f ; done

use std::env;
use std::str::FromStr;

fn tofloat(numstr: &str) -> f32 
{
    // check for leading 0x or 0X
    if numstr.len() > 2 && (numstr.starts_with("0x") || numstr.starts_with("0X")) {
        // strip the leading two chars
        return i32::from_str_radix(numstr.get(2..).unwrap(), 16).unwrap() as f32;
    }

    // not explictly hex so try all our options in order
    // integer
    // float
    // implicit hex (no leading 0x)
    let result = i32::from_str(&numstr);

    match result {
        Ok(num) => { return num as f32; },
        Err(_e) => 
            match f32::from_str(&numstr) {
                Ok(num) => { return num; },
                Err(_e) => 
                    match i32::from_str_radix(&numstr, 16) {
                        Ok(num) => { return num as f32; },
                        Err(_e) => { panic!("bad number {}", numstr) }
                    }   
            }
    
    }
}

fn main() {
//    let args: Vec<String> = env::args().collect();
//    dbg!(&args);

    let mut arg_iter = env::args();
    let progname = &arg_iter.next().unwrap();
    let opname : String;

    if progname.ends_with("op") {
        // we're running as 'op' so the next arg will be our operation
        // (so we can run as `cargo run add 1 2 3 4 5 ` for
        opname = arg_iter
                    .next()
                    .expect("incorrect command line arguments")
                    .to_string();
    }
    else {
        opname = progname.to_string();
    }

//    println!("opname={}", opname);

    let op = 
        match opname.as_str() {
            "add" => { |a:f32, b:f32| -> f32 { a+b } },
            "sub" => { |a:f32, b:f32| -> f32 { a-b } },
            "mul" => { |a:f32, b:f32| -> f32 { a*b } },
            "div" => { |a:f32, b:f32| -> f32 { a/b } },
            _ => { panic!("unknown op {}", opname) }
        };

    let result:f32 = arg_iter.map(|value| tofloat(&value))
                            .reduce(|result, value| op(result,value) )
                            .unwrap();

    println!("{}", result);
}

