//
//  LoadingView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 02/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit
import Masonry

class LoadingView: UIView {
	
	let loadingSpinner = UIActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupUI()
		self.setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		self.backgroundColor = .clear
		
		let blurEffect = UIBlurEffect(style: .regular)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.loadingSpinner.hidesWhenStopped = true
		self.loadingSpinner.style = .gray
		self.loadingSpinner.startAnimating()
		
		self.addSubview(blurEffectView)
		self.addSubview(self.loadingSpinner)
	}
	
	func setupConstraints() {
		self.loadingSpinner.mas_makeConstraints { (make) in
			make?.center.equalTo()(self)
			make?.width.height()?.equalTo()(30)
		}
	}
}
