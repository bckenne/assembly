#include <stdio.h>

extern void prt_binary(int);

int main(){
        prt_binary(0); printf("\n");
        prt_binary(1); printf("\n");
        prt_binary(3); printf("\n");
        prt_binary(-1); printf("\n");
        prt_binary(5281); printf("\n");
        return 0;
}
