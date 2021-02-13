//
//  TextureVertex.swift
//  MetalEditorTest
//
//  Created by Rasul on 03.01.2021.
//

import simd
import Metal

struct TextureVertex {
    let position: SIMD3<Float>
    let textureCoordinate: SIMD2<Float>

    static func descriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0

        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size

        vertexDescriptor.layouts[0].stride = MemoryLayout<TextureVertex>.stride
        return vertexDescriptor
    }
}
