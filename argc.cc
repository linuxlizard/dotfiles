/* C++ style main()
 * 
 * g++ -g -Wall -o argc -std=c++11 argc.cc -lstdc++ 
 *
 * davep 17-Mar-2015
 */

#include <iostream>
#include <vector>
#include <string>
#include <iterator>
#include <exception>
#include <stdexcept>

using namespace std;

struct channel 
{
    string name;
    int num;
};

vector<struct channel> channel_list;

int cpp_main( vector<string>& cpp_argv )
{
    for( auto s : cpp_argv ) {
        cout << s << "\n";
    }

    /* modify iterator inside the body of the loop */
    for( auto s=cpp_argv.begin() ; s != cpp_argv.end() ; ++s ) {
        cout << *s << "\n";

        if( *s == "-ch" ) {
            /* channel number */
            ++s;
            try { 
                int channel_num = stoul(*s);
                channel_list.push_back( { string{"none"}, channel_num } );
            }
            catch ( invalid_argument& e ) {
                cerr << "error: " << e.what() << " for channel argument \"" << *s << "\"\n";
                return EXIT_FAILURE;
            }
        }
    }

    for( auto c : channel_list) {
        cout << "name=" << c.name << " num=" << c.num << "\n";
    }

    return EXIT_SUCCESS;
}

int main( int argc, char* argv[] )
{
    vector<string> cpp_argv;

    for( int i=0 ; i<argc ; i++ ) {
        cpp_argv.push_back( string {argv[i]} );
    }

    return cpp_main(cpp_argv);
}

