//
//  CurrencyConverterViewControllerOutput.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol CurrencyConverterViewControllerOutput: class {
	func requestConversion(data: CurrencyConverterViewData)
}
