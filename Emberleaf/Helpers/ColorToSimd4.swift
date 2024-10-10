//
//  ColorToSimd4.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import SwiftUI
import simd

extension Color {
    public var simd4: SIMD4<Float> {
        let resolved = self.resolve(in: EnvironmentValues())
        return SIMD4(resolved.red, resolved.green, resolved.blue, resolved.opacity)
    }
}
