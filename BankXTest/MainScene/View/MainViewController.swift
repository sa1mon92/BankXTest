//
//  MainViewController.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var bestTracksButton: UIButton!
    @IBOutlet weak var biographyButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSeparatorGradient()
        setBestTracksButton()
        setBiographyButton()
    }
    
    
    @IBAction func biographyButtonTapped(_ sender: UIButton) {
        viewModel.biographyButtonTapped()
    }
    
    @IBAction func bestTracksButtonTapped(_ sender: UIButton) {
        viewModel.bestTracksButtonTapped()
    }
    
    private func setImageView() {
        imageView.image = UIImage(named: "MainPicture")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    private func setBiographyButton() {
        let firstColor =  UIColor(red: 251 / 255, green: 194 / 255, blue: 235 / 255, alpha: 1.0).cgColor
        let secondColor = UIColor(red: 166 / 255, green: 193 / 255, blue: 238 / 255, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.biographyButton.bounds
        self.biographyButton.layer.insertSublayer(gradientLayer, at:0)
        self.biographyButton.layer.cornerRadius = 10
        self.biographyButton.clipsToBounds = true
        self.biographyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.biographyButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    private func setBestTracksButton() {
        let firstColor =  UIColor(red: 240 / 255, green: 147 / 255, blue: 251 / 255, alpha: 1.0).cgColor
        let secondColor = UIColor(red: 245 / 255, green: 81 / 255, blue: 108 / 255, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bestTracksButton.bounds
        self.bestTracksButton.layer.insertSublayer(gradientLayer, at:0)
        self.bestTracksButton.layer.cornerRadius = 10
        self.bestTracksButton.clipsToBounds = true
        self.bestTracksButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bestTracksButton.titleLabel?.minimumScaleFactor = 0.5
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

}
