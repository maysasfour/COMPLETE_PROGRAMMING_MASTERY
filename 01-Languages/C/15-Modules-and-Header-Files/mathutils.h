/* mathutils.h -- a header declaring what mathutils.c defines. Header
   guards prevent this file's contents from being processed twice if
   it's #included (directly or transitively) more than once in the
   same translation unit -- a real, common problem without them. */
#ifndef MATHUTILS_H
#define MATHUTILS_H

int addInts(int a, int b);
int multiplyInts(int a, int b);
double average(const int* values, int count);

#endif /* MATHUTILS_H */
