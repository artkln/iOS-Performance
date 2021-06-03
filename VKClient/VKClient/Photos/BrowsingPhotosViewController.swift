//
//  BrowsingPhotosViewController.swift
//  VK Client
//
//  Created by Артём Калинин on 07.04.2021.
//

import UIKit

class BrowsingPhotosViewController: UIViewController {

    var browsingPhotos: [UIImage] = []
    var selectedIndex: Int = 0
    var swipeAnimator: UIViewPropertyAnimator!
    var tempImageView: UIImageView!
    @IBOutlet weak var browsingPhotosView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browsingPhotosView.image = browsingPhotos[selectedIndex]
        browsingPhotosView.backgroundColor = view.backgroundColor
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        
        case .began:
            if recognizer.velocity(in: view).x < 0 {
                guard browsingPhotos.count > selectedIndex + 1 else { return }
                
                tempImageView = UIImageView()
                let nextImage = browsingPhotos[selectedIndex + 1]
                tempImageView.contentMode = .scaleAspectFit
                tempImageView.backgroundColor = view.backgroundColor
                tempImageView.image = nextImage
                tempImageView.frame = browsingPhotosView.frame
                tempImageView.frame.origin.x += (browsingPhotosView.frame.width - tempImageView.frame.origin.x)
                view.addSubview(tempImageView)
                
                swipeAnimator?.startAnimation()
                leftSwipeAnimation(nextImage)
                swipeAnimator.pauseAnimation()
            } else {
                guard selectedIndex > 0 else { return }
                
                tempImageView = UIImageView()
                let nextImage = browsingPhotos[selectedIndex - 1]
                tempImageView.contentMode = .scaleAspectFit
                tempImageView.backgroundColor = view.backgroundColor
                tempImageView.image = nextImage
                tempImageView.frame = browsingPhotosView.frame
                tempImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                view.addSubview(tempImageView)
                view.sendSubviewToBack(tempImageView)
                
                swipeAnimator?.startAnimation()
                rightSwipeAnimation(nextImage)
                swipeAnimator.pauseAnimation()
            }
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            swipeAnimator.fractionComplete = abs(translation.x) / 100
            
        case .ended:
            let translation = recognizer.translation(in: self.view)
            
            if recognizer.velocity(in: view).x < 0 && abs(translation.x / 100) > 0.5
            || recognizer.velocity(in: view).x > 0 && abs(translation.x / 100) > 0.25 {
                    swipeAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    swipeAnimator.stopAnimation(true)
                    swipeAnimator.addAnimations {
                        if recognizer.velocity(in: self.view).x < 0 {
                            self.tempImageView.frame.origin.x += self.view.frame.width
                            self.browsingPhotosView.transform = .identity
                        } else {
                            self.tempImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            self.browsingPhotosView.transform = .identity
                        }
                    }
                    
                    swipeAnimator.startAnimation()
                }
        default: return
        }
    }
    
    func leftSwipeAnimation(_ nextImage: UIImage) {
        swipeAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .linear) {
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                    self.browsingPhotosView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5) {
                    self.tempImageView.frame.origin.x = 0
                }
            }
            
            self.swipeAnimator.addCompletion() { _ in
                self.browsingPhotosView.image = nextImage
                self.browsingPhotosView.transform = .identity
                self.selectedIndex += 1
                self.tempImageView.removeFromSuperview()
            }
        }
    }
    
    func rightSwipeAnimation(_ nextImage: UIImage) {
        swipeAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .linear) {
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.browsingPhotosView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                    self.tempImageView.transform = .identity
                }
            }
            
            self.swipeAnimator.addCompletion() { _ in
                self.browsingPhotosView.image = nextImage
                self.browsingPhotosView.transform = .identity
                self.selectedIndex -= 1
                self.tempImageView.removeFromSuperview()
            }
        }
    }
}
