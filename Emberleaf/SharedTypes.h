//
//  SharedTypes.h
//  Emberleaf
//
//  Created by Sam Pettersson on 10/9/24.
//

#ifndef SharedTypes_h
#define SharedTypes_h

#include <simd/simd.h>

struct Vertex {
    vector_float3 position;
    vector_float4 color;
    vector_float3 normal;
};

#endif /* SharedTypes_h */
