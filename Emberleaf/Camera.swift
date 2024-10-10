//
//  Camera.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd

struct Camera {
    var position: SIMD3<Float>
    var target: SIMD3<Float>
    var up: SIMD3<Float>
    
    func viewMatrix() -> matrix_float4x4 {
        return lookAt(eye: position, target: target, up: up)
    }
    
    func projectionMatrix(aspectRatio: Float, fov: Float, nearPlane: Float, farPlane: Float) -> matrix_float4x4 {
        return perspective(fov: fov, aspectRatio: aspectRatio, nearZ: nearPlane, farZ: farPlane)
    }
}
