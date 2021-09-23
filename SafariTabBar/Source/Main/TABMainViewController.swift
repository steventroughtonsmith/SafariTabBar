//
//  TABMainViewController.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//  
//

import UIKit
import WebKit

extension UIColor {
	class func randomPastelColor() -> UIColor
	{
		return UIColor(red:(CGFloat((arc4random() % 130) + 125) / 255.0),
					   green:(CGFloat((arc4random() % 130) + 125) / 255.0),
					   blue:(CGFloat((arc4random() % 130) + 125) / 255.0),
					   alpha:1)
	}
}


final class TABMainViewController: UIViewController {
	
	let webView = WKWebView()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Testificate"

		webView.scrollView.contentInsetAdjustmentBehavior = .always
		webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
		
		webView.scrollView.contentOffset = .zero
		view.addSubview(webView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		webView.frame = view.bounds
	}
}
