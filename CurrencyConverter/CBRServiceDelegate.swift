//
//  CBRServiceDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol CBRServiceDelegate: class {
	func cbrService(_ cbrService: CBRServiceProtocol,
					didFetch currencies: [CBRCurrency])

	func cbrService(_ cbrService: CBRServiceProtocol,
					didFetch value: Decimal,
					for currency: CBRCurrency,
					date: Date,
					error: CBRError?)
}
