#include <stdio.h>

void calc_sum(int, int*) __attribute__ ((cdecl));

int main(void) {
    printf("Sum integers up to:  ");

    int n;
    scanf("%d", &n);

    int sum;
    calc_sum(n, &sum);

    printf("Sum is: %d\n", sum);
    return 0;
}