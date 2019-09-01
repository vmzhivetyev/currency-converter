//
//  CurrencyFormatter.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class SumInputFieldFormatter: NSObject {
	
	weak var delegate : SumInputFieldFormatterDelegate?
	
	let textField : UITextField
	
	let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = NSLocale.current
		formatter.numberStyle = NumberFormatter.Style.decimal
		formatter.usesGroupingSeparator = true
		formatter.groupingSeparator = " "
		formatter.maximumFractionDigits = 2
		formatter.roundingMode = .up
		return formatter
	}()
	
	var sumValue: Decimal {
		get {
			let text = self.textField.text
			return self.number(from: text)?.decimalValue ?? 0
		}
		set {
			self.textField.text = self.numberFormatter.string(from: newValue as NSDecimalNumber)
		}
	}
	
	init(textField: UITextField) {
		self.textField = textField
		
		super.init()
		
		self.textField.delegate = self
		
		self.textField.keyboardType = .numbersAndPunctuation
		self.textField.returnKeyType = .done
		self.textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
	}
	
	private func number(from string: String?) -> NSNumber? {
		guard let validString = string?
			.replacingOccurrences(of: " ", with: "")
			.replacingOccurrences(of: ",", with: numberFormatter.decimalSeparator)
			.replacingOccurrences(of: ".", with: numberFormatter.decimalSeparator) else {
				return nil
		}
		
		return numberFormatter.number(from: validString)
	}
}

extension SumInputFieldFormatter : UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.textField.resignFirstResponder()
		return false
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		/* #CRUTCH:
		Каст к NSString - чтобы иметь возможность вызвать replacingCharacters
		с параметром типа NSRange.
		*/
		guard let nsString = textField.text as NSString? else {
			return false
		}
		let newText = nsString
			.replacingCharacters(in: range, with: string)
		
		return self.number(from: newText) != nil || newText == ""
	}
}

extension SumInputFieldFormatter {
	@objc func textDidChange(_ textInput: UITextInput?) {
		self.delegate?.sumInputFieldFormatter(self, didChange: self.sumValue)
	}
}
