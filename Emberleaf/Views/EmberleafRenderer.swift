//
//  EmberleafRenderer.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//
import SwiftUI

struct EmberleafRenderer: View {
    @WorldBuilder var world: () -> World
    
    var body: some View {
        MetalView(world: world())
    }
}
