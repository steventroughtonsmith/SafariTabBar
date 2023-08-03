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
	
	enum State {
		case normal
		case selected
	}
	var tabState:State = .normal {
		didSet {
			UIView.animate(withDuration: 0.1) { [weak self] in
				
				
				if self?.tabState == .normal {
					self?.backgroundColor = .systemFill
					self?.setTitleColor(.label, for: .normal)
					self?.tintColor = .label
					self?.closeButton.tintColor = .secondaryLabel
					
					if UIDevice.current.userInterfaceIdiom == .reality {
						var img = UIImage(systemName: "xmark.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: UIFloat(32), weight: .light))
						img = img?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(hierarchicalColor: .secondaryLabel))
						
						self?.closeButton.setImage(img, for: .normal)
						self?.closeButton.alpha = 0
					}
					
				}
				else if self?.tabState == .selected {
					self?.backgroundColor = UIDevice.current.userInterfaceIdiom == .reality ? .white : .clear
					self?.setTitleColor(UIDevice.current.userInterfaceIdiom == .reality ? .black : .label, for: .normal)
					self?.tintColor = UIDevice.current.userInterfaceIdiom == .reality ? .black : .label
					self?.closeButton.tintColor = UIDevice.current.userInterfaceIdiom == .reality ? .black : .label
					
					if UIDevice.current.userInterfaceIdiom == .reality {
						var img = UIImage(systemName: "xmark.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: UIFloat(32), weight: .light))
						img = img?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(hierarchicalColor: .black))
						
						self?.closeButton.setImage(img, for: .normal)
						
						self?.closeButton.alpha = 1

					}
				}
			}
		}
	}
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .secondarySystemFill
		setTitleColor(.label, for: .normal)
		titleLabel?.font = .boldSystemFont(ofSize: UIFloat(13))
		
#if !os(xrOS)
		adjustsImageWhenHighlighted = false
#endif
		
		dividerView.dividerColor = .systemFill
		dividerView.borderMask = [.right]
		dividerView.isUserInteractionEnabled = false
		
		let symcfg = UIImage.SymbolConfiguration(hierarchicalColor: .secondaryLabel)
		closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: symcfg), for: .normal)
		closeButton.tintColor = .secondaryLabel
		
#if !os(xrOS)
		
		addSubview(dividerView)
#endif
		
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
		
#if os(xrOS)
		layer.cornerRadius = bounds.height / 2
#endif
	}
	
#if !os(xrOS)
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		dividerView.dividerColor = .systemFill
		dividerView.setNeedsDisplay()
	}
#endif
}
