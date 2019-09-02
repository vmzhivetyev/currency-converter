//
//  CBRService.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation
import SwiftyXMLParser


class CBRService {
	private enum CBRURL: String {
		static let host = "https://www.cbr.ru"
		
		case currenciesList = "scripts/XML_valFull.asp"
		case currencyValue = "scripts/XML_dynamic.asp"
	}
	
	struct Currency: Equatable {
		let id : String
		let isoCode : String
		let name : String
		let engName : String?
		let nominal : String?
		let parentCode : String?
		
		static func == (lhs: Currency, rhs: Currency) -> Bool {
			return lhs.isoCode == rhs.isoCode
		}
	}
	
	static let rubCurrency = Currency(id: "",
									  isoCode: "RUB",
									  name: "Российский рубль",
									  engName: "Russian ruble",
									  nominal: "1",
									  parentCode: "")
	
	weak var delegate : CBRServiceDelegate?
	
	private let urlSession : URLSession
	private let baseURL = URL(string: CBRURL.host)!
	
	private let dateFormatter : DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}()
	
	private var cachedValues = [String : Decimal]()
	
	init() {
		self.urlSession = URLSession.shared
	}
	
	private func xmlFromUrl(_ cbrURL: CBRURL,
							completion: @escaping (XML.Accessor?)->()) {
		self.xmlFromUrl(cbrURL,
						parameters: [:],
						completion: completion)
	}
	
	private func xmlFromUrl(_ cbrURL: CBRURL,
							parameters: [String : String],
							completion: @escaping (XML.Accessor?)->()) {
		let urlWithoutParameters = baseURL.appendingPathComponent(cbrURL.rawValue)
		var urlComponents = URLComponents(url: urlWithoutParameters, resolvingAgainstBaseURL: true)!
		urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		let fullURL = urlComponents.url!
		
		print("Doing request: \(fullURL)")
		self.urlSession.dataTask(with: fullURL) { (data, response, error) in
			// todo: remove force unwrap
			guard let data = data else {
				completion(nil)
				return
			}
			completion(XML.parse(data))
			}.resume()
	}
}

extension CBRService {
	func cacheKey(currency: Currency, date: Date) -> String {
		let dateStr = self.dateFormatter.string(from: date)
		return "\(currency.isoCode) \(dateStr)"
	}
	
	func cacheValue(currency: Currency, date: Date, value: Decimal) {
		let key = self.cacheKey(currency: currency, date: date)
		self.cachedValues[key] = value
	}
	
	func cachedValue(currency: Currency, date: Date) -> Decimal? {
		let key = self.cacheKey(currency: currency, date: date)
		return self.cachedValues[key]
	}
}

extension CBRService : CBRServiceProtocol
{
	func fetchCurrencyValue(_ currency: CBRService.Currency, date: Date) {
		if currency == CBRService.rubCurrency {
			self.delegate?.cbrService(self, didFetch: 1, for: currency)
			return
		}
		
		let tenDaysBefore = Calendar.current.date(byAdding: .day, value: -10, to: date) ?? date
		
		let firstDate = self.dateFormatter.string(from: tenDaysBefore)
		let secondDate = self.dateFormatter.string(from: date)
		
		if let cachedValue = self.cachedValue(currency: currency, date: date) {
			self.delegate?.cbrService(self, didFetch: cachedValue, for: currency)
			return
		}
		
		self.xmlFromUrl(.currencyValue, parameters: [
			"date_req1" : firstDate,
			"date_req2" : secondDate,
			"VAL_NM_RQ" : currency.id
		]) { (xmlOpt) in
			guard
				let xml = xmlOpt,
				let value = xml["ValCurs"]["Record"].last["Value"].text,
				let nominal = xml["ValCurs"]["Record"].last["Nominal"].text,
				let decimalValue = Decimal(string: value, locale: Locale(identifier: "ru_RU")),
				let decimalNominal = Decimal(string: nominal, locale: Locale(identifier: "ru_RU"))
				else {
					DispatchQueue.main.async {
						self.delegate?.cbrService(self, didFetch: 0, for: currency)
					}
					return
			}
			DispatchQueue.main.async {
				let result = decimalValue / decimalNominal
				self.cacheValue(currency: currency, date: date, value: result)
				self.delegate?.cbrService(self, didFetch: result, for: currency)
			}
		}
	}
	
	func fetchCurrenciesList() {
		self.xmlFromUrl(.currenciesList) { (xmlOpt) in
			guard let xml = xmlOpt else {
				DispatchQueue.main.async {
					self.delegate?.cbrService(self, didFetch: [])
				}
				return
			}
			var list = xml["Valuta"]["Item"].compactMap { (item) -> Currency? in
				guard
					let id = item.attributes["ID"]?.trimmingCharacters(in: .whitespaces),
					let isoCode = item["ISO_Char_Code"].text?.trimmingCharacters(in: .whitespaces),
					let name = item["Name"].text?.trimmingCharacters(in: .whitespaces)
					else {
						return nil
				}
				
				return Currency(id: id,
								isoCode: isoCode,
								name: name,
								engName: item["EngName"].text?.trimmingCharacters(in: .whitespaces),
								nominal: item["Nominal"].text?.trimmingCharacters(in: .whitespaces),
								parentCode: item["ParentCode"].text?.trimmingCharacters(in: .whitespaces))
			}
			list.append(CBRService.rubCurrency)
			list.sort(by: { $0.isoCode < $1.isoCode })
			DispatchQueue.main.async {
				self.delegate?.cbrService(self, didFetch: list)
			}
		}
	}
}
