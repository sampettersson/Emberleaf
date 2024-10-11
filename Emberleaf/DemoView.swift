//
//  DemoView.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import SwiftUI

struct DemoView: View {
    @State var rotationX: Float = 0
    @State var rotationY: Float = 0
    
    var rotation: SIMD3<Float> {
        SIMD3(rotationX, rotationY, 0)
    }
    
    var body: some View {
        EmberleafRenderer {
            Entity() & Camera(
                position: SIMD3<Float>(0, 0, 5),
                target: SIMD3<Float>(0, 0, 0),
                up: SIMD3<Float>(0, 1, 0)
            )
            
            Entity() & Mesh.cube(color: .cyan) & Transform(
                translation: SIMD3(0, 0, 0),
                rotation: rotation,
                scale: SIMD3(1, 1, 1)
            )
            
            Entity() & Mesh.sphere(radius: 1, stacks: 80, slices: 80, color: .cyan) & Transform(
                translation: SIMD3(3, 0, 0),
                rotation: rotation,
                scale: SIMD3(1, 1, 1)
            )
            
            Entity() & Mesh.cube(color: .cyan) & Transform(
                translation: SIMD3(-3, 0, 0),
                rotation: rotation,
                scale: SIMD3(1, 1, 1)
            )
            
            Entity() & Light(color: .white, intensity: 1.0) & Transform(
                translation: SIMD3(0, 2, 0),
                rotation: rotation,
                scale: SIMD3(1, 1, 1)
            )
        }.gesture(DragGesture().onChanged({ value in
            rotationY = Float(value.translation.width / 20)
            rotationX = Float(value.translation.height / 20)
        }))
    }
}
