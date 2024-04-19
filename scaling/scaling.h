#ifndef SCALING_H
#define SCALING_H

double phaseDifference(float real1, float imag1, float real2, float imag2);   
void processTransformed(float* realPrev, float* imagPrev, float* realNew,
                        float* imagNew, float* realOutPrev, float* imagOutPrev,
                        float* realOutNew, float* imagOutNew,
                        double phaseScaleAmount);
void simpleTransform(float* realPrev, float* imagPrev, float* realNew,
                     float* imagNew, float* realOutPrev, float* imagOutPrev,
                     float* realOutNew, float* imagOutNew,
                     double phaseScaleAmount);  

#endif