#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float3 normal [[attribute(2)]];
};

struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
    float3 worldPosition;
    float3 viewPosition;
};

struct Light {
    float3 position;
    float3 color;
    float intensity;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]], constant Uniforms& uniforms [[buffer(1)]]) {
    VertexOut out;

    float4 position = float4(in.position.x, in.position.y, in.position.z, 1.0);
    
    float4 worldPosition = uniforms.modelMatrix * position;
    
    out.normal = (uniforms.modelMatrix * float4(in.normal, 0.0)).xyz;
    out.worldPosition = worldPosition.xyz;
    
    float4 viewPosition = uniforms.viewMatrix * worldPosition;
    out.viewPosition = viewPosition.xyz;
    
    position = uniforms.modelMatrix * position;
    position = uniforms.viewMatrix * position;
    out.position = uniforms.projectionMatrix * position;
    
    out.color = in.color;
    
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]], constant Light &light [[buffer(2)]]) {
    float3 normal = normalize(in.normal);
    float3 lightDir = normalize(light.position - in.worldPosition);

    float ambientStrength = 0.2;
    float3 ambient = ambientStrength * light.color;

    float diffuseStrength = max(dot(normal, lightDir), 0.0);
    float3 diffuse = diffuseStrength * light.color;

    float3 viewDir = normalize(-in.viewPosition);
    float3 halfwayDir = normalize(lightDir + viewDir);
    float specularStrength = pow(max(dot(normal, halfwayDir), 0.0), 32.0);
    float3 specular = specularStrength * light.color;

    float3 lighting = ambient + diffuse + specular;

    return float4(lighting * in.color.rgb, in.color.a);
}
