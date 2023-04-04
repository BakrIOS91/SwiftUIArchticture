//
//  NetWorkHelper.swift

import Foundation

public protocol NetworkHelper: InternetConnectionChecker {
    func failHandler(_ error: Error) -> ViewState
}
