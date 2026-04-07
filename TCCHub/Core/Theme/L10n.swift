import Foundation
import SwiftUI

/// Typed wrapper around Localizable.strings for compile-time safety.
enum L10n {
    enum Auth {
        static let loginTitle    = key("auth.loginTitle")
        static let loginSubtitle = key("auth.loginSubtitle")
        static let email         = key("auth.email")
        static let password      = key("auth.password")
        static let signIn        = key("auth.signIn")
        static let signUp        = key("auth.signUp")
        static let forgot        = key("auth.forgot")
        static let registerTitle = key("auth.registerTitle")
        static let firstName     = key("auth.firstName")
        static let lastName      = key("auth.lastName")
        static let errorInvalid  = key("auth.errorInvalid")
        static let errorNetwork  = key("auth.errorNetwork")
        static let noAccount     = key("auth.noAccount")
    }

    enum Tabs {
        static let home          = key("tabs.home")
        static let courses       = key("tabs.courses")
        static let messages      = key("tabs.messages")
        static let notifications = key("tabs.notifications")
        static let profile       = key("tabs.profile")
    }

    enum Dashboard {
        static let greetingMorning   = key("dashboard.greetingMorning")
        static let greetingAfternoon = key("dashboard.greetingAfternoon")
        static let greetingEvening   = key("dashboard.greetingEvening")
        static let continueLearning  = key("dashboard.continueLearning")
        static let continueLearningSubtitle = key("dashboard.continueLearningSubtitle")
        static let upcoming          = key("dashboard.upcoming")
        static let upcomingSubtitle  = key("dashboard.upcomingSubtitle")
        static let stats             = key("dashboard.stats")
        static let statsSubtitle     = key("dashboard.statsSubtitle")
    }

    enum Courses {
        static let title       = key("courses.title")
        static let empty       = key("courses.empty")
        static let emptyHint   = key("courses.emptyHint")
        static let browse      = key("courses.browse")
        static let loadError   = key("courses.loadError")
    }

    enum CourseDetail {
        static let enroll      = key("courseDetail.enroll")
        static let curriculum  = key("courseDetail.curriculum")
    }

    enum Activity {
        static let markComplete         = key("activity.markComplete")
        static let completed            = key("activity.completed")
        static let quizPlaceholder      = key("activity.quizPlaceholder")
        static let assignmentPlaceholder = key("activity.assignmentPlaceholder")
        static let lessonPlaceholder    = key("activity.lessonPlaceholder")
    }

    enum Profile {
        static let title        = key("profile.title")
        static let grades       = key("profile.grades")
        static let certificates = key("profile.certificates")
        static let badges       = key("profile.badges")
        static let calendar     = key("profile.calendar")
        static let signOut      = key("profile.signOut")
    }

    enum Common {
        static let retry   = key("common.retry")
        static let loading = key("common.loading")
        static let error   = key("common.error")
        static let offline = key("common.offline")
    }

    enum Onboarding {
        static let skip       = key("onboarding.skip")
        static let next       = key("onboarding.next")
        static let getStarted = key("onboarding.getStarted")
        static let title1     = key("onboarding.title1")
        static let body1      = key("onboarding.body1")
        static let title2     = key("onboarding.title2")
        static let body2      = key("onboarding.body2")
        static let title3     = key("onboarding.title3")
        static let body3      = key("onboarding.body3")
    }

    private static func key(_ id: String) -> LocalizedStringKey {
        LocalizedStringKey(id)
    }
}
