//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit
import Masonry

class ViewController: UIViewController {
	
	let datePickerView = DatePickerView()
	
	let currencyInputsStackView = UIStackView()
	let firstCurrencyInputView = CurrencyInputView()
	let secondCurrencyInputView = CurrencyInputView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
		self.setupConstraints()
		
		// DEBUG
		self.view.backgroundColor = .white
		self.datePickerView.backgroundColor = .orange
		self.currencyInputsStackView.backgroundColor = .red
	}
	
	func setupUI() {
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


}

