/*
 * Driver file for array1.asm file
 */

#include <stdio.h>

#include "cdecl.h"

int PRE_CDECL asm_main( void ) POST_CDECL;
void PRE_CDECL dump_line( void ) POST_CDECL;

int main()
{
  return asm_main();
}

/*
 * function dump_line
 * dumps all chars left in current line from input buffer
 */
void dump_line()
{
  int ch;

  while( (ch = getchar()) != EOF && ch != '\n')
    /* null body*/ ;
}

