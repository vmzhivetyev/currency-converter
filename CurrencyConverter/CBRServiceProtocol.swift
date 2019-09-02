//
//  CBRServiceProtocol.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation

protocol CBRServiceProtocol {
	func fetchCurrenciesList()
	func fetchCurrencyValue(_ currency: CBRService.Currency, date: Date)
}
