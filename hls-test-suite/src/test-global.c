#include <stdlib.h>
#include <assert.h>

int C[32];
int * t;

void run(){
    for(int i=0; i<32; i++){
        C[i] = i*i+*t;
    }
}

int main(int argc, char** argv){
    int a = 0;
    t = &a;
    run();

    assert(C[0] == 0+a);

    assert(C[2] == 2*2+a);

    assert(C[31] == 31*31+a);
    a=10;
    run();

    assert(C[0] == 0+a);

    assert(C[2] == 2*2+a);

    assert(C[31] == 31*31+a);
    return 0;
}