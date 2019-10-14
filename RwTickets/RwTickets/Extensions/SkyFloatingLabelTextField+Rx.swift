//
//  TestRx.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/11/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SkyFloatingLabelTextField

extension Reactive where Base: SkyFloatingLabelTextField {
    
    /// Bindable sink for `errorMessage` property.
    public var error: Binder<String?> {
        return Binder(self.base) { textfield, errorMessage in
            textfield.errorMessage = errorMessage
        }
    }
}
