//
//  World.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

struct World {
    var entities: [Entity] = []
}

extension Entity {
    func hasComponent<T: Component>(_ type: T.Type) -> Bool {
        components.contains(where: { $0 as? T != nil })
    }
    
    func hasAllComponents<each T: Component>(_ type: repeat (each T).Type) -> Bool {
        for type in repeat each type {
            if !self.hasComponent(type) {
                return false
            }
        }
        
        return true
    }
    
    func getComponent<T: Component>(_ type: T.Type) -> T {
        components.compactMap({ $0 as? T }).first!
    }
}

extension World {
    /// Finds an entity in the world with a requested component type.
    func query<each T: Component>(with type: repeat (each T).Type) -> (Entity, repeat each T)? {
        guard let entity = entities.first(where: { entity in
            entity.hasAllComponents(repeat each type)
        }) else {
            return nil
        }
        
        return (entity, repeat entity.getComponent(each type))
    }
    
    /// Finds all entities in the world with a set of requested component types.
    func queryAll<each T: Component>(with type: repeat (each T).Type) -> [(Entity, repeat each T)] {
        return entities.filter { entity in
            entity.hasAllComponents(repeat each type)
        }.map { entity in
            (entity, repeat entity.getComponent(each type))
        }
    }
}
