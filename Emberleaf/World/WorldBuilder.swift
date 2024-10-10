//
//  WorldBuilder.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

@resultBuilder
struct WorldBuilder {
    static func buildBlock(_ components: Camera...) -> World {
        return World(camera: components.first!)
    }
}
