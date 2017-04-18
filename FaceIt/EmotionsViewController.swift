//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 05/03/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class EmotionsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	// MARK:  - Model
	
	private var emotionalFaces: [(name: String, expression: FacialExpression)] = [
		("sad", FacialExpression(eyes: .closed, mouth: .frown)),
		("happy", FacialExpression(eyes: .open, mouth: .smile)),
		("worried", FacialExpression(eyes: .open, mouth: .smirk))
	]
	
	@IBAction func addEmotionalFace(from segue: UIStoryboardSegue) {
		if let editor = segue.source as? ExpressionEditorViewController {
			emotionalFaces.append((editor.name, editor.expression))
			tableView.reloadData()
		}
	}

	// MARK: - UITableViewDataSource methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return emotionalFaces.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
		cell.textLabel?.text = emotionalFaces[indexPath.row].name
		return cell
	}
	
	// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let faceViewController = segue.destination.contentViewController as? FaceViewController,
            let cell = sender as? UITableViewCell,
			let indexPath = tableView.indexPath(for: cell)
        {
            faceViewController.expression = emotionalFaces[indexPath.row].expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
		} else if segue.destination.contentViewController is ExpressionEditorViewController {
			if let popoverPresentationController = segue.destination.popoverPresentationController {
				popoverPresentationController.delegate = self
			}
		}
    }
	
	func adaptivePresentationStyle(for controller: UIPresentationController,
	                               traitCollection: UITraitCollection) -> UIModalPresentationStyle
	{
		if traitCollection.verticalSizeClass == .compact {
			return .none
		} else if traitCollection.horizontalSizeClass == .compact {
			return .overFullScreen
		} else {
			return .none
		}
	}
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let vc = self as? UINavigationController {
            return vc.visibleViewController!
        } else {
            return self
        }
    }
}
