//
//  Cube.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import simd

struct Cube: Component {
    let vertices: [Vertex] = [
        Vertex(position: SIMD3(-1, -1,  1), color: SIMD4(1, 0, 0, 1)), // 0: Front bottom-left
        Vertex(position: SIMD3( 1, -1,  1), color: SIMD4(0, 1, 0, 1)), // 1: Front bottom-right
        Vertex(position: SIMD3( 1,  1,  1), color: SIMD4(0, 0, 1, 1)), // 2: Front top-right
        Vertex(position: SIMD3(-1,  1,  1), color: SIMD4(1, 1, 0, 1)), // 3: Front top-left
        Vertex(position: SIMD3(-1, -1, -1), color: SIMD4(1, 0, 1, 1)), // 4: Back bottom-left
        Vertex(position: SIMD3( 1, -1, -1), color: SIMD4(0, 1, 1, 1)), // 5: Back bottom-right
        Vertex(position: SIMD3( 1,  1, -1), color: SIMD4(1, 1, 1, 1)), // 6: Back top-right
        Vertex(position: SIMD3(-1,  1, -1), color: SIMD4(0, 0, 0, 1))  // 7: Back top-left
    ]

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
