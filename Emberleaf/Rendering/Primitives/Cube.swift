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
            // Front face (z = 1), normals pointing forward
            Vertex(position: SIMD3(-1, -1,  1), color: colorVec, normal: SIMD3(0, 0, 1)), // 0: Front bottom-left
            Vertex(position: SIMD3( 1, -1,  1), color: colorVec, normal: SIMD3(0, 0, 1)), // 1: Front bottom-right
            Vertex(position: SIMD3( 1,  1,  1), color: colorVec, normal: SIMD3(0, 0, 1)), // 2: Front top-right
            Vertex(position: SIMD3(-1,  1,  1), color: colorVec, normal: SIMD3(0, 0, 1)), // 3: Front top-left
            
            // Back face (z = -1), normals pointing backward
            Vertex(position: SIMD3(-1, -1, -1), color: colorVec, normal: SIMD3(0, 0, -1)), // 4: Back bottom-left
            Vertex(position: SIMD3( 1, -1, -1), color: colorVec, normal: SIMD3(0, 0, -1)), // 5: Back bottom-right
            Vertex(position: SIMD3( 1,  1, -1), color: colorVec, normal: SIMD3(0, 0, -1)), // 6: Back top-right
            Vertex(position: SIMD3(-1,  1, -1), color: colorVec, normal: SIMD3(0, 0, -1)), // 7: Back top-left
            
            // Left face (x = -1), normals pointing left
            Vertex(position: SIMD3(-1, -1, -1), color: colorVec, normal: SIMD3(-1, 0, 0)), // 8: Left bottom-back
            Vertex(position: SIMD3(-1,  1, -1), color: colorVec, normal: SIMD3(-1, 0, 0)), // 9: Left top-back
            Vertex(position: SIMD3(-1,  1,  1), color: colorVec, normal: SIMD3(-1, 0, 0)), // 10: Left top-front
            Vertex(position: SIMD3(-1, -1,  1), color: colorVec, normal: SIMD3(-1, 0, 0)), // 11: Left bottom-front
            
            // Right face (x = 1), normals pointing right
            Vertex(position: SIMD3( 1, -1, -1), color: colorVec, normal: SIMD3(1, 0, 0)), // 12: Right bottom-back
            Vertex(position: SIMD3( 1,  1, -1), color: colorVec, normal: SIMD3(1, 0, 0)), // 13: Right top-back
            Vertex(position: SIMD3( 1,  1,  1), color: colorVec, normal: SIMD3(1, 0, 0)), // 14: Right top-front
            Vertex(position: SIMD3( 1, -1,  1), color: colorVec, normal: SIMD3(1, 0, 0)), // 15: Right bottom-front
            
            // Top face (y = 1), normals pointing up
            Vertex(position: SIMD3(-1,  1,  1), color: colorVec, normal: SIMD3(0, 1, 0)), // 16: Top front-left
            Vertex(position: SIMD3( 1,  1,  1), color: colorVec, normal: SIMD3(0, 1, 0)), // 17: Top front-right
            Vertex(position: SIMD3( 1,  1, -1), color: colorVec, normal: SIMD3(0, 1, 0)), // 18: Top back-right
            Vertex(position: SIMD3(-1,  1, -1), color: colorVec, normal: SIMD3(0, 1, 0)), // 19: Top back-left
            
            // Bottom face (y = -1), normals pointing down
            Vertex(position: SIMD3(-1, -1,  1), color: colorVec, normal: SIMD3(0, -1, 0)), // 20: Bottom front-left
            Vertex(position: SIMD3( 1, -1,  1), color: colorVec, normal: SIMD3(0, -1, 0)), // 21: Bottom front-right
            Vertex(position: SIMD3( 1, -1, -1), color: colorVec, normal: SIMD3(0, -1, 0)), // 22: Bottom back-right
            Vertex(position: SIMD3(-1, -1, -1), color: colorVec, normal: SIMD3(0, -1, 0))  // 23: Bottom back-left
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
