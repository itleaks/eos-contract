#include <string>
#include <sstream>
#include <iostream>
typedef unsigned long long uint64_t;
using namespace std;
static char char_to_symbol( char c ) {
  if( c >= 'a' && c <= 'z' )
     return (c - 'a') + 6;
  if( c >= '1' && c <= '5' )
     return (c - '1') + 1;
  return 0;
}

static uint64_t string_to_name( const char* str ) {

  uint32_t len = 0;
  while( str[len] ) ++len;

  uint64_t value = 0;

  for( uint32_t i = 0; i <= 12; ++i ) {
     uint64_t c = 0;
     if( i < len && i <= 12 ) c = uint64_t(char_to_symbol( str[i] ));

     if( i < 12 ) {
        c &= 0x1f;
        c <<= 64-5*(i+1);
     }
     else {
        c &= 0x0f;
     }

     value |= c;
  }

  return value;
}

static void trim_right_dots(std::string& str ) {
 const unsigned long last = str.find_last_not_of('.');
 if (last != std::string::npos)
    str = str.substr(0, last + 1);
}


std::string name_to_string(uint64_t value) {
 static const char* charmap = ".12345abcdefghijklmnopqrstuvwxyz";

 std::string str(13,'.');

 uint64_t tmp = value;
 for( uint32_t i = 0; i <= 12; ++i ) {
    char c = charmap[tmp & (i == 0 ? 0x0f : 0x1f)];
    str[12-i] = c;
    tmp >>= (i == 0 ? 4 : 5);
 }

 trim_right_dots( str );
 return str;
}

int main(int argc,char *argv[])
{
    if (argc < 3) {
        cout << "argument: [i/s], value" << "\n" ;
        return 1;
    }
    char* mode = argv[1];
    char* value = argv[2];
    if (mode[0] == 'i') {
        uint64_t ret = string_to_name(value);
        cout << ret << "\n";
    } else if (mode[0] == 's'){
        stringstream strValue;
        strValue << value;
        uint64_t  tmp;
        strValue >> tmp;
        std:string str = name_to_string(tmp);
        cout << str << "\n";
    }
    return 1;
}

