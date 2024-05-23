//
//  TemporaryChatRoomHeaderBar.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 19.04.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SharedDesignSystem
import DomainUserInterface

public final class TemporaryChatRoomHeaderBar: BaseView, Touchable {
  private let profileImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
  }
  private let timerView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 20
  }
  private let timerIconView: UIImageView = UIImageView().then {
    $0.image = UIImage(asset: Images.threeOclock)
    $0.contentMode = .scaleAspectFit
  }
  public let timerLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.gray700.uiColor
  }
  private let reportButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let config = Config(image: UIImage(asset: Images.warning)!, isEnabled: true)
    $0.setState(config, for: .customImage)
    $0.currentState = .customImage
    $0.contentMode = .scaleAspectFit
  }
  private let closeButton: CancelButton = CancelButton()
  public let touchEventRelay: PublishRelay<TouchEventType> = .init()
  private let disposeBag = DisposeBag()
  
  public var profileData: PublishSubject<SomeoneProfile> = .init()
  
  public enum TouchEventType {
    case report
    case close
  }
  
  public override func configureUI() {
    super.configureUI()
    self.backgroundColor = SystemColor.basicWhite.uiColor
    setProfileImageView()
    setTimerView()
    setCloseButton()
    setReportButton()
  }
  
  public override func bind() {
    super.bind()
    
    profileData
      .bind(with: self) { owner, profile in
        owner.profileImageView.setProfileImageKF(
          urlString: profile.imageUrl,
          gender: profile.gender == .male ? .male : .female,
          scale: .s48)
//        if let profileImageURLstring = profile.imageUrl,
//          let profileImageURL = URL(string: profileImageURLstring) {
//          owner.profileImageView.kf.setImage(with: profileImageURL)
//        } else {
//          switch profile.gender {
//          case .male:
//            owner.profileImageView.image = UIImage(asset: Images.boyGray)
//          case .female:
//            owner.profileImageView.image = UIImage(asset: Images.girlGray)
//          }
//        }
      }
      .disposed(by: disposeBag)
    
    closeButton.rx.tapGesture()
      .map { _ in .close }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    reportButton.rx.tapGesture()
      .map { _ in .report }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func setProfileImageView() {
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.size.equalTo(48)
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    profileImageView.makeCircle(with: 48)
  }
  
  private func setTimerView() {
    addSubview(timerView)
    timerView.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(40)
      $0.width.equalTo(115)
    }
    
    timerView.addSubview(timerIconView)
    timerIconView.snp.makeConstraints {
      $0.size.equalTo(24)
      $0.leading.equalToSuperview().offset(15)
      $0.centerY.equalToSuperview()
    }
    
    timerView.addSubview(timerLabel)
    timerLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-17)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(timerIconView.snp.trailing).offset(6)
    }
    timerLabel.sizeToFit()
  }
  
  private func setReportButton() {
    addSubview(reportButton)
    reportButton.snp.makeConstraints {
      $0.trailing.equalTo(closeButton.snp.leading).offset(-16)
      $0.size.equalTo(24)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func setCloseButton() {
    addSubview(closeButton)
    closeButton.snp.makeConstraints {
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
    }
  }
}
