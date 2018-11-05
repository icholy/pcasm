#include <stdio.h>

int calc_sum(int) __attribute__ ((cdecl));

int main(void) {
    printf("Sum integers up to:  ");

    int n;
    scanf("%d", &n);

    int sum = calc_sum(n);

    printf("Sum is: %d\n", sum);
    return 0;
}