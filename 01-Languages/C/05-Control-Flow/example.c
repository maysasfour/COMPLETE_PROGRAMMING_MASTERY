/* example.c -- if/else, switch fall-through (a real, deliberate C/C++
   footgun, demonstrated both broken and fixed), and for/while loops. */
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 3; i++) {
        if (i % 2 == 0) {
            printf("%d is even\n", i);
        } else {
            printf("%d is odd\n", i);
        }
    }

    /* switch WITHOUT break -- demonstrates fall-through actually
       happening, not just described. Case 1 falls into case 2 and 3. */
    printf("\n-- switch WITHOUT break (fall-through) --\n");
    for (int day = 1; day <= 3; day++) {
        switch (day) {
            case 1:
                printf("day %d: Monday-ish\n", day);
                /* no break -- deliberately falls through */
            case 2:
                printf("day %d: also prints Tuesday-ish\n", day);
                /* no break -- deliberately falls through */
            case 3:
                printf("day %d: also prints Wednesday-ish\n", day);
                break;
            default:
                printf("day %d: unknown\n", day);
        }
    }

    /* switch WITH break -- the fixed, usually-intended version. */
    printf("\n-- switch WITH break (no fall-through) --\n");
    for (int day = 1; day <= 3; day++) {
        switch (day) {
            case 1:
                printf("day %d: Monday\n", day);
                break;
            case 2:
                printf("day %d: Tuesday\n", day);
                break;
            case 3:
                printf("day %d: Wednesday\n", day);
                break;
            default:
                printf("day %d: unknown\n", day);
        }
    }

    /* while / do-while -- identical to C++. */
    int countdown = 3;
    printf("\n-- while --\n");
    while (countdown > 0) {
        printf("%d...\n", countdown);
        countdown--;
    }

    int x = 0;
    printf("\n-- do-while (body runs at least once even though x == 0 fails immediately after) --\n");
    do {
        printf("x = %d\n", x);
        x++;
    } while (x < 0);

    return 0;
}
