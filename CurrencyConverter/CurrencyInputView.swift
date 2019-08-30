//
//  CurrencyInputView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit
import Masonry


class CurrencyInputView : UIView {
	
	let sumTextField = UITextField()
	let currencyCodeTextField = UITextField()
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addSubview(self.sumTextField)
		self.addSubview(self.currencyCodeTextField)
		
		self.sumTextField.mas_makeConstraints { (make) in
			make?.bottom.left()?.top()?.equalTo()(self)
			make?.right.equalTo()(self.currencyCodeTextField.mas_left)
		}
		
		self.currencyCodeTextField.mas_makeConstraints { (make) in
			make?.top.right()?.bottom()?.equalTo()(self)
			make?.width.equalTo()(70)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
