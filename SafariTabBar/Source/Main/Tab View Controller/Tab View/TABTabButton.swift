//
//  TABTabButton.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 23/09/2021.
//

import UIKit

class TABTabButton: UIButton {
	let dividerView = PSTLHairlineDividerView()
	let closeButton = UIButton()
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .secondarySystemFill
		setTitleColor(.label, for: .normal)
		titleLabel?.font = .boldSystemFont(ofSize: UIFloat(13))
		
		adjustsImageWhenHighlighted = false
		
		dividerView.dividerColor = .systemFill
		dividerView.borderMask = [.right]
		dividerView.isUserInteractionEnabled = false
	
		closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
		closeButton.tintColor = .secondaryLabel
		
		addSubview(dividerView)
		addSubview(closeButton)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let padding = UIFloat(4)
		let closeSize = bounds.height-padding*2
		
		dividerView.frame = bounds
		
		closeButton.frame = CGRect(x: padding, y: padding, width: closeSize, height: closeSize)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		dividerView.dividerColor = .systemFill
		dividerView.setNeedsDisplay()
	}
	
}
