//
//  UIApplication+Window.swift
//  Tracker
//
//  Created by Артем Табенский on 19.05.2025.
//

import UIKit

public extension UIApplication {
   func currentUIWindow() -> UIWindow? {
       connectedScenes
           .compactMap { $0 as? UIWindowScene }
           .flatMap { $0.windows }
           .first { $0.isKeyWindow }
   }
}
