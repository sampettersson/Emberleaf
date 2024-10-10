#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]], constant Uniforms& uniforms [[buffer(1)]]) {
    VertexOut out;

    // Apply rotation and translation to the position
    float4 position = float4(in.position.x, in.position.y, in.position.z, 1.0);
    position = uniforms.modelMatrix * position;        // Transform with model matrix
    position = uniforms.viewMatrix * position;         // Transform with view matrix
    out.position = uniforms.projectionMatrix * position;  // Apply projection
    
    out.color = in.color;
    
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
