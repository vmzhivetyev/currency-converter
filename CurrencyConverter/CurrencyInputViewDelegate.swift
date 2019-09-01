//
//  CurrencyInputViewDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation


protocol CurrencyInputViewDelegate: class {
	
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didChange value: Decimal)
	
	func currencyInputView(_ currencyInputView: CurrencyInputView,
						   didSelect currency: CurrencyInputView.Currency?)
}
