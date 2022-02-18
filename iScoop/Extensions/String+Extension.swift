//
//  Date+Extension.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

extension String {
    func difference() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {return nil}
        let elapsed = date.timeIntervalSince(Date())
        
        let duration = Double(elapsed)
        let diffDate = Date().addingTimeInterval(duration)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: diffDate, relativeTo: Date())
    }
}

