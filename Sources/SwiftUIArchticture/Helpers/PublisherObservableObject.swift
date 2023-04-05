//
//  PublisherObservableObject.swift
//  

import SwiftUI
import Combine

public final class PublisherObservableObject: ObservableObject {
    
    var subscriber: AnyCancellable?
    
    public init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
