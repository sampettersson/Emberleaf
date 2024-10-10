//
//  ModelMatrix.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

func modelMatrix(translation: SIMD3<Float>, rotation: SIMD3<Float>, scale: SIMD3<Float>) -> matrix_float4x4 {
    var matrix = matrix_identity_float4x4
    
    let translationMatrix = matrix_float4x4(columns: (
        SIMD4<Float>(1, 0, 0, 0),
        SIMD4<Float>(0, 1, 0, 0),
        SIMD4<Float>(0, 0, 1, 0),
        SIMD4<Float>(translation.x, translation.y, translation.z, 1)
    ))
    
    let scaleMatrix = matrix_float4x4(diagonal: SIMD4<Float>(scale.x, scale.y, scale.z, 1))
    
    let rotationXMatrix = matrix_float4x4(
        SIMD4<Float>(1, 0, 0, 0),
        SIMD4<Float>(0, cos(rotation.x), sin(rotation.x), 0),
        SIMD4<Float>(0, -sin(rotation.x), cos(rotation.x), 0),
        SIMD4<Float>(0, 0, 0, 1)
    )
    
    let rotationYMatrix = matrix_float4x4(
        SIMD4<Float>(cos(rotation.y), 0, -sin(rotation.y), 0),
        SIMD4<Float>(0, 1, 0, 0),
        SIMD4<Float>(sin(rotation.y), 0, cos(rotation.y), 0),
        SIMD4<Float>(0, 0, 0, 1)
    )
    
    let rotationZMatrix = matrix_float4x4(
        SIMD4<Float>(cos(rotation.z), sin(rotation.z), 0, 0),
        SIMD4<Float>(-sin(rotation.z), cos(rotation.z), 0, 0),
        SIMD4<Float>(0, 0, 1, 0),
        SIMD4<Float>(0, 0, 0, 1)
    )
    
    matrix = translationMatrix * rotationXMatrix * rotationYMatrix * rotationZMatrix * scaleMatrix
    return matrix
}
