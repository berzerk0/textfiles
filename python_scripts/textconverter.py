#!/usr/bin/python
# types: url, base64, html, unicode, hex, charcode

from sys import exit, argv
from string import replace

from binascii import a2b_hex,b2a_hex
from urllib import quote_plus,unquote
from base64 import b64encode,b64decode


inputString = argv[3]
dirString = argv[1]
choice = argv[2]



def UniEncode(inputStr):
    result = ""
    for char in inputStr:
        result = result + "\\u" + str(hex(ord(char)))

    return result.replace("x","0")


if dirString == "encode" :


    #plaintext to url encoded
    if choice == "url": result = quote_plus(inputString)

    # plaintext ascii to hex in ascii
    if choice == "hex" : result = b2a_hex(str.encode(inputString.strip()))


    # plaintext to charcode list
    if choice == "charcode" : result = ','.join(str(ord(char)) for char in inputString)


    #ascii plaintext to base64 ascii
    if choice == "base64" : result = b64encode(inputString)

    if choice == "unicode" : result = UniEncode(inputString)


elif dirString == "decode" :

    # url encoded to plaintext
    if choice == "url" : result = unquote(inputString)

    # hex in ascii to plaintext in ascii
    if choice == "hex" : result = a2b_hex(str.encode(inputString.strip()))

    #charcode list to plaintext
    if choice == "charcode" : result = ''.join(str(chr(int(i))) for i in inputString.split(','))

    #ascii plaintext to base64 ascii
    if choice == "base64" : result = b64decode(inputString)

    if choice == "unicode" : result = "Sorry, there is no unicode decoder at this time."

else:
    print "Invalid conversion type."
    sys.exit()



print result
