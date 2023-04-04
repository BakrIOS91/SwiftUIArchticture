//
//  AsyncImage.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

import SwiftUI

public struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let configuration: (Image) -> Image
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder, configuration: @escaping (Image) -> Image = { $0 }) {
        self.placeholder = placeholder()
        self.configuration = configuration
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    public var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let url: URL
    private var cache: ImageCache?
    private var task: URLSessionDataTask?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    func load() {
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        task?.cancel()
        
        let urlSession = URLSession.shared
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        task = urlSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        self.cache?[self.url] = image
                    }
                }
            }
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

private struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            guard let image = newValue else {
                cache.removeObject(forKey: key as NSURL)
                return
            }
            
            cache.setObject(image, forKey: key as NSURL)
        }
    }
}
