#include <stdio.h>
#include <math.h>
#include "fixedpoint.h"

fixedpoint floatToFixed(float x) {
    return (fixedpoint) (x * (1 << FIXEDPOINT_FRACTIONAL_BITS));
}

float fixedToFloat(fixedpoint x) {
    return 0.0;
}
fixedpoint fixedMult(fixedpoint a, fixedpoint b) {
    return (fixedpoint) 0;
}