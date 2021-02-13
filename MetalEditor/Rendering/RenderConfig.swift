//
//  RenderViewConfigurator.swift
//  Metal
//
//  Created by Rasul on 26.12.2020.
//

import MetalKit

struct RenderConfig {
    let device: MTLDevice
    let pixelFormat: MTLPixelFormat
    let clearColor: MTLClearColor
    let preferredFrameRate: Int = 60

    init(device: MTLDevice) {
        self.device = device
        pixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0, green: 0.7, blue: 1, alpha: 1)
    }

    init(device: MTLDevice, pixelFormat: MTLPixelFormat, clearColor: MTLClearColor) {
        self.device = device
        self.pixelFormat = pixelFormat
        self.clearColor = clearColor
    }
}

extension MTKView {
    func apply(config: RenderConfig) {
        device = config.device
        colorPixelFormat = config.pixelFormat
        clearColor = config.clearColor
        preferredFramesPerSecond = config.preferredFrameRate
    }
}
