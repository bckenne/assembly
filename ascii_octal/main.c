#include <stdio.h>
#include <string.h>

unsigned atoo( char * );
void otoa( unsigned, char * );

char s[8][40];

int main()
{
  int i;
  unsigned v;
  char r[40];

  strcpy(s[0],"0");
  strcpy(s[1],"1");
  strcpy(s[2],"4");
  strcpy(s[4],"1357");
  strcpy(s[3],"248");
  strcpy(s[5],"37777777777");
  strcpy(s[6],"77753102467");
  strcpy(s[7],"1234567012345670");

  for( i = 0; i < 8 ; i++ )
  {
     v = atoo(s[i]);
     printf("\"%s\" is %o",s[i],v);
     otoa(v,r);
     printf(" reconverted by otoa() is \"%s\"\n",r);
  }

  return 0;
}
