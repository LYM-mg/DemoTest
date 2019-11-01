//  Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

protocol SkeletonFlowDelegate {
    func willBeginShowingSkeletons(withRootView rootView: UIView)
    func didShowSkeletons(withRootView rootView: UIView)
    func willBeginUpdatingSkeletons(withRootView rootView: UIView)
    func didUpdateSkeletons(withRootView rootView: UIView)
    func willBeginLayingSkeletonsIfNeeded(withRootView: UIView)
    func didLayoutSkeletonsIfNeeded(withRootView: UIView)
    func willBeginHidingSkeletons(withRootView rootView: UIView)
    func didHideSkeletons(withRootView rootView: UIView)
}

class SkeletonFlowHandler: SkeletonFlowDelegate {

    func willBeginShowingSkeletons(withRootView rootView: UIView) {
        rootView.addAppNotificationsObservers()
    }

    func didShowSkeletons(withRootView rootView: UIView) {
        printSkeletonHierarchy(in: rootView)
    }
    
    func willBeginUpdatingSkeletons(withRootView rootView: UIView) {
    }

    func didUpdateSkeletons(withRootView rootView: UIView) {
    }

    func willBeginLayingSkeletonsIfNeeded(withRootView: UIView) {
    }

    func didLayoutSkeletonsIfNeeded(withRootView: UIView) {
    }

    func willBeginHidingSkeletons(withRootView rootView: UIView) {
        rootView.removeAppNoticationsObserver()
    }

    func didHideSkeletons(withRootView rootView: UIView) {
        rootView.flowDelegate = nil
    }
}
