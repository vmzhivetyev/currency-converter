//
//  CurrencyInputView.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit
import Masonry

class CurrencyInputView: UIView {

	struct Currency {
		let code: String
		let name: String
	}

	weak var delegate: CurrencyInputViewDelegate?

	var currencies = [Currency]() {
		didSet {
			self.selectCurrency(at: 0)
		}
	}

	var selectedCurrency: Currency? {
		let index = self.currencyPickerView.selectedRow(inComponent: 0)
		guard index < self.currencies.count else {
			return nil
		}
		let selectedCurrency = self.currencies[index]
		return selectedCurrency
	}

	var sumValue: Decimal {
		get {
			return self.sumTextFieldFormatter.sumValue
		}
		set {
			self.sumTextFieldFormatter.sumValue = newValue
		}
	}

	let sumTextField = UITextField()
	let currencyCodeTextField = UITextField()
	let currencyPickerView = UIPickerView()

	let sumTextFieldFormatter: SumInputFieldFormatter

	convenience init() {
		self.init(frame: CGRect.zero)
	}

	override init(frame: CGRect) {
		self.sumTextFieldFormatter = SumInputFieldFormatter(textField: self.sumTextField)

		super.init(frame: frame)

		self.setupUI()
		self.setupConstraints()
	}

	func setupUI() {
		self.sumTextFieldFormatter.delegate = self
		self.currencyPickerView.dataSource = self
		self.currencyPickerView.delegate = self

		self.currencyCodeTextField.inputView = self.currencyPickerView
		self.currencyCodeTextField.tintColor = .clear
		self.currencyCodeTextField.font = UIFont.preferredFont(forTextStyle: .title1)
		self.currencyCodeTextField.delegate = self
		self.currencyCodeTextField.textAlignment = .right

		self.sumTextField.font = UIFont.preferredFont(forTextStyle: .title1)
		self.sumTextField.adjustsFontSizeToFitWidth = true
		self.sumTextField.textAlignment = .right

		self.addSubview(self.sumTextField)
		self.addSubview(self.currencyCodeTextField)
	}

	func setupConstraints() {
		self.sumTextField.mas_makeConstraints { (make) in
			make?.left.bottom().top()?.equalTo()(self)
			make?.right.equalTo()(self.currencyCodeTextField.mas_left)?.inset()(10)
		}

		self.currencyCodeTextField.mas_makeConstraints { (make) in
			make?.top.right()?.equalTo()(self)
			make?.width.equalTo()(65)
			make?.bottom.equalTo()(self.sumTextField.mas_bottom)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func displaySelectedCurrency() {
		self.currencyCodeTextField.text = self.selectedCurrency?.code ?? "..."
	}

	func selectCurrency(at index: Int) {
		if index < self.currencies.count {
			self.currencyPickerView.selectRow(Int(index), inComponent: 0, animated: true)
		}
		self.displaySelectedCurrency()
	}
}

extension CurrencyInputView: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.currencies.count
	}
}

extension CurrencyInputView: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let currency = self.currencies[row]
		return "\(currency.code) - \(currency.name)"
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selectCurrency(at: row)
		self.delegate?.currencyInputView(self, didSelect: self.selectedCurrency)
	}
}

extension CurrencyInputView: UITextFieldDelegate {
	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
		return false
	}
}

extension CurrencyInputView: SumInputFieldFormatterDelegate {
	func sumInputFieldFormatter(_ sumInputFieldFormatter: SumInputFieldFormatter, didChange value: Decimal) {
		self.delegate?.currencyInputView(self, didChange: value)
	}
}
