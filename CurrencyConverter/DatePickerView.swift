//
//  DatePickerView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

	weak var delegate: DatePickerViewDelegate?

	var pickedDate: Date {
		get {
			return self.datePicker.date
		}
		set {
			self.datePicker.setDate(newValue, animated: true)
			self.displaySelectedDate()
		}
	}

	var minimumDate: Date? {
		get {
			return self.datePicker.minimumDate
		}
		set {
			self.datePicker.minimumDate = newValue
		}
	}

	var maximumDate: Date? {
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
	let underline = UIView()

	let dateFormatter: DateFormatter = {
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

		self.label.backgroundColor = .clear
		self.textField.backgroundColor = .clear
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupUI() {
		self.underline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

		self.label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		self.label.text = UIStringsProvider.shared.selectDateHint
		self.label.font = UIFont.preferredFont(forTextStyle: .caption1)
		self.label.textAlignment = .right

		self.textField.tintColor = .clear
		self.textField.textAlignment = .right
		self.textField.inputView = self.datePicker
		self.textField.delegate = self
		self.textField.font = UIFont.preferredFont(forTextStyle: .title1)

		self.datePicker.datePickerMode = .date
		self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)

		self.addSubview(self.label)
		self.addSubview(self.textField)
		self.addSubview(self.underline)
	}

	func setupConstraints() {
		self.label.mas_makeConstraints { (make) in
			make?.left.right()?.equalTo()(self)
			make?.bottom.equalTo()(self)?.inset()(5)
			make?.top.equalTo()(self.textField.mas_bottom)?.inset()(0)
		}

		self.textField.mas_makeConstraints { (make) in
			make?.top.left().right()?.equalTo()(self)
		}

		self.underline.mas_makeConstraints { (make) in
			make?.left.bottom()?.right()?.equalTo()(self)
			make?.height.equalTo()(0.5)
		}
	}

	func displaySelectedDate() {
		self.textField.text = self.dateFormatter.string(from: self.pickedDate)
	}

	@objc
	func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		self.displaySelectedDate()
		self.delegate?.datePickerView(self, didPick: self.pickedDate)
	}
}

extension DatePickerView: UITextFieldDelegate {
	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
		return false
	}
}
