//
//  UmbrellaImageView.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/21/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Siesta
import Foundation

/**
 A `UIImageView` that asynchronously loads and displays remote images.
 */
class UmbrellaImageView: UIImageView
{
    /// The service this view should use to request & cache its images.
    @objc
    public var imageService: Service = RemoteImageView.defaultImageService
    
    /// A URL whose content is the image to display in this view.
    @objc
    public var imageURL: String?
    {
        get { return imageResource?.url.absoluteString }
        set {
            imageResource = (newValue == nil)
                ? nil
                : imageService.resource(absoluteURL: newValue)
        }
    }
    
    /// Optional color applyed to downloaded image
    @objc
    public var imageColor: UIColor?
    
    /**
     A remote resource whose content is the image to display in this view.
     
     If this image is already in memory, it is displayed synchronously (no flicker!). If the image is missing or
     potentially stale, setting this property triggers a load.
     */
    @objc
    public var imageResource: Resource?
    {
        willSet
        {
            imageResource?.removeObservers(ownedBy: self)
            imageResource?.cancelLoadIfUnobserved(afterDelay: 0.05)
        }
        
        didSet
        {
            imageResource?.loadIfNeeded()
            imageResource?.addObserver(owner: self)
            { [weak self] _,_ in self?.updateViews() }
            
            if imageResource == nil  // (and thus closure above was not called on observerAdded)
            { updateViews() }
        }
    }
    
    private func updateViews()
    {
        image = imageResource?.typedContent()
        if let imageColor = imageColor {
            image = image?.withColor(imageColor)
        }
    }
}
