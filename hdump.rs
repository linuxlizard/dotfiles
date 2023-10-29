// hexdump a file
// duplicate a C function I wrote maybe 20+ years ago
// #learnrust
// davep 20231022

use std::env;
//use std::fs;
use std::fs::File;
use std::io::{ BufRead, BufReader };

const HEX_ASCII: [char;16] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                    'a', 'b', 'c', 'd', 'e', 'f' ];

fn printable_string(bytes: &[u8]) -> String
{
    const SPACE : u8 = 0x20;
    const TILDE : u8 = 0x7e;

    // map() -> printable bytes are printed, unprintable bytes are a '.'
    // fold() -> join all the chars together into a string 
    // (TODO there's probably a better way to do this)
//    bytes.iter()
//        .map(|&b| { if b >= SPACE && b <= TILDE { b as char } else { '.' } })
//        .fold( String::new(), |acc, c| acc + &c.to_string())
    bytes.iter()
        .map(|&b| { if b >= SPACE && b <= TILDE { b as char } else { '.' } })
        .collect()
}

fn dumpline(bytes: &[u8], line: &mut[char]) -> String
{
    let mut idx = 0;
    for b in bytes {
        line[idx]   = HEX_ASCII[ (b & 0x0f)     as usize ];
        line[idx+1] = HEX_ASCII[((b & 0xf0)>>4) as usize ];
        idx += 3;
    }

    line.iter().collect()
}

fn dump2(buffer: &[u8], file_offset: &mut usize)
{
    // build the output string here
    // 3*16 bytes across: space+nibble+nibble
    // +2 for the ' :' split in the middle
    let mut line: [char; 3*16+2] = core::array::from_fn( |_| ' ' );

    let length = buffer.len();

    let mut buf_offset = 0;
    while buf_offset+16 < length {
        let bytes = &buffer[buf_offset..buf_offset+16];

        println!("0x{:08}   {} {}", 
                    file_offset, 
                    dumpline(bytes, &mut line), 
                    printable_string(bytes));
        buf_offset += 16;

        *file_offset += 16;
    }

    if buf_offset < length {
        let bytes = &buffer[buf_offset..];
        let remain = length - buf_offset;
//        println!("{} bytes remain", length-buf_offset);

        // overwrite previous line's chars with whitespace
        for idx in remain*3 .. 3*16 {
            line[idx] = ' ';
//            println!("idx={}", idx);
        }

        println!("0x{:08}   {} {}", 
                    file_offset, 
                    dumpline(bytes, &mut line), 
                    printable_string(bytes));
    }

}

fn dump1(buffer: &[u8], file_offset: &mut usize)
{
    let length = buffer.len();

    let mut buf_offset = 0;

    while buf_offset+16 < length 
    {
        let bytes = &buffer[buf_offset..buf_offset+16];

        println!("0x{:08}   {:02x} {:02x} {:02x} {:02x} {:02x} {:02x} {:02x} {:02x} : {:02x} {:02x} {:02x} {:02x} {:02x} {:02x} {:02x} {:02x}   {}", 
            *file_offset,
            bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[0+8], bytes[1+8], bytes[2+8], bytes[3+8], bytes[4+8], bytes[5+8], bytes[6+8], bytes[7+8], 
            printable_string(bytes));
        *file_offset += 16;
        buf_offset += 16;

//            println!("s={}", s);
    }

    if buf_offset < length {
        // leftover
        let bytes = &buffer[buf_offset..];

        print!("0x{:08}  ", *file_offset);

        let mut i=0;
        while i < 16 {
            if i < bytes.len() {
                print!(" {:02x}", bytes[i]);
            }
            else { 
//                    print!(" __");
                print!("   ");
            }

            if i==7 {
                print!(" :");
            }
            i += 1;
        }
        println!("   {}", printable_string(bytes));
    }
    
}

fn main() -> std::io::Result<()> {
    let mut aiter = env::args();
    // skip argv[0] the program name
    let progname = aiter.next().unwrap();
    let infilename = aiter
                        .next()
                        .expect(&format!("usage: {} file-to-dump", progname))
                        .to_string();

    let infile = File::open(&infilename)?;
    // https://stackoverflow.com/questions/37079342/what-is-the-most-efficient-way-to-read-a-large-file-in-chunks-without-loading-th?rq=3
    let mut reader = BufReader::with_capacity(1024*1024,infile);
    let mut file_offset:usize = 0;
    loop {
        let buffer = reader.fill_buf()?;
        let length = buffer.len();
//        println!("read {} len={}", infilename, length);
        if length == 0 {
            break;
        };

        dump2(buffer, &mut file_offset);
//        dump1(buffer, &mut file_offset);
        reader.consume(length);
    }


//    print("read {} bytes", len(
    Ok(())
}
