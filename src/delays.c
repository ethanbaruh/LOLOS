#include "gpio.h"

/**
 * Pauses execution for n cycles
 */
void wait_cycles(unsigned int n) {
    for (int i = 0; i < n; i++) {
        asm volatile("nop");
    }
}

/**
 * Paused execution for n microseconds
 */
void wait_msec(unsigned int n) {
    register unsigned long f, t, r;
    // Get the frequency of clock ticks
    asm volatile ("mrs %0, cntfrq_el0" : "=r"(f));

    // Get the current tick count value
    asm volatile ("mrs %0, cntpct_el0" : "=r"(t));

    // Calculate necessary count to continue exec
    unsigned long i = ((f/1000)*n)/1000;

    // Halt until time elapsed
    do { asm volatile ("mrs %0, cntpct_el0" : "=r"(r)); } while (r-t<i);
}