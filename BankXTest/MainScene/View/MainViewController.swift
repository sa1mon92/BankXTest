//
//  MainViewController.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 16.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var separatorView: GradientView!
    @IBOutlet weak var bestTracksButton: RoundedGradientButton!
    @IBOutlet weak var biographyButton: RoundedGradientButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
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
}
