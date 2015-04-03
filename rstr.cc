/* Generate a random hexidecimal string of large number of nibbles.
 * 
 * g++ -g -Wall -o rstr -std=c++11 rstr.cc -lstdc++ -lgmp
 *
 * davep 17-Mar-2015
 */
#include <iostream>
#include <string>
#include <random>
#include <algorithm>
#include <chrono>
#include <functional>

#include <gmp.h>

using namespace std;

/* https://stackoverflow.com/questions/440133/how-do-i-create-a-random-alpha-numeric-string-in-c */
string random_string( size_t length )
{
    auto randchar = []() -> char
    {
        const char charset[] = 
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";
        const size_t max_index = (sizeof(charset) - 1);
        return charset[ rand() % max_index ];
    };
    string str(length,0);
    generate_n( str.begin(), length, randchar );
    return str;
}

//
// My version (with help from the Stack Overflow answer above)
// 
string random_hex_string( size_t length )
{
//    unsigned seed1 = chrono::system_clock::now().time_since_epoch().count();
    // http://www.cplusplus.com/reference/random/random_device/random_device/
    random_device rd;
    unsigned long int seed1 {rd()};
//    string charset { "0123456789abcdef""ABCDEFGHIJKLMNOPQRSTUVWXYZ""abcdefghijklmnopqrstuvwxyz" };
    string charset { "0123456789abcdef" };
    auto gen = bind(uniform_int_distribution<unsigned int>{0,charset.size()-1},
                    default_random_engine{seed1});

    auto randchar = [&charset,&gen]() -> char
    {
        return charset.at(gen());
    };

    string str(length,0);
    generate_n( str.begin(), str.size(), randchar );
    return str;
}

int main(int argc, char *argv[] )
{
    unsigned long int num_bits;
    char *end_ptr;

        num_bits = 204;
    if( argc >= 2 ) {
        num_bits = strtoul( argv[1], &end_ptr, 10 );
        if( *end_ptr != 0 ) {
            return EXIT_FAILURE;
        }
    }

    // divide by 4 to get nibbles
    string str = random_hex_string(num_bits/4);
//    cout << str << '\n';

    // random 204 bit number with GMP
    // http://www.cplusplus.com/reference/random/random_device/random_device/
    random_device rd;
    unsigned long int seed {rd()};
    mpz_t num;
    mpz_init(num);
    gmp_randstate_t state;
    gmp_randinit_default(state);
    gmp_randseed_ui(state,seed);

    mpz_urandomb(num,state,num_bits);
    gmp_printf("%Zx\n",num);
}

