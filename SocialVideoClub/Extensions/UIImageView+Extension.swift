//
//  UIImageView+Extension.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import SDWebImage

extension UIImageView {
    func setImage(
        with url: URL,
        placeholder: UIImage? = nil,
        animated: Bool? = true,
        onSuccess: ((UIImage?) -> ())? = nil
    ) {
        if animated ?? false {
            sd_imageTransition = .fade(duration: 0.15)
        } else {
            sd_imageTransition = .none
        }
        
        sd_setImage(with: url,
                    placeholderImage: placeholder,
                    options: [.retryFailed, .progressiveLoad],
                    completed: {
            image, error, cacheType, imageURL in
            if let downloadedImage = image {
                onSuccess?(downloadedImage)
            } else {
                onSuccess?(nil)
            }
        })
    }
}
