//
//  ViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 27/02/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()      // called only ones, when iOS hooks up this faceView
        }
    }
	
	
	private struct HeadShake
	{
		static let angle = CGFloat.pi/6                 // radians
		static let segmentDuration: TimeInterval = 0.5  // each head shake has 3 segments
	}
	private func rotateFace(by angle: CGFloat)
	{
		faceView.transform = faceView.transform.rotated(by: angle)
	}
	
	private func shakeHead() {
		UIView.animate(
			withDuration: HeadShake.segmentDuration,
			animations: { self.rotateFace(by: HeadShake.angle) },
			completion: { finished in
				if finished {
					UIView.animate(
						withDuration: HeadShake.segmentDuration,
						animations: { self.rotateFace(by: -HeadShake.angle * 2) },
						completion: { finished in
							if finished {
								UIView.animate(
									withDuration: HeadShake.segmentDuration,
									animations: { self.rotateFace(by: HeadShake.angle) }
								)
							}
						}
					)
				}
			}
		)
	}
	
	
	
	@IBAction func shakeHead(_ sender: UITapGestureRecognizer)
	{	shakeHead()
	}

    func increaseHappiness()
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    @IBAction private func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = expression.eyes == .closed ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }

    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI()
        }
    }
    
	func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true   // optional chaining, in case faceView is not yet set.
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
//            faceView?.eyesOpen = false
			break
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }

    private let mouthCurvatures: [FacialExpression.Mouth: Double] = [
        .frown: -1.0, .smirk: -0.5, .neutral: 0.0, .grin: 0.5, .smile: 1.0
    ]
    
}

