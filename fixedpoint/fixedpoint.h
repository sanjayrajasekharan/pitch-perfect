#ifndef FIXED_H
#define FIXED_H

typedef int16_t fixedpoint;
typedef int32_t expandedfixedpoint;

fixedpoint floatToFixed(float x);
float fixedToFloat(fixedpoint x);
fixedpoint fixedMult(fixedpoint a, fixedpoint b);

#endif