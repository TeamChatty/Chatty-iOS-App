//
//  ProfileEditMainCoordinator.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import Foundation
import Shared
import SharedDesignSystem
import FeatureProfileInterface

public final class ProfileEditMainCoordinator: BaseCoordinator, ProfileEditMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .profile(.editMain)
  }
  
  private let featureProfileDependencyProvider: FeatureProfileDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureProfileDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: ProfileEditMainCoordinator")
  }
  
  public override func start() {
    let reactor = ProfileEditMainReactor(getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase())
    let profileEditMainController = ProfileEditMainController(reactor: reactor)
    profileEditMainController.delegate = self
    navigationController.pushViewController(profileEditMainController, animated: true)
  }
}

extension ProfileEditMainCoordinator: ProfileEditModalDelegate {
  func dismissModal() {
    navigationController.dismiss(animated: true)
  }
  
  func successEdit(editType: ProfileEditType) {
    DispatchQueue.main.async {
      let vcCount = self.navigationController.viewControllers.count
      if let vc = self.navigationController.viewControllers[vcCount - 1] as? ProfileEditMainController {
        vc.reactor?.action.onNext(.editSuccessed(editType))
      }
      self.navigationController.dismiss(animated: true)
    }
  }
}

extension ProfileEditMainCoordinator: ProfileEditMainControllerDelegate {
  func presentImageGuide() {
    print("presentImageGuide")
  }
  
  func presentSelectImage() {
    print("presentSelectImage")
  }

  func presentNickname() {
    let profileEditNicknameModal = ProfileEditNicknameModal(
      reactor: ProfileEditTypeReactor(
        saveProfileNicknameUseCase: featureProfileDependencyProvider.makeSaveProfileNicknameUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase()
      )
    )
    
    profileEditNicknameModal.modalPresentationStyle = .pageSheet
    profileEditNicknameModal.delegate = self
    navigationController.present(profileEditNicknameModal, animated: true)
  }
  
  func presentAddress() {
    print("presentAddress")
  }
  
  func presentJob() {
    print("presentJob")
  }
  
  func presentSchool() {
    print("presentSchool")
  }
  
  func presentIntroduce() {
    print("presentIntroduce")
  }
  
  func presentMBTI() {
    print("presentMBTI")
  }
  
  func presentInterests() {
    print("presentInterests")
  }
  
  
}
