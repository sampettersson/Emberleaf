//
//  Light.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import SwiftUI

struct Light: Component {
    var color: Color
    var intensity: Float
}

struct ResolvedLight {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var intensity: Float
    
    init(_ light: Light, _ transform: Transform) {
        color = light.color.simd4
        position = transform.translation
        intensity = light.intensity
    }
}
