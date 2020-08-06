//
//  LottieView.swift
//  LottieTest
//
//  Created by Xiangyu Wang on 7/27/20.
//

import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
    
    var name: String
    @Binding var play: Bool
    var animationView = AnimationView()
    var complete: (Bool) -> Void = {_ in}
    

    public init(name: String, play: Binding<Bool>, complete: @escaping (Bool) -> Void = {_ in}) {
        self.name = name
        self._play = play
        self.complete = complete
    }
    
    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        animationView.animation = Animation.named(name)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if self.play {
            animationView.play { (result) in
                if result {
                    self.play = false
                }
                self.complete(result)
            }
        } else {
            animationView.pause()
        }
        
    }

}

public extension LottieView {
    func setContentMode(mode: UIView.ContentMode) -> LottieView {
        self.animationView.contentMode = mode
        return self
    }
    
    func setLoopMode(mode: LottieLoopMode) -> LottieView {
        self.animationView.loopMode = mode
        return self
    }
    
    func setSpeed(speed: CGFloat) -> LottieView {
        self.animationView.animationSpeed = speed
        return self
    }
}

public extension LottieView {
    class Coordinator: NSObject {
        var parent: LottieView
    
        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

