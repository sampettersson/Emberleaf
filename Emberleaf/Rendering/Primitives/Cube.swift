//
//  Cube.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd
import SwiftUI

struct Cube: Component {
    var color: Color
    
    var vertices: [Vertex] {
        var colorVec = SIMD4<Float>()
        let resolvedColor = color.resolve(in: EnvironmentValues())
        
        colorVec.x = resolvedColor.red
        colorVec.y = resolvedColor.green
        colorVec.z = resolvedColor.blue
        colorVec.w = resolvedColor.opacity
        
        return [
            Vertex(position: SIMD3(-1, -1,  1), color: colorVec), // 0: Front bottom-left
            Vertex(position: SIMD3( 1, -1,  1), color: colorVec), // 1: Front bottom-right
            Vertex(position: SIMD3( 1,  1,  1), color: colorVec), // 2: Front top-right
            Vertex(position: SIMD3(-1,  1,  1), color: colorVec), // 3: Front top-left
            Vertex(position: SIMD3(-1, -1, -1), color: colorVec), // 4: Back bottom-left
            Vertex(position: SIMD3( 1, -1, -1), color: colorVec), // 5: Back bottom-right
            Vertex(position: SIMD3( 1,  1, -1), color: colorVec), // 6: Back top-right
            Vertex(position: SIMD3(-1,  1, -1), color: colorVec)  // 7: Back top-left
        ]
    }

    let indices: [UInt16] = [
        // Front face
        0, 1, 2, 2, 3, 0,
        // Back face
        4, 5, 6, 6, 7, 4,
        // Left face
        4, 0, 3, 3, 7, 4,
        // Right face
        1, 5, 6, 6, 2, 1,
        // Top face
        3, 2, 6, 6, 7, 3,
        // Bottom face
        4, 5, 1, 1, 0, 4
    ]
}
