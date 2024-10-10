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
    private var vertexBuffer: MTLBuffer
    private var indexBuffer: MTLBuffer
    private var indices: [UInt16]
    private var aspectRatio: Float = 0
    private var depthStencilState: MTLDepthStencilState
    
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

        // Set stride (size of each vertex)
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        return vertexDescriptor
    }
    
    init(device: MTLDevice) {
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

        self.indices = [
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
        
        self.vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride, options: []
        )!
        
        self.indexBuffer = device.makeBuffer(
            bytes: indices,
            length: indices.count * MemoryLayout<UInt16>.stride,
            options: []
        )!
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less    // Keep fragments closer to the camera
        depthStencilDescriptor.isDepthWriteEnabled = true      // Enable writing to the depth buffer

        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        super.init()
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

        let camera = Camera(
            position: SIMD3<Float>(0, 0, 5),
            target: SIMD3<Float>(0, 0, 0),
            up: SIMD3<Float>(0, 1, 0)
        )

        let modelMatrix = modelMatrix(translation: SIMD3(0, 0, 0), rotation: SIMD3(0, 0, 0), scale: SIMD3(1, 1, 1))

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

        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )

        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
