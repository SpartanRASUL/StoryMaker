//
//  Renderer.swift
//  Metal
//
//  Created by Rasul on 26.12.2020.
//

import MetalKit
import Metal

// For now i will use simplest form of renderer, without doing
// some architecture and other stuff. Refactoring is for later

final class Renderer {
    private(set) var config: RenderConfig
    var renderables: [Renderable] = []

    init?() {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let queue = device.makeCommandQueue()
        else {
            return nil
        }
        config = RenderConfig(device: device)
        commandQueue = queue
        self.device = device
    }

    func draw(renderPass: MTLRenderPassDescriptor, drawable: CAMetalDrawable) {
        for renderable in renderables {
            guard let buffer = commandQueue.makeCommandBuffer() else {
                assertionFailure("Can't create new command buffer")
                continue
            }
            let context = RenderContext(
                buffer: buffer,
                renderPass: renderPass,
                outTexture: drawable.texture,
                device: config.device
            )
            renderable.draw(in: context)
        }
        drawable.present()
    }

    private let commandQueue: MTLCommandQueue
    private let device: MTLDevice
}

struct RenderContext {
    let buffer: MTLCommandBuffer
    let renderPass: MTLRenderPassDescriptor
    let outTexture: MTLTexture
    let device: MTLDevice
}

protocol Renderable {
    init?(config: RenderConfig)
    func draw(in context: RenderContext)
}
