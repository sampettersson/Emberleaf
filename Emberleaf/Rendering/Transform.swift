//
//  Transform.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd

struct Transform: Component {
    var translation: SIMD3<Float>
    var rotation: SIMD3<Float>
    var scale: SIMD3<Float>
}

