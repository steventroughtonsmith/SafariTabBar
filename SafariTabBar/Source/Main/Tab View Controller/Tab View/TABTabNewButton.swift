//
//  TABTabNewButton.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 23/09/2021.
//

import UIKit

class TABTabNewButton: UIButton {
	
	init() {
		super.init(frame: .zero)
		
		backgroundColor = .secondarySystemFill
		
		setImage(UIImage(systemName: "plus"), for: .normal)
		tintColor = .secondaryLabel
		tag = 0xff
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
