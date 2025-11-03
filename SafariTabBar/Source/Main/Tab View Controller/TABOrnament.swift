//
//  TABOrnament.swift
//  SafariTabBar
//
//  Created by Steven Troughton-Smith on 03/08/2023.
//

import SwiftUI

struct UIViewWrapper: UIViewRepresentable {
	var view:UIView
	func makeUIView(context: Context) -> some UIView {
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}

#if os(xrOS)
struct TABOrnament: View {
	@State var isExpanded = false
	var contentView:UIView
	
	var body: some View {
		VStack {
			UIViewWrapper(view: contentView)
				.frame(width: UIFloat(640), height: UIFloat(140))
				.glassBackgroundEffect(in: RoundedRectangle(cornerRadius: UIFloat(35)))
				.hoverEffect(AddressBarRevealEffect())
				
			Spacer(minLength: UIFloat(50))
			
		}
		.frame(width: UIFloat(640), height: UIFloat(140+50))
	}
}

struct AddressBarRevealEffect: CustomHoverEffect {
	func body(content: Content) -> some CustomHoverEffect {
		content.hoverEffect { effect, isActive, proxy in
			effect.animation(.spring.delay(isActive ? 0.2 : 0.8)) { _ in
				effect.clipShape(RoundedRectangle(cornerRadius: UIFloat(35)).size(
					width: proxy.size.width,
					height: isActive ? UIFloat(140) : UIFloat(70),
					anchor: .top
				))
			}
		}
	}
}

#endif
