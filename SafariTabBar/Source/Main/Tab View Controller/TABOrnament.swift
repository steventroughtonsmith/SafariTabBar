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
				.frame(width: UIFloat(640), height: isExpanded ? UIFloat(140) : UIFloat(70))
				.glassBackgroundEffect(in: RoundedRectangle(cornerRadius: UIFloat(35)))
				.onHover { hovered in
					withAnimation(.interactiveSpring(duration:0.3)) {
						isExpanded = hovered
					}
				}
			Spacer(minLength: UIFloat(50))
			
		}
		.frame(width: UIFloat(640), height: UIFloat(140+50))
	}
}
#endif
