//
//  App+Injection.swift
//  AppWideStateExample
//
//  Created by TI Digital on 28/06/22.
//

import Foundation
import Factory

extension Container {
    static let appStateContainer = Factory(scope: .singleton) { AppStateContainer() }
    static let bottomSheetState = Factory(scope: .singleton) { appStateContainer.callAsFunction().bottomSheet }
    static let toastState = Factory(scope: .singleton) { appStateContainer.callAsFunction().toastState }
}
