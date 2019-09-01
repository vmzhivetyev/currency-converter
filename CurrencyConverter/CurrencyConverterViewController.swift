//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit
import Masonry

class CurrencyConverterViewController: UIViewController {
	
	enum ConversionDirection {
		case forward, backward
	}
	
	var output : CurrencyConverterViewControllerOutput?
	
	let datePickerView = DatePickerView()
	
	let currencyInputsStackView = UIStackView()
	let firstCurrencyInputView = CurrencyInputView()
	let secondCurrencyInputView = CurrencyInputView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// todo: move out of here
		let presenter = CurrencyConverterPresenter()
		presenter.output = self
		self.output = presenter
		
		
		self.setupUI()
		self.setupGestureRecognizer()
		self.setupConstraints()
		
		// DEBUG
		self.view.backgroundColor = .white
		self.datePickerView.backgroundColor = .orange
		self.currencyInputsStackView.backgroundColor = .red
		
		self.firstCurrencyInputView.currencies = [
			CurrencyInputView.Currency(code: "RUB"),
			CurrencyInputView.Currency(code: "EUR")
		]
	}
	
	func setupUI() {
		self.navigationItem.title = "Currency Converter"
		
		self.datePickerView.delegate = self
		self.firstCurrencyInputView.delegate = self
		self.secondCurrencyInputView.delegate = self
		
		self.datePickerView.pickedDate = Date()
		self.datePickerView.maximumDate = Date()
		
		self.currencyInputsStackView.alignment = .fill
		self.currencyInputsStackView.distribution = .fillProportionally
		self.currencyInputsStackView.axis = .horizontal
		
		self.currencyInputsStackView.addArrangedSubview(self.firstCurrencyInputView)
		self.currencyInputsStackView.addArrangedSubview({
			let equalsCharLabel = UILabel()
			equalsCharLabel.text = "="
			equalsCharLabel.textAlignment = .center
			equalsCharLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
			equalsCharLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
			equalsCharLabel.backgroundColor = .green
			return equalsCharLabel
			}())
		self.currencyInputsStackView.addArrangedSubview(self.secondCurrencyInputView)
		
		self.view.addSubview(self.datePickerView)
		self.view.addSubview(self.currencyInputsStackView)
	}
	
	func setupConstraints() {
		self.datePickerView.mas_makeConstraints { (make) in
			make?.left.right()?.equalTo()(self.view)?.with()?.inset()(16)
			make?.top.equalTo()(self.mas_topLayoutGuide)?.inset()(16)
			make?.height.equalTo()(50)
		}
		
		self.currencyInputsStackView.mas_makeConstraints { (make) in
			make?.left.right()?.equalTo()(self.view)?.inset()(16)
			make?.top.equalTo()(self.datePickerView.mas_bottom)?.inset()(16)
			make?.height.equalTo()(50)
		}
	}
	
	func setupGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self,
														  action: #selector(didTapGestureRecognizer(_:)))
		self.view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func requestConversion() {
		let data = CurrencyConverterViewData(
			date: self.datePickerView.pickedDate,
			firstSum: self.firstCurrencyInputView.sumValue,
			firstCurrency: self.firstCurrencyInputView.selectedCurrency,
			secondSum: self.secondCurrencyInputView.sumValue,
			secondCurrency: self.secondCurrencyInputView.selectedCurrency,
			conversionDirectioin: .forward)
		
		self.output?.requestConversion(data: data)
	}
}

extension CurrencyConverterViewController : CurrencyConverterPresenterOutput {
	func currencyWasConverted(data: CurrencyConverterViewData) {
		self.secondCurrencyInputView.sumValue = data.secondSum
	}
}

extension CurrencyConverterViewController {
	@objc func didTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
}

extension CurrencyConverterViewController : DatePickerViewDelegate {
	func datePickerView(_ datePickerView: DatePickerView, didPick date: Date) {
		self.requestConversion()
	}
}

extension CurrencyConverterViewController : CurrencyInputViewDelegate {
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didChange value: Decimal) {
		self.requestConversion()
	}
	
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didSelect currency: CurrencyInputView.Currency?) {
		self.requestConversion()
	}
}

