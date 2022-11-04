import Foundation

final class PasswordChanger: PasswordChanging {
    private struct SuccessOrFailureTimer {
        let onSuccess: () -> Void
        let onFailure: (String) -> Void
        let timer: Timer
    }
    
    private static var pretendToSucceed = false
    
    private var suceessOrFailureTimer: SuccessOrFailureTimer?
    
    func change(securityToken: String, oldPassword: String, newPassword: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        print("Initiate Change Password:")
        print("securityToken = \(securityToken)")
        print("oldPassword = \(oldPassword)")
        print("newPassword = \(newPassword)")
        
        suceessOrFailureTimer = .init(onSuccess: onSuccess, onFailure: onFailure, timer: .scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.callSuccessOrFailure()
        }))
    }
    
    private func callSuccessOrFailure() {
        if PasswordChanger.pretendToSucceed {
            suceessOrFailureTimer?.onSuccess()
        } else {
            suceessOrFailureTimer?.onFailure("Sorry, something went wrong.")
        }
        PasswordChanger.pretendToSucceed.toggle()
        suceessOrFailureTimer?.timer.invalidate()
        suceessOrFailureTimer = nil
    }
}
