//
//  linear_overlay.metal
//  MetalEditorTest
//
//  Created by Rasul on 28.12.2020.
//

#include <metal_stdlib>
using namespace metal;

#include "../../Common/Common.h"

typedef struct {
    float3 position [[ attribute(0) ]];
    float2 textureCoordinate [[ attribute(1) ]];
} TextureVertexIn;


vertex TextureVertex image_passthrough_vertex(const TextureVertexIn vIn [[ stage_in ]],
                                              constant ModelConstants &constants [[ buffer(1) ]]) {
    TextureVertex vOut;
    vOut.position = constants.modelMatrix * float4(vIn.position, 1);
    vOut.textureCoordinate = vIn.textureCoordinate;
    return vOut;
}

fragment float4 image_passthrough_fragment(TextureVertex vIn [[ stage_in ]],
                                           texture2d<float> colorTexture [[ texture(0) ]]) {

    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);

    // Sample the texture to obtain a color
    const float4 colorSample = colorTexture.sample(textureSampler, vIn.textureCoordinate);

    return colorSample;
}
