#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int run(int a, int b){
	return a + b;
}

int main(int argc, char** argv){
	int result = run(1, 2);
	printf("Result: %i\n", result);

	// Check if correct result
	if (result == 3)
		return 0;

	return 1;
}
