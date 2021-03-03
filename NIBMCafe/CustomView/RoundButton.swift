//
//  RoundButton.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-27.
//

import Foundation
import UIKit

extension UIButton {
    func generateRoundButton() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
