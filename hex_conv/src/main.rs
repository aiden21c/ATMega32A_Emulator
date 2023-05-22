use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Write};

fn hex_to_dec(hex: &[char]) -> u32 {
    let mut dec: u32 = 0;
    for (i, x) in hex.iter().rev().enumerate() {
        // convert char to u32
        let x = x.to_digit(16).unwrap();
        // add to dec
        dec += x * 16u32.pow(i as u32);
    }
    return dec;
}

fn main() -> std::io::Result<()>{
    let args = args();
    if args.len() != 3 {
        println!("Please provide a input file location and a output file location");
        return Err(std::io::Error::new(std::io::ErrorKind::Other, "Invalid arguments"));
    }
    let args = args.collect::<Vec<String>>();
    // read file with path being args[1]
    let file = File::open(&args[1])?;
    // read file contents
    let buf = BufReader::new(file);
    // setup state logic
    let mut out: Vec<(char,char)> = Vec::new();
    let mut address_track = 0;
    // read each line
    for line in buf.lines() {
        let line = line?;
        let chars = line.trim().chars().collect::<Vec<char>>();
        if chars[0] != ':' {
            println!("Invalid line: {}", line);
            return Err(std::io::Error::new(std::io::ErrorKind::Other, "Invalid line"));
        }
        // create slice of characters 1 and 2 for length
        let length: u32 = hex_to_dec(&chars[1..3]);
        // check type from characters 7 and 8
        let record_type = hex_to_dec(&chars[7..9]);
        if record_type == 1 { //end of file
            break;
        }
        else if record_type == 2 { //extended segment address
        }
        else if record_type == 3 { //start segment address
        }
        else if record_type == 4 { //extended linear address
        }
        else if record_type == 5 { //start linear address
        }
        else if record_type == 0 { //data
            // get address from characters 3 to 6
            let address = hex_to_dec(&chars[3..7]);
            // check if address is greater than address_track
            if address > address_track {
                // fill out with 0s
                for _ in 0..(address - address_track) {
                    out.push(('0','0'));
                }
                address_track = address;
            }
            // get data from characters 9 to 9 + length
            let data = &chars[9..(9 + length as usize * 2)];
            // convert data to u8
            for i in 0..(length as usize) {
                out.push((data[i * 2], data[i * 2 + 1]));
            }
            address_track += length;
        }
        else {
            println!("Invalid record type: {}", record_type);
            return Err(std::io::Error::new(std::io::ErrorKind::Other, "Invalid record type"));
        }
    }
    // write to file with path being args[2]
    let mut file = File::create(&args[2])?;
    for byte in out.iter() {
        writeln!(file, "{}{}", byte.0, byte.1)?;
    }
    
    return Ok(());
}
