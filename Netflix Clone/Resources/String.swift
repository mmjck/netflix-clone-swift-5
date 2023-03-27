//
//  String.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 20/03/23.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
