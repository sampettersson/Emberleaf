//
//  MetalView.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/9/24.
//

import SwiftUI
import MetalKit

#if os(macOS)

struct MetalView: NSViewRepresentable {
    var device = MTLCreateSystemDefaultDevice()
    var world: World
    
    func makeNSView(context: Context) -> MTKView {
        MTKView(frame: .zero, device: device)
    }
    
    class Coordinator {
        let renderer: Renderer
        
        init(device: MTLDevice, world: World) {
            self.renderer = Renderer(device: device, world: world)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(device: device!, world: world)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.clearColor = MTLClearColorMake(0, 0, 0, 0)
        nsView.delegate = context.coordinator.renderer
        nsView.depthStencilPixelFormat = .depth32Float
        context.coordinator.renderer.updateWorld(world)
    }
}

#elseif os(iOS)

struct MetalView: UIViewRepresentable {
    var device = MTLCreateSystemDefaultDevice()
    
    func makeUIView(context: Context) -> MTKView {
        MTKView(frame: .zero, device: device)
    }
    
    class Coordinator {
        let renderer: Renderer
        
        init(device: MTLDevice) {
            self.renderer = Renderer(device: device)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(device: device!)
    }
    
    func updateUIView(_ view: MTKView, context: Context) {
        view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        view.delegate = context.coordinator.renderer
        view.depthStencilPixelFormat = .depth32Float
    }
}

#endif
