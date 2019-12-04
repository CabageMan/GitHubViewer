import UIKit
import Nuke

class ImageContentView: UIView {
    
    let imageView = UIImageView()
    let loadingIndicator = UIActivityIndicatorView(style: .gray)
    var placeholderImage: UIImage = #imageLiteral(resourceName: "AvatarPlaceholder")
    
    override var contentMode: UIView.ContentMode {
        didSet { imageView.contentMode = contentMode }
    }
    
    private var content: ImageContent?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        imageView.add(to: self).do {
            $0.edgesToSuperview()
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = placeholderImage
        }
        loadingIndicator.add(to: self).do {
            $0.centerInSuperview()
            $0.isHidden = true
        }
    }
}

//MARK: - Actions
extension ImageContentView {
    func reset() {
        loadingIndicator.do {
            $0.stopAnimating()
            $0.isHidden = true
        }
        Nuke.cancelRequest(for: imageView)
        imageView.image = nil
    }
    
    func configure(image: UIImage, animated: Bool = false) {
        reset()
        if animated {
            animateFadeOut() { [weak self] in
                self?.imageView.image = image
                self?.animaateFadeIn()
            }
        } else {
            imageView.image = image
        }
    }
    
    func configure(url: URL, diameter: CGFloat, animated: Bool = false) {
        reset()
        let imageProcessors: [ImageProcessing] = [
            ImageProcessor.Resize(size: CGSize(diameter)),
            ImageProcessor.Circle()
        ]
        let request = ImageRequest(url: url, processors: imageProcessors)
        
        if animated {
            animateFadeOut() { [weak self] in
                guard let self = self else { return }
                let options: ImageLoadingOptions = .shared
                Nuke.loadImage(
                    with: request,
                    options: options,
                    into: self.imageView,
                    completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                        self.animaateFadeIn()
                    }
                )
            }
        } else {
            loadingIndicator.do {
                $0.isHidden = false
                $0.startAnimating()
            }
            let options = ImageLoadingOptions(
                placeholder: placeholderImage,
                transition: .fadeIn(duration: 0.3)
            )
            Nuke.loadImage(
                with: request,
                options: options,
                into: imageView,
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                }
            )
        }
    }
    
    func configure(content: ImageContent, diameter: CGFloat, animated: Bool = false) {
        guard content.path != self.content?.path else { return }
        self.content = content
        
        switch content {
        case .image(let name):
            guard let image = UIImage(named: name) else { return }
            configure(image: image, animated: animated)
        case .url(let url):
            configure(url: url, diameter: diameter, animated: animated)
        }
    }
}
