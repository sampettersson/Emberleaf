//
//  Renderer.swift
//  Emberleaf
//
//  Created by Sam Pettersson on 10/10/24.
//

import MetalKit

struct Uniforms {
    var modelMatrix: matrix_float4x4
    var viewMatrix: matrix_float4x4
    var projectionMatrix: matrix_float4x4
}

class Renderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var pipelineState: MTLRenderPipelineState
    private var aspectRatio: Float = 0
    private var depthStencilState: MTLDepthStencilState
    private var world: World
    
    static func createVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()

        // Position attribute (index 0)
        vertexDescriptor.attributes[0].format = .float3    // Each position is a 3-component float (SIMD3<Float>)
        vertexDescriptor.attributes[0].offset = 0          // Starts at the beginning of the vertex
        vertexDescriptor.attributes[0].bufferIndex = 0     // This corresponds to the vertex buffer

        // Color attribute (index 1)
        vertexDescriptor.attributes[1].format = .float4    // Each color is a 4-component float (SIMD4<Float>)
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride  // Offset by the size of the position
        vertexDescriptor.attributes[1].bufferIndex = 0     // Same vertex buffer
        
        // Normal attribute (index 2)
        vertexDescriptor.attributes[2].format = .float3    // Each color is a 3-component float (SIMD3<Float>)
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride  // Offset by the size of the position
        vertexDescriptor.attributes[2].bufferIndex = 0     // Same vertex buffer

        // Set stride (size of each vertex)
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        return vertexDescriptor
    }
    
    init(device: MTLDevice, world: World) {
        self.device = device
        
        self.commandQueue = device.makeCommandQueue()!

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertex_main")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragment_main")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        pipelineDescriptor.vertexDescriptor = Self.createVertexDescriptor()

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less    // Keep fragments closer to the camera
        depthStencilDescriptor.isDepthWriteEnabled = true      // Enable writing to the depth buffer

        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        self.world = world
        
        super.init()
    }
    
    func updateWorld(_ world: World) {
        self.world = world
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        aspectRatio = Float(size.width / size.height)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        let commandBuffer = commandQueue.makeCommandBuffer()

        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        renderPassDescriptor?.depthAttachment.clearDepth = 1.0
        renderPassDescriptor?.depthAttachment.loadAction = .clear
        renderPassDescriptor?.depthAttachment.storeAction = .store

        guard let renderPassDescriptor else {
            return
        }

        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setDepthStencilState(depthStencilState)

        renderEncoder?.setViewport(MTLViewport(
            originX: 0,
            originY: 0,
            width: Double(view.drawableSize.width),
            height: Double(view.drawableSize.height),
            znear: 0,
            zfar: 1
        ))
        
        let (_, cube, transform) = world.query(with: Cube.self, Transform.self)!

        let modelMatrix = modelMatrix(translation: transform.translation, rotation: transform.rotation, scale: transform.scale)
        
        let (_, camera) = world.query(with: Camera.self)!

        let viewMatrix = camera.viewMatrix()
        let aspectRatio = Float(view.drawableSize.width / view.drawableSize.height)
        let projectionMatrix = camera.projectionMatrix(
            aspectRatio: aspectRatio,
            fov: radians_from_degrees(65),
            nearPlane: 0.1,
            farPlane: 100
        )

        var uniforms = Uniforms(modelMatrix: modelMatrix, viewMatrix: viewMatrix, projectionMatrix: projectionMatrix)
        renderEncoder?.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        renderEncoder?.setCullMode(.none)
        
        if let (_, light, transform) = world.query(with: Light.self, Transform.self) {
            var resolvedLight = ResolvedLight(light, transform)
            
            renderEncoder?.setVertexBytes(&resolvedLight, length: MemoryLayout<ResolvedLight>.stride, index: 2)
            renderEncoder?.setFragmentBytes(&resolvedLight, length: MemoryLayout<ResolvedLight>.stride, index: 2)
        }
                
        let vertexBuffer = device.makeBuffer(
            bytes: cube.vertices,
            length: cube.vertices.count * MemoryLayout<Vertex>.stride, options: []
        )!
        
        let indexBuffer = device.makeBuffer(
            bytes: cube.indices,
            length: cube.indices.count * MemoryLayout<UInt16>.stride,
            options: []
        )!

        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawIndexedPrimitives(
            type: .triangle,
            indexCount: cube.indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )

        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
