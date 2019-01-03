//
//  ViewController.swift
//  CardView
//
//  Created by 沈維庭 on 2019/1/3.
//  Copyright © 2019年 沈維庭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum CardState {
        case expanded
        case collapsed
    }
    
    private var cardViewController: CardViewController!
    private var visualEffectView: UIVisualEffectView!
    private var cardHeight: CGFloat {
        return self.view.bounds.height * 0.9
    }
    private var cardHandleAreaHeight: CGFloat = 65
    private var cardVisible: Bool = false
    private var nextState: CardState {
        return self.cardVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupCard()
    }

    private func setupCard() {
        self.visualEffectView = UIVisualEffectView()
        self.visualEffectView.frame = self.view.frame
        self.view.addSubview(self.visualEffectView)
        
        self.cardViewController = CardViewController()
        self.cardViewController.view.clipsToBounds = true
        self.addChild(self.cardViewController)
        self.view.addSubview(self.cardViewController.view)
        
        self.cardViewController.view.frame = CGRect(
            x: 0,
            y: self.view.frame.height - self.cardHandleAreaHeight,
            width: self.view.bounds.width,
            height: self.cardHeight)
        
        self.cardViewController.view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
        )
        
        self.cardViewController.view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleCardPan(recognizer:)))
        )
    }

    @objc private func handleCardTap(recognizer: UITapGestureRecognizer) {
        
    }
    
    @objc private func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // startTransition
            self.startInteractiveTransition(state: self.nextState, duration: 0.9)
        case .changed:
            // updateTransition
            let translation = recognizer.translation(in: self.cardViewController.headerView)
            var fractionComplete = translation.y / self.cardHeight
            fractionComplete = self.cardVisible ? fractionComplete : -fractionComplete
            
            self.updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // continueTransition
            self.continueInteractiveransition()
        default: break
        }
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if self.runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
                if !self.cardVisible {
                    self.cardViewController.willMove(toParent: nil)
                    self.cardViewController.view.removeFromSuperview()
                    self.cardViewController.removeFromParent()
                    self.cardViewController.remove()
                }
            }
            
            frameAnimator.startAnimation()
            self.runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            self.runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            blurAnimator.startAnimation()
            self.runningAnimations.append(blurAnimator)
        }
    }
    
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if self.runningAnimations.isEmpty {
            self.animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in self.runningAnimations {
            animator.pauseAnimation()
            self.animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in self.runningAnimations {
            animator.fractionComplete = fractionCompleted + self.animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveransition() {
        for animator in self.runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

