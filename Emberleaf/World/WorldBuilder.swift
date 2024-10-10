//
//  WorldBuilder.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

@resultBuilder
struct WorldBuilder {
    public static func buildBlock(_ entities: Entity...) -> World {
        return World(entities: entities)
    }
}
