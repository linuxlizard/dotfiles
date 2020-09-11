#!/usr/bin/env python3

# 8-Jan-2006 davep
# generate nice random passwords

# 20200911 davep 
# after a long long time, upgrade to a better way

import sys
import random
import string

default_pwlen = 14

def mkpasswords(pwlen, num_passwords):
    s = string.ascii_letters + string.digits
    # remove l (lowercase L) and 1 (number one) and I (upper case I) because
    # they are too visually indistinguishable
    s = "".join([c for c in s if c not in ("l","1","I")])
    for i in range(num_passwords):
        print("".join(random.choices(s, k=pwlen)))

def old_mkpasswords( pwlen, num_passwords ) :
    # range() generates ints in [x,y) so add one so we get [x,y]
    chars = [ chr(x) for x in range( ord('0'), ord('9')+1 ) ]
    chars.extend( [ chr(x) for x in range( ord('a'), ord('z')+1 ) ] )
    chars.extend( [ chr(x) for x in range( ord('A'), ord('Z')+1 ) ] )

    # davep 25-Sep-2012 ; remove l (lowercase L) and 1 (number one) and I
    # (upper case I) because they are too visually indistinguishable
    print( type( chars) )
    chars2 = [ c for c in chars if c not in ("l","1","I") ]

    print( "".join( chars ) )
    print( "".join( chars2 ) )
    chars = chars2
       
    random.seed( None )

    for i in range( 0, num_passwords ) :
        pwd = "".join( [ chars[ int( random.random() * len(chars) ) ] for x in range( 0, pwlen ) ] )
        print( pwd )
    
if __name__ == '__main__' :
    mkpasswords( default_pwlen, 1000 )

# vim: ts=4:sts=4:et
