//
//  Common.h
//  MetalEditorTest
//
//  Created by Rasul on 03.01.2021.
//

#include <metal_stdlib>
using namespace metal;

typedef struct {
    float4 position [[position]];
    float2 textureCoordinate;
} TextureVertex;
