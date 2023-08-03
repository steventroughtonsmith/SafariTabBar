//
//  TABTabbedViewController.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//

import UIKit
import SwiftUI

class TABStackView: UIView {
	var arrangedSubviews:[UIView] = []
	var desiredHeight:CGFloat
	
	init(desiredHeight: CGFloat) {
		self.desiredHeight = desiredHeight
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	func addArrangedSubview(_ view:UIView) {
		arrangedSubviews.append(view)
		addSubview(view)
	}
	
	override func layoutSubviews() {
		let rowHeight = (arrangedSubviews.count == 1) ? bounds.height : (desiredHeight/CGFloat(arrangedSubviews.count))
		
		var y = CGFloat.zero
		var i = 0
		arrangedSubviews.forEach {
			
			$0.frame = CGRect(x: 0, y: y, width: bounds.width, height: rowHeight)
			i += 1
			y += rowHeight
		}
	}
}

class TABTabbedViewController: UIViewController {
	
	
	let tabBar = TABTabView()
	let toolbar = UIToolbar()
	let effectView = PSTLVisualEffectView(blurStyle: .systemChromeMaterial)
	
	let toolbarWrapper = TABStackView(desiredHeight: UIFloat(140))
	
	var viewControllerClassForNewTabs:UIViewController.Type?
	
	var selectedIndex = 0 {
		didSet {
			
		}
	}
	
	var viewControllers: [UIViewController]? {
		willSet {
			guard let viewControllers = viewControllers else { return }
			
			viewControllers.forEach({
				$0.view.removeFromSuperview()
				$0.removeFromParent()
			})
			
			tabBar.viewControllers = []
		}
		didSet {
			guard let viewControllers = viewControllers else { return }
			
			viewControllers.forEach({
				addChild($0)
				view.insertSubview($0.view, at: 0)
				$0.view.isHidden = true
			})
			
			tabBar.viewControllers = viewControllers
			
			view.setNeedsLayout()
		}
	}
	
	// MARK: -
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		let urlField = TABVibrantTextField(blurEffect: effectView.contentEffectView.effect!)
		
		if UIDevice.current.userInterfaceIdiom == .reality {
			
			let container = UIStackView()
			container.spacing = UIFloat(16)
						
			do {
				let button = UIButton(type: .system)
				button.configuration = .borderedProminent()
				
				button.setImage(UIImage(systemName: "book"), for: .normal)
				
				container.addArrangedSubview(button)
			}
			container.addArrangedSubview(urlField)
			
			do {
				let button = UIButton(type: .system)
				button.configuration = .borderedProminent()
				
				button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
				
				container.addArrangedSubview(button)
			}
			
			container.isLayoutMarginsRelativeArrangement = true
			container.directionalLayoutMargins = .init(top: UIFloat(13), leading: UIFloat(13), bottom: UIFloat(13), trailing: UIFloat(13))
			
			toolbarWrapper.addArrangedSubview(container)
			toolbarWrapper.addArrangedSubview(tabBar)
			
			setupOrnament()
		}
		else {
			effectView.contentView.addSubview(toolbar)
			effectView.contentView.addSubview(tabBar)
			
			toolbarWrapper.addArrangedSubview(effectView)
			view.addSubview(toolbarWrapper)
			toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
			toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
			
			
			let urlFieldItem = UIBarButtonItem(customView: urlField)
			
			toolbar.items = [UIBarButtonItem(systemItem: .bookmarks, primaryAction: nil, menu: nil), .flexibleSpace(), urlFieldItem, .flexibleSpace(), UIBarButtonItem(systemItem: .search, primaryAction: nil, menu: nil)]
			
		}
		
		
		tabBar.tabController = self
		tabBar.addTarget(self, action: #selector(tabSelected(_:)), for: .valueChanged)
		
		
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	@objc func tabSelected(_ sender:Any) {
		
		selectedIndex = tabBar.selectedIndex
		view.setNeedsLayout()
	}
	
	override func viewDidLayoutSubviews() {
		
		let tabBarHeight = UIDevice.current.userInterfaceIdiom == .reality ? UIFloat(60) : UIFloat(36)
		let toolbarHeight = UIFloat(44)
		
		super.viewDidLayoutSubviews()
		
		guard let viewControllers = viewControllers else { return }
		
		let viewBounds = view.bounds
		
		if UIDevice.current.userInterfaceIdiom == .reality {
			toolbarWrapper.frame = CGRect(x: 0, y: 0, width: UIFloat(640), height:UIFloat(140))
			
		} else {
			toolbarWrapper.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: viewBounds.width, height: toolbarHeight+tabBarHeight+view.safeAreaInsets.top)
		}
		
		effectView.frame = toolbarWrapper.bounds
		
		let division = effectView.bounds.divided(atDistance: tabBarHeight, from: .maxYEdge)
		
		toolbar.frame = CGRect(x: division.remainder.minX, y: division.remainder.minY+view.safeAreaInsets.top, width: division.remainder.width, height: division.remainder.height-view.safeAreaInsets.top)
		tabBar.frame = division.slice
		
		var i = 0
		viewControllers.forEach({
			
			$0.additionalSafeAreaInsets = UIEdgeInsets(top: toolbarHeight+tabBarHeight, left: 0, bottom: 0, right: 0)
			
			if i == selectedIndex {
				$0.view.isHidden = false
			}
			else  {
				$0.view.isHidden = true
			}
			
			$0.view.frame = view.bounds
			
			i += 1
		})
	}
	
	func closeTabAtIndex(_ index:Int) {
		guard var viewControllers = viewControllers else { return }
		
		viewControllers.remove(at: index)
		
		if selectedIndex > viewControllers.count-1 {
			selectedIndex = viewControllers.count-1
			tabBar.selectedIndex = selectedIndex
		}
		
		self.viewControllers = viewControllers
	}
	
	@objc func newTab(_ sender:UIButton) {
		guard var viewControllers = viewControllers else { return }
		guard let viewControllerClassForNewTabs = viewControllerClassForNewTabs else { return }
		
		viewControllers.append(viewControllerClassForNewTabs.init())
		selectedIndex = viewControllers.count-1
		tabBar.selectedIndex = selectedIndex
		
		self.viewControllers = viewControllers
	}
	
#if os(xrOS)
	override var preferredContainerBackgroundStyle: UIContainerBackgroundStyle {
		return .glass
	}
#endif
	class OrnamentViewModel : ObservableObject {
		@Published var isExpanded: Bool = false
		
		
	}
	
	func setupOrnament() {
#if os(xrOS)
		let ornament = UIHostingOrnament(sceneAlignment: .top, contentAlignment: .center) {
			TABOrnament(contentView: toolbarWrapper)
		}
		
		ornaments = [ornament]
#endif
	}

	// MARK: -
	
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(newTab(_:)))]
	}
}
