//
//  RatingSwitch.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/13/20.
//

import Foundation

enum RatingSwitch {
    case vSad
    case sad
    case ok
    case happy
    case vHappy
    case none
}

extension RatingSwitch {
    func getTextLabel() -> String {
        switch  self {
        case .vSad:
            return "Your day was rated: ☹️"
        case .sad:
            return "Your day was rated: 🙁"
        case .ok:
            return "Your day was rated: 😐"
        case .happy:
            return "Your day was rated: 🙂"
        case .vHappy:
            return "Your day was rated: 😁"
        case .none:
            return "Your did not rate your day."
        }
    }
}
