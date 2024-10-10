//
//  Perspective.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd

func perspective(fov: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
    let yScale = 1 / tan(fov * 0.5)
    let xScale = yScale / aspectRatio
    let zRange = farZ - nearZ
    let zScale = -(farZ + nearZ) / zRange
    let wzScale = -2 * farZ * nearZ / zRange
    
    var mat = matrix_identity_float4x4
    mat.columns.0 = SIMD4<Float>(xScale, 0, 0, 0)
    mat.columns.1 = SIMD4<Float>(0, yScale, 0, 0)
    mat.columns.2 = SIMD4<Float>(0, 0, zScale, -1)
    mat.columns.3 = SIMD4<Float>(0, 0, wzScale, 0)
    return mat
}
