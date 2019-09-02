//
//  CBRServiceDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol CBRServiceDelegate: class {
	func cbrService(_ cbrService: CBRService, didFetch currencies: [CBRService.Currency])
	func cbrService(_ cbrService: CBRService,
					didFetch value: Decimal,
					for currency: CBRService.Currency,
					error: CBRService.CBRError?)
}
