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
	let messageLabel = UILabel()
	
	private var lastConversionDirection : ConversionDirection = .forward

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
		self.setupGestureRecognizer()
		self.setupConstraints()
		
		self.output?.didLoadView()
	}
	
	func setupUI() {
		self.navigationItem.title = "Currency Converter"
		self.view.backgroundColor = .white
		
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
			return equalsCharLabel
			}())
		self.currencyInputsStackView.addArrangedSubview(self.secondCurrencyInputView)
		
		self.messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		self.messageLabel.numberOfLines = 0
		self.messageLabel.textAlignment = .center
		
		self.view.addSubview(self.datePickerView)
		self.view.addSubview(self.currencyInputsStackView)
		self.view.addSubview(self.messageLabel)
	}
	
	func setupConstraints() {
		self.datePickerView.mas_makeConstraints { (make) in
			make?.left.right()?.equalTo()(self.view)?.with()?.inset()(16)
			make?.top.equalTo()(self.mas_topLayoutGuide)?.inset()(100)
			make?.height.equalTo()(50)
		}
		
		self.currencyInputsStackView.mas_makeConstraints { (make) in
			make?.left.right()?.equalTo()(self.view)?.inset()(16)
			make?.top.equalTo()(self.datePickerView.mas_bottom)?.inset()(0)
			make?.height.equalTo()(50)
		}
		
		self.messageLabel.mas_makeConstraints { (make) in
			make?.top.equalTo()(self.currencyInputsStackView.mas_bottom)?.inset()(16)
			make?.left.right()?.equalTo()(self.view)?.inset()(16)
		}
	}
	
	func setupGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self,
														  action: #selector(didTapGestureRecognizer(_:)))
		self.view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func requestConversion(_ conversionDirection: ConversionDirection) {
		let data = CurrencyConverterViewData(
			date: self.datePickerView.pickedDate,
			firstSum: self.firstCurrencyInputView.sumValue,
			firstCurrency: self.firstCurrencyInputView.selectedCurrency,
			secondSum: self.secondCurrencyInputView.sumValue,
			secondCurrency: self.secondCurrencyInputView.selectedCurrency,
			conversionDirection: conversionDirection)
		self.lastConversionDirection = conversionDirection
		self.animateUI(finished: false)
		self.output?.requestConversion(data: data)
	}
	
	func conversionDirection(for currencyInputView: CurrencyInputView) -> ConversionDirection {
		let result : ConversionDirection =
			currencyInputView == self.secondCurrencyInputView ? .backward : .forward
		return result
	}
	
	func animateUI(finished: Bool) {
		UIView.animate(withDuration: 0.2) {
			self.firstCurrencyInputView.alpha = finished || self.lastConversionDirection == .forward ? 1 : 0.5
			self.secondCurrencyInputView.alpha = finished || self.lastConversionDirection == .backward ? 1 : 0.5
		}
		
	}
}

extension CurrencyConverterViewController : CurrencyConverterPresenterOutput {
	func showCurrenciesList(_ list: [CurrencyInputView.Currency]) {
		self.firstCurrencyInputView.currencies = list
		self.secondCurrencyInputView.currencies = list
	}
	
	func showSumAfterConversion(data: CurrencyConverterViewData) {
		if data.conversionDirection == .backward {
			self.firstCurrencyInputView.sumValue = data.firstSum
		} else {
			self.secondCurrencyInputView.sumValue = data.secondSum
		}
		self.messageLabel.text = nil
		self.animateUI(finished: true)
	}
	
	func selectCurrencies(firstIndex: Int, secondIndex: Int) {
		self.firstCurrencyInputView.selectCurrency(at: firstIndex)
		self.secondCurrencyInputView.selectCurrency(at: secondIndex)
	}
	
	func showConversion(of sum: Decimal, conversionDirection: ConversionDirection) {
		if conversionDirection == .forward {
			self.firstCurrencyInputView.sumValue = sum
		} else {
			self.secondCurrencyInputView.sumValue = sum
		}
		self.requestConversion(conversionDirection)
	}
	
	func showError(text: String) {
		self.messageLabel.text = text
	}
}

extension CurrencyConverterViewController {
	@objc func didTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
}

extension CurrencyConverterViewController : DatePickerViewDelegate {
	func datePickerView(_ datePickerView: DatePickerView, didPick date: Date) {
		self.requestConversion(self.lastConversionDirection)
	}
}

extension CurrencyConverterViewController : CurrencyInputViewDelegate {
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didChange value: Decimal) {
		self.requestConversion(self.conversionDirection(for: currencyInputView))
	}
	
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didSelect currency: CurrencyInputView.Currency?) {
		self.requestConversion(self.lastConversionDirection)
	}
}
