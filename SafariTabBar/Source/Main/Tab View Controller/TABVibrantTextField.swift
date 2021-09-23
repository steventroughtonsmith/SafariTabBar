//
//  TABTextField.swift
//  SafariTabBar
//
//  Created by Steven Troughton-Smith on 23/09/2021.
//

import UIKit

class TABVibrantTextField: UIView, UITextFieldDelegate {
	
	var effectView:UIVisualEffectView! = UIVisualEffectView()
	let backgroundView = UIView()
	
	let textField = UITextField()
	let fakeTextField = UITextField()

	init(blurEffect:UIVisualEffect) {
		super.init(frame: .zero)
				
		effectView = UIVisualEffectView(effect: blurEffect)
		addSubview(effectView)
		
		layer.cornerCurve = .continuous
		layer.cornerRadius = UIFloat(10)
		layer.masksToBounds = true
		
		fakeTextField.borderStyle = .none
		backgroundView.backgroundColor = .systemBackground.withAlphaComponent(0.15)
		backgroundView.layer.cornerCurve = .continuous
		backgroundView.layer.cornerRadius = UIFloat(10)
		backgroundView.isUserInteractionEnabled = false

		textField.text = "https://www.apple.com"
		textField.borderStyle = .none
		textField.backgroundColor = .clear
		textField.delegate = self
		
		backgroundView.addSubview(fakeTextField)
		effectView.contentView.addSubview(backgroundView)
		addSubview(textField)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		effectView.frame = bounds
		backgroundView.frame = bounds
		
		let insetFrame = effectView.bounds.insetBy(dx: UIFloat(8), dy: 0)
		
		textField.frame = insetFrame
		fakeTextField.frame = insetFrame
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: UIFloat(800), height: UIFloat(36))
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		fakeTextField.placeholder = ""
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text == "" {
			fakeTextField.placeholder = "Search or enter website name"
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
