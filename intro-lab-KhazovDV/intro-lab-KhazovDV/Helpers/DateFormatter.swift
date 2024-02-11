//
//  DateFormatter.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {
    func toString(withFormat format: String = "yyyy.MM.dd") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
