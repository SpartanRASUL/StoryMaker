//
//  Types.swift
//  MetalEditorTest
//
//  Created by Rasul on 28.12.2020.
//

import Foundation
import simd

enum Easing {
    case linear, easeIn, easeOut, easeInOut
}

struct ModelConstants{
    var modelMatrix = matrix_identity_float4x4
}
