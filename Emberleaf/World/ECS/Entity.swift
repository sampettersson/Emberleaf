//
//  Entity.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

struct Entity {
    var components: [any Component]
    
    init() {
        self.components = []
    }
    
    static func & (lhs: Entity, rhs: any Component) -> Entity {
        var entity = lhs
        entity.components.append(rhs)
        return entity
    }
}
