//
//  Common.h
//  MetalEditorTest
//
//  Created by Rasul on 03.01.2021.
//

#include <metal_stdlib>
using namespace metal;

struct TextureVertex {
    float4 position [[position]];
    float2 textureCoordinate;
};

struct ModelConstants {
    float4x4 modelMatrix;
};
