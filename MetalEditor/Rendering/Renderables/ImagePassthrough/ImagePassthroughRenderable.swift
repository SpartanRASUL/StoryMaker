//
//  LinearOverlayRenderable.swift
//  MetalEditorTest
//
//  Created by Rasul on 28.12.2020.
//

import MetalKit
import UIKit

final class ImagePassthroughRenderable: Renderable {

    init?(config: RenderConfig) {
        guard
            let library = config.device.makeDefaultLibrary(),
            let vertexFunc = library.makeFunction(name: "image_passthrough_vertex"),
            let fragmentFunc = library.makeFunction(name: "image_passthrough_fragment")
        else {
            assertionFailure("Can't initialize ImagePassthroughRenderable")
            return nil
        }

        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.fragmentFunction = fragmentFunc
        renderDescriptor.vertexFunction = vertexFunc
        renderDescriptor.colorAttachments[0].pixelFormat = config.pixelFormat

        renderDescriptor.vertexDescriptor = TextureVertex.descriptor()

        self.config = config

        do {
            let state = try config.device.makeRenderPipelineState(descriptor: renderDescriptor)
            renderState = state
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func draw(in context: RenderContext) {
        let renderEncoder = context.buffer.makeRenderCommandEncoder(descriptor: context.renderPass)
        renderEncoder?.setRenderPipelineState(renderState)

        guard let vertexBuffer = config.device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<TextureVertex>.stride * vertices.count,
            options: []
        ),
        let indexBuffer = config.device.makeBuffer(
            bytes: indices,
            length: MemoryLayout<UInt16>.size * indices.count,
            options: []
        ) else {
            print("Can't initialize buffers")
            return
        }

        if let texture = texture {
            renderEncoder?.setFragmentTexture(texture, index: 0)
        } else {
            print("Texture is either not set or failed to initialize")
        }
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        renderEncoder?.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )

        renderEncoder?.endEncoding()
        context.buffer.commit()
        context.buffer.waitUntilCompleted()
    }

    func set(image: UIImage) {
        let loader = MTKTextureLoader(device: config.device)
        let cgimage = image.cgImage!
        let texture = try? loader.newTexture(
            cgImage: cgimage,
            options: nil
        )

        self.texture = texture
    }

    //MARK: - Private

    private let config: RenderConfig

    private let renderState: MTLRenderPipelineState
    private let vertices: [TextureVertex] = [
        /*
         It works this way
         Textures works in Cartesian system, which means that 0.0 is in center.
         UV or texture coordinates works differently, which means that origin is either on top left, or bottom left.
         In iOS it's top left.

         UV (x, y)
         (0,0)--------(1,0)
         |              |
         |              |
         |              |
         (0,1)--------(1,1)

         */

        TextureVertex(position: SIMD3<Float>(-1, -1,  0), textureCoordinate: SIMD2<Float>(0, 1)), //Bottom Left
        TextureVertex(position: SIMD3<Float>(-1,  1,  0), textureCoordinate: SIMD2<Float>(0, 0)), //Top Left
        TextureVertex(position: SIMD3<Float>( 1,  1,  0), textureCoordinate: SIMD2<Float>(1, 0)), //Top Right
        TextureVertex(position: SIMD3<Float>( 1, -1,  0), textureCoordinate: SIMD2<Float>(1, 1)), //Bottom Right
    ]

    private let indices: [UInt16] = [
        0, 1, 2,
        0, 2, 3
    ]

    private var texture: MTLTexture?
}
