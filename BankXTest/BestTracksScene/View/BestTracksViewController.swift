//
//  BestTracksViewController.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit
import Combine

class BestTracksViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var tracksView: UIView!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonBottomConstraint: NSLayoutConstraint!
    
    var viewModel: BestTracksViewModel!
    
    private var cancellable = Set<AnyCancellable>()
    private var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        searchTextField.delegate = self
        setSearchTextField()
        setBackButton()
        setupKeyboardObservers()
        setupTracksTableView()
        binding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinish()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSeparatorGradient()
        setSearchButton()
    }
    
    private func binding() {
        viewModel.$bestTracks
            .dropFirst(2)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bestTracksModel in
                if bestTracksModel == nil {
                    self?.notFoundView.isHidden = false
                }
                self?.tracksTableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    private func setupTracksTableView() {
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        let nib = UINib(nibName: "TracksTableViewCell", bundle: nil)
        tracksTableView.register(nib, forCellReuseIdentifier: "TracksTableViewCell")
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        notFoundView.isHidden = true
        if keyboardHeight == nil {
            guard let userInfo = notification.userInfo else { return }
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            keyboardHeight = keyboardFrame.size.height
        }
        
        if let keyboardHeight = keyboardHeight {
            backButtonBottomConstraint.constant = keyboardHeight + 10
            tracksView.isHidden = true
        }
    }

    @objc private func keyboardWillHide(notification:NSNotification) {
        tracksView.isHidden = false
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
    
    private func setSearchTextField() {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Кого ищем?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    private func setSearchButton() {
        let firstColor =  UIColor(red: 251 / 255, green: 194 / 255, blue: 235 / 255, alpha: 1.0).cgColor
        let secondColor = UIColor(red: 166 / 255, green: 193 / 255, blue: 238 / 255, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.searchButton.bounds
        self.searchButton.layer.insertSublayer(gradientLayer, at:0)
        self.searchButton.layer.cornerRadius = 10
        self.searchButton.clipsToBounds = true
        self.searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.searchButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    private func setSeparatorGradient() {
        let firstColor =  UIColor(red: 161 / 255, green: 140 / 255, blue: 209 / 255, alpha: 1.0).cgColor
        let secondColor = UIColor(red: 251 / 255, green: 194 / 255, blue: 235 / 255, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.separatorView.bounds
                
        self.separatorView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        search()
    }
    
    private func search() {
        if let artistName = searchTextField.text, !artistName.isEmpty {
            viewModel.getBestTracks(for: artistName)
        }
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BestTracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.bestTracks?.bestTracks.track.count else {
            return 0
        }
        return count > 3 ? 3 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TracksTableViewCell", for: indexPath) as! TracksTableViewCell
        if let trackModel = viewModel.getRandomTrackModel() {
            cell.setup(model: trackModel)
        }
        return cell
    }
}

extension BestTracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tracksView.frame.height < 345 ? self.tracksView.frame.height / 3 : 115
    }
}

extension BestTracksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.text = ""
        viewModel.clear()
    }
}
