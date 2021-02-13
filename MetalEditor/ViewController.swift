//
//  ViewController.swift
//  MetalEditor
//
//  Created by Rasul on 13.02.2021.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    private var metalView: MTKView!
    private var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRenderer()
        setupMetalView()
    }

    private func setupMetalView() {
        let metalView = MTKView()
        metalView.apply(config: renderer.config)
        metalView.delegate = self

        metalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(metalView)
        NSLayoutConstraint.activate([
            metalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            metalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            metalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            metalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.metalView = metalView
    }

    private func setupRenderer() {
        guard let renderer = Renderer() else {
            return
        }

        if let passthrough = ImagePassthroughRenderable(config: renderer.config) {
            passthrough.set(image: UIImage(named: "test")!)
            renderer.renderables.append(passthrough)
        }
        self.renderer = renderer
    }

}

extension ViewController: MTKViewDelegate {

    func draw(in view: MTKView) {
        guard
            let renderPass = view.currentRenderPassDescriptor,
            let drawable = view.currentDrawable
        else {
            print("dropped frame")
            return
        }
        renderer.draw(renderPass: renderPass, drawable: drawable)
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

}
