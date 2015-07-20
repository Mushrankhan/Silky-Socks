//
//  SJAlphaAnimator.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 7/20/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import Foundation


class SJAlphaAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toVC = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let frame = fromVC.frame
        toVC.frame = frame
        toVC.alpha = 0.0
        containerView?.addSubview(toVC)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toVC.alpha = 0.9
        }) { success in
                transitionContext.completeTransition(true)
        }
    }
    
}