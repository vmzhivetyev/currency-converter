//
//  DatePickerViewDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation

protocol DatePickerViewDelegate: class {
	func datePickerView(_ datePickerView: DatePickerView, didPick date: Date)
}
