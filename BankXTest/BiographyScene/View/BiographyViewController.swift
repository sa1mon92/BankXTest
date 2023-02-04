//
//  BiographyViewController.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit
import Combine
import SDWebImage

class BiographyViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var separatorView: GradientView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var searchButton: RoundedGradientButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButtonBottomConstraint: NSLayoutConstraint!
    
    var viewModel: BiographyViewModel!
    
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        searchTextField.delegate = self
        setSearchTextField()
        setBackButton()
        setupKeyboardObservers()
        binding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinish()
    }
    
    private func binding() {
        viewModel.$biography
            .dropFirst(2)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] biographyModel in
                guard let biographyModel = biographyModel else {
                    return
                }
                if let urlString = biographyModel.artist.image.last?.text,
                   let url = URL(string: urlString) {
                    self?.artistImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self?.artistImageView.sd_setImage(with: url, placeholderImage: Constants.placeholderImage)
                } else {
                    self?.artistImageView.image = Constants.placeholderImage
                }
                
                self?.titleLabel.text = biographyModel.artist.name ?? ""
                self?.descriptionLabel.text = biographyModel.artist.bio.summary?.dropHTTPTags() ?? ""
                self?.setupHeightDetailLabel()
            }
            .store(in: &cancellable)
        viewModel.$notFoundHidden
            .dropFirst(2)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] newValue in
                self?.notFoundView.isHidden = newValue
            }
            .store(in: &cancellable)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private var keyboardHeight: CGFloat?
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if keyboardHeight == nil {
            guard let userInfo = notification.userInfo else { return }
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            keyboardHeight = keyboardFrame.size.height
        }
        
        if let keyboardHeight = keyboardHeight {
            backButtonBottomConstraint.constant = keyboardHeight + 10
            detailView.isHidden = true
        }
    }

    @objc private func keyboardWillHide(notification:NSNotification) {
        detailView.isHidden = false
        backButtonBottomConstraint.constant = 50
    }
    
    private func setBackButton() {
        self.backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.backButton.titleLabel?.minimumScaleFactor = 0.5
        
        if let font = UIFont(name: "Roboto-Regular", size: 18) {
            let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: 1,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            let attributedString = NSMutableAttributedString(string: "Вернуться назад", attributes: attributes)
            self.backButton.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
        }
    }
    
    private func setupHeightDetailLabel() {
        let fontHeight = descriptionLabel.font.lineHeight
        let detailViewHeight = detailView.frame.height
        let artistImageViewHeight = artistImageView.frame.height
        let titleLabelHeight = titleLabel.frame.height
        let freeHeight = detailViewHeight - artistImageViewHeight - titleLabelHeight - 39
        descriptionLabel.numberOfLines = Int(freeHeight / fontHeight)
    }
    
    private func setSearchTextField() {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Кого ищем?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    private func search() {
        if let artistName = searchTextField.text, !artistName.isEmpty {
            viewModel.getBiography(for: artistName)
        }
        self.view.endEditing(true)
    }
    
    private func clear() {
        viewModel.clear()
        artistImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        search()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BiographyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.text = ""
        clear()
    }
}
