//
//  TABTabView.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//

import UIKit

class TABTabView: UIControl, UIDragInteractionDelegate {
	let dividerView = PSTLHairlineDividerView()

	var tabController:TABTabbedViewController?
	
	var tabButtons:[UIButton] = []
	var selectedIndex = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	var viewControllers: [UIViewController]? {
		willSet {
			tabButtons.forEach({
				$0.removeFromSuperview()
			})
			
			tabButtons.removeAll()
		}
		didSet {
			guard let viewControllers = viewControllers else { return }
			
			var i = 0
			viewControllers.forEach({
				
				let button = TABTabButton()
				button.setTitle($0.title, for: .normal)
				
				let img = UIImage(systemName: "command.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFloat(16)))
				
				button.setImage(img, for: .normal)
				button.imageEdgeInsets = UIEdgeInsets(top: UIFloat(1), left: 0, bottom: 0, right: UIFloat(4))

				button.tag = i
				button.closeButton.tag = i
				button.addTarget(self, action: #selector(tabSelected(_:)), for: .touchUpInside)
				button.closeButton.addTarget(self, action: #selector(closeTab(_:)), for: .touchUpInside)
				
				
				let dragInteraction = UIDragInteraction(delegate: self)
				button.addInteraction(dragInteraction)
				
				tabButtons.append(button)
				addSubview(button)
				
				i += 1
			})
			
			let newButton = TABTabNewButton()
			newButton.addTarget(self, action: #selector(newTab(_:)), for: .touchUpInside)
			tabButtons.append(newButton)
			addSubview(newButton)
			
			layoutSubviews()
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		selectedIndex = 0
		
		dividerView.dividerColor = .separator.withAlphaComponent(0.1)
		dividerView.borderMask = [.bottom]
		dividerView.isUserInteractionEnabled = false
		
		addSubview(dividerView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func tabSelected(_ sender:UIButton) {
		
		selectedIndex = sender.tag
		
		sendActions(for: .valueChanged)
	}
	
	@objc func closeTab(_ sender:UIButton) {
		
		tabController?.closeTabAtIndex(sender.tag)
	}
	
	@objc func newTab(_ sender:UIButton) {
		
		tabController?.newTab(sender)
	}
	
	override func layoutSubviews() {
		let minTabWidth = UIFloat(150)
		let newButtonWidth = UIFloat(40)
		var tabWidth = (bounds.width-newButtonWidth) / CGFloat(viewControllers?.count ?? 1)
		
		if tabWidth < minTabWidth {
			tabWidth = minTabWidth
		}
		
		var currentX = safeAreaInsets.left
		var i = 0
		
		tabButtons.forEach({
			
			if $0.tag != 0xff {
				$0.frame = CGRect(x: currentX, y: safeAreaInsets.top, width: tabWidth, height: bounds.height-safeAreaInsets.top)

				if selectedIndex == i {
					$0.backgroundColor = .clear
					$0.alpha = 1
				}
				else {
					$0.backgroundColor = .systemFill
					$0.alpha = 0.7
				}
			}
			else {
				$0.frame = CGRect(x: currentX, y: safeAreaInsets.top, width: newButtonWidth, height: bounds.height-safeAreaInsets.top)

			}
			
			currentX += tabWidth
			i += 1
			
		})
		
		dividerView.frame = bounds
	}
	
	// MARK: -
	
	func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
		let userActivity = NSUserActivity(activityType: "com.highcaffeinecontent.test")
		
		let itemProvider = NSItemProvider(item: NSString(""), typeIdentifier: "Test")
		itemProvider.registerObject(userActivity, visibility: .all)
		
		return [UIDragItem(itemProvider: itemProvider)]
	}
	
	func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
		guard let button = interaction.view as? UIButton else { return }
		viewControllers?.remove(at: button.tag)
	}
	
	func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
		if operation == .cancel {
			viewControllers = tabController?.viewControllers
		}
	}	
}
