/*
 * rep.c -- Print binary representation of given numbers
 *
 * This program is meant to explore the binary representation of
 * different numeric types.  It takes the strings given as arguments
 * and interprets each one as a decimal number.  The number is
 * converted to different numeric representations (corresponding to
 * the different numeric types of C), and the bit pattern of each of
 * them is printed to stdout.
 *
 * Tomás S. Grigera <tgrigera@iflysib.unlp.edu.ar>, August 2015
 *
 * Permission to use, copy, modify and redistribute this software for
 * any purpose is hereby granted without fee, provided that this
 * notice and attributions are retained in all copies.  It is
 * provided "as is" without express or implied warranty.
 *
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * This prints the binary representation of a value of any type, read
 * through a void pointer.  Separates bits in groups of four for
 * easier reading.  Assumes a little-endian (LSB first) architecture
 * for all numeric types (as in x86)
 *
 * This is based on user295190's answer to a StackOverflow question:
 *
 * http://stackoverflow.com/questions/111928/is-there-a-printf-converter-to-print-in-binary-format
 *
 */
void print_rep(void *n,size_t size)
{
  unsigned char *b;

  for (b=n+size-1; b!=n-1; b--)
    printf("%1u%1u%1u%1u %1u%1u%1u%1u ",
	   (*b & 128)>>7,(*b & 64)>>6,(*b & 32)>>5,(*b & 16)>>4,
	   (*b & 8)>>3,(*b & 4)>>2,(*b & 2)>>1,*b & 1);
}

int main(int argc, char *argv[])
{
  short           s;
  unsigned short us;
  int             i,j;
  unsigned int    u;
  long int        l;
  float           f;
  double          d;

  for (j=1; j<argc; ++j) {
    s=atoi(argv[j]);
    us=atoi(argv[j]);
    i=atoi(argv[j]);
    u=atoi(argv[j]);
    l=atol(argv[j]);
    f=atof(argv[j]);
    d=atof(argv[j]);

    printf("\nString no. %d (%s) representation:\n ",j,argv[j]);
    print_rep(&s,sizeof(s));
    printf("--> %hd (as short)\n ",s);
    print_rep(&us,sizeof(us));
    printf("--> %hu (as unsigned short)\n ",us);
    print_rep(&i,sizeof(i));
    printf("--> %d (as int)\n ",i);
    print_rep(&u,sizeof(u));
    printf("--> %u (as unsigned int)\n ",u);
    print_rep(&l,sizeof(l));
    printf("--> %ld (as long int)\n ",l);
    print_rep(&f,sizeof(f));
    printf("--> %g (as float)\n ",f);
    printf("S|--exp---||-------significand--------|\n ");
    print_rep(&d,sizeof(d));
    printf("--> %g (as double)\n ",d);
    printf("S|----exp----| |------------------------significand---------------------------|\n ");
  }
    
  return 0;
}
