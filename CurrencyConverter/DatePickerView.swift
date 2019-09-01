//
//  DatePickerView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
	
	weak var delegate : DatePickerViewDelegate?
	
	var pickedDate : Date {
		get {
			return self.datePicker.date
		}
		set {
			self.datePicker.setDate(newValue, animated: true)
			self.displaySelectedDate()
		}
	}
	
	var minimumDate : Date? {
		get {
			return self.datePicker.minimumDate
		}
		set {
			self.datePicker.minimumDate = newValue
		}
	}
	
	var maximumDate : Date? {
		get {
			return self.datePicker.maximumDate
		}
		set {
			self.datePicker.maximumDate = newValue
		}
	}
	
	let label = UILabel()
	let textField = UITextField()
	let datePicker = UIDatePicker()
	
	let dateFormatter : DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale.current
		formatter.dateStyle = .long
		return formatter
	}()
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupUI()
		self.setupConstraints()
		
		// DEBUG
		self.label.backgroundColor = .clear
		self.textField.backgroundColor = .clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		self.label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		self.label.text = "Дата"
		
		self.textField.placeholder = "Выберите дату"
		self.textField.tintColor = .clear
		self.textField.textAlignment = .right
		self.textField.inputView = self.datePicker
		self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
		
		self.addSubview(self.label)
		self.addSubview(self.textField)
	}
	
	func setupConstraints() {
		self.label.mas_makeConstraints { (make) in
			make?.bottom.left()?.top()?.equalTo()(self)
			make?.right.equalTo()(self.textField.mas_left)
		}
		
		self.textField.mas_makeConstraints { (make) in
			make?.top.right()?.bottom()?.equalTo()(self)
		}
	}
	
	func displaySelectedDate() {
		self.textField.text = self.dateFormatter.string(from: self.pickedDate)
	}
	
	@objc func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		self.displaySelectedDate()
		self.delegate?.datePickerView(self, didPick: self.pickedDate)
	}
}
