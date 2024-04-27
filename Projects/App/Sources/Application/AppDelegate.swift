import UIKit
import DataNetwork
import DataRepository
import DomainUser
import SharedDesignSystem
import SharedFirebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // 상태 표시줄 배경색 변경
//    UIView.appearance().backgroundColor = .red  // 원하는 배경색으로 변경
    
    // Navigation Bar 숨기기
    UINavigationBar.appearance().isHidden = true
    
    // 앱 커스텀 폰트 등록
    SharedDesignSystemFontFamily.registerAllCustomFonts()
    
    // Firebase info.plist 설정
    if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      AppFirebase.Firebase.configure(with: filePath)
    }
    
    // 푸쉬 알림 설정
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    application.registerForRemoteNotifications()
    AppMessagingService.Firebase.setDelegate(self)
    
    // 기기 식별 번호 생성 ( 앱 최초 설치 시 )
    let getDeviceIdUseCase = AppDIContainer.shared.makeDefaultGetDeviceIdUseCase()
    getDeviceIdUseCase.execute()
      .asObservable()
      .subscribe(onError: { _ in
        let saveDeviceIdUseCase = AppDIContainer.shared.makeDefaultSaveDeviceIdUseCase()
        let _ = saveDeviceIdUseCase.execute()
      })
      .dispose()
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  //  // Foreground(앱 켜진 상태)에서도 알림 오는 설정
  //  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
  //    completionHandler([.list, .banner])
  //  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let fcmToken else { return }
    let saveDeviceTokenUseCase = AppDIContainer.shared.makeDefaultSaveDeviceTokenUseCase()
    let _ = saveDeviceTokenUseCase.execute(deviceToken: fcmToken)
  }
}
