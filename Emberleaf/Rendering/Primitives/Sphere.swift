//
//  Sphere.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import SwiftUI

extension Mesh {
    static func sphere(radius: Float, stacks: Int, slices: Int, color: Color) -> Mesh {
        var vertices: [Vertex] = []
        var indices: [UInt16] = []
        
        let colorVec = color.simd4

        for stack in 0...stacks {
            let phi = Float(stack) / Float(stacks) * .pi  // Latitude angle (0 to pi)
            
            for slice in 0...slices {
                let theta = Float(slice) / Float(slices) * 2.0 * .pi  // Longitude angle (0 to 2*pi)

                // Spherical to Cartesian conversion
                let x = radius * sin(phi) * cos(theta)
                let y = radius * cos(phi)
                let z = radius * sin(phi) * sin(theta)

                let position = SIMD3<Float>(x, y, z)
                let normal = normalize(position)  // The normal is just the normalized position on the unit sphere
                
                let vertex = Vertex(position: position, color: colorVec, normal: normal)
                vertices.append(vertex)
            }
        }

        for stack in 0..<stacks {
            for slice in 0..<slices {
                let first = UInt16((stack * (slices + 1)) + slice)
                let second = UInt16(first + UInt16(slices + 1))

                indices.append(first)
                indices.append(second)
                indices.append(first + 1)

                indices.append(second)
                indices.append(second + 1)
                indices.append(first + 1)
            }
        }

        return Mesh(vertices: vertices, indices: indices)
    }
}
