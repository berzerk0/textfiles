#!/usr/bin/python


import sys


def stringToCharCode_SQL(argument):
    result = ''

    for char in argument:
        result = result + str(ord(char)) + " "

    return result



print (stringToCharCode_SQL(sys.argv[1]))

