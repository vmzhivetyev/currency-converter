//
//  DatePickerView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
	
	let label = UILabel()
	let textField = UITextField()
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addSubview(self.label)
		self.addSubview(self.textField)
		
		self.label.mas_makeConstraints { (make) in
			make?.bottom.left()?.top()?.equalTo()(self)
			make?.right.equalTo()(self.textField.mas_left)
		}
		
		self.textField.mas_makeConstraints { (make) in
			make?.top.right()?.bottom()?.equalTo()(self)
		}
		
		self.label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		self.textField.textAlignment = .right
		
		
		// DEBUG
		self.label.backgroundColor = .black
		self.textField.backgroundColor = .blue
		self.label.text = "LABEL"
		self.textField.text = "FIELD"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
