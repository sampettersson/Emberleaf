//
//  DemoView.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import SwiftUI

struct DemoView: View {
    @State var cameraPosition: Bool = false
    
    var body: some View {
        EmberleafRenderer {
            Camera(
                position: SIMD3<Float>(0, 0, cameraPosition ? 5 : 10),
                target: SIMD3<Float>(0, 0, 0),
                up: SIMD3<Float>(0, 1, 0)
            )
        }.overlay(alignment: .bottom) {
            Button("Move camera") {
                cameraPosition.toggle()
            }
        }
    }
}
