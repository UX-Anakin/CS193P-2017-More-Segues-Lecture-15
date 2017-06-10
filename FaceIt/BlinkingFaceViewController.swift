//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 10/04/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController
{
	var blinking = false {
		didSet {
			blinkIfNeeded()
		}
	}
	
	override func updateUI() {
		super.updateUI()
		blinking = expression.eyes == .squinting
	}
	
	private struct BlinkRate {
		static let closedDuration: TimeInterval = 0.4
		static let openDuration: TimeInterval = 2.5
	}
	
	private var canBlink = false
	private var inABlink = false // 'in a blink... we don't want to initiate 2 timers
	
	private func blinkIfNeeded()
	{
        if blinking && canBlink && !inABlink {
			faceView.eyesOpen = false
			inABlink = true
			Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
				self?.faceView.eyesOpen = true
				Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false) { [weak self] timer in
					self?.inABlink = false
					self?.blinkIfNeeded()
				}
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		canBlink = true
		blinkIfNeeded()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		canBlink = false
	}

}
