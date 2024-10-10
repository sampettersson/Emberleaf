//
//  LookAt.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd

func lookAt(eye: SIMD3<Float>, target: SIMD3<Float>, up: SIMD3<Float>) -> matrix_float4x4 {
    let forward = normalize(target - eye)
    let right = normalize(cross(up, forward))
    let upDirection = cross(forward, right)

    var viewMatrix = matrix_identity_float4x4
    viewMatrix.columns.0 = SIMD4<Float>(right, 0)
    viewMatrix.columns.1 = SIMD4<Float>(upDirection, 0)
    viewMatrix.columns.2 = SIMD4<Float>(-forward, 0)
    viewMatrix.columns.3 = SIMD4<Float>(-dot(right, eye), -dot(upDirection, eye), dot(forward, eye), 1)

    return viewMatrix
}
