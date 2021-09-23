//
//  TABTabbedViewController.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//

import UIKit

class TABTabbedViewController: UIViewController {
	
	let tabBar = TABTabView()
	let toolbar = UIToolbar()
	let effectView = PSTLVisualEffectView(blurStyle: .systemChromeMaterial)

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
		
		view.addSubview(effectView)
		
		toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
		toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
		
		let urlField = TABVibrantTextField(blurEffect: effectView.contentEffectView.effect!)

		let urlFieldItem = UIBarButtonItem(customView: urlField)
		
		toolbar.items = [UIBarButtonItem(systemItem: .bookmarks, primaryAction: nil, menu: nil), .flexibleSpace(), urlFieldItem, .flexibleSpace(), UIBarButtonItem(systemItem: .search, primaryAction: nil, menu: nil)]
		
		tabBar.tabController = self
		tabBar.addTarget(self, action: #selector(tabSelected(_:)), for: .valueChanged)
		
		effectView.contentView.addSubview(toolbar)
		effectView.contentView.addSubview(tabBar)
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
		
		let tabBarHeight = UIFloat(36)
		let toolbarHeight = UIFloat(44)

		super.viewDidLayoutSubviews()
		
		guard let viewControllers = viewControllers else { return }
		
		let viewBounds = view.bounds
		
		effectView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: viewBounds.width, height: toolbarHeight+tabBarHeight+view.safeAreaInsets.top)
		
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
			//CGRect(x: safeFrame.minX, y: view.safeAreaInsets.top+safeFrame.minY+tabBarHeight, width: safeFrame.width, height: safeFrame.height-tabBarHeight-view.safeAreaInsets.top)
			
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
	
	func newTab(_ sender:UIButton) {
		guard var viewControllers = viewControllers else { return }
		guard let viewControllerClassForNewTabs = viewControllerClassForNewTabs else { return }
		
		viewControllers.append(viewControllerClassForNewTabs.init())
		selectedIndex = viewControllers.count-1
		tabBar.selectedIndex = selectedIndex
		
		self.viewControllers = viewControllers
	}
}
