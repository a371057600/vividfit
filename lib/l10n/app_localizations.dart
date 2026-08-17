import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @madeFitnessFun.
  ///
  /// In en, this message translates to:
  /// **'MADE FITNESS FUN'**
  String get madeFitnessFun;

  /// No description provided for @emailLogin.
  ///
  /// In en, this message translates to:
  /// **'Email Login'**
  String get emailLogin;

  /// No description provided for @phoneLogin.
  ///
  /// In en, this message translates to:
  /// **'Phone Login'**
  String get phoneLogin;

  /// No description provided for @accountLogin.
  ///
  /// In en, this message translates to:
  /// **'Account Login'**
  String get accountLogin;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterCorrectPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter the correct phone number'**
  String get enterCorrectPhoneNumber;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgetPassword;

  /// No description provided for @getCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Get Captcha'**
  String get getCaptcha;

  /// No description provided for @getCode.
  ///
  /// In en, this message translates to:
  /// **'Get code'**
  String get getCode;

  /// No description provided for @reGet.
  ///
  /// In en, this message translates to:
  /// **'Re-get'**
  String get reGet;

  /// No description provided for @setPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// No description provided for @getCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Code'**
  String get getCodeTitle;

  /// No description provided for @pleaseAgreePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the User Agreement and Privacy Policy'**
  String get pleaseAgreePrivacy;

  /// No description provided for @pleaseEnterAccountAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter account and password'**
  String get pleaseEnterAccountAndPassword;

  /// No description provided for @iHaveReadAndAgreeFitMonster.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Fit Monster'**
  String get iHaveReadAndAgreeFitMonster;

  /// No description provided for @userAgreementAndPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'<User Agreement and Privacy Policy>'**
  String get userAgreementAndPrivacyPolicy;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'<User Agreement>'**
  String get userAgreement;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'<Privacy Policy>'**
  String get privacyPolicy;

  /// No description provided for @incorrectAccountOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect account or password'**
  String get incorrectAccountOrPassword;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account disabled'**
  String get accountDisabled;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetConnectionOrNoInput.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection or no input'**
  String get noInternetConnectionOrNoInput;

  /// No description provided for @incorrectVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect verification code.'**
  String get incorrectVerificationCode;

  /// No description provided for @itSeemsNoInternet.
  ///
  /// In en, this message translates to:
  /// **'It seems that there is no internet'**
  String get itSeemsNoInternet;

  /// No description provided for @fitMonster.
  ///
  /// In en, this message translates to:
  /// **'Fit Monster'**
  String get fitMonster;

  /// No description provided for @madeFitnessFunSlogan.
  ///
  /// In en, this message translates to:
  /// **'Made fitness fun'**
  String get madeFitnessFunSlogan;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @sport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sport;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// No description provided for @timeMin.
  ///
  /// In en, this message translates to:
  /// **'Time/Min'**
  String get timeMin;

  /// No description provided for @met.
  ///
  /// In en, this message translates to:
  /// **'MET'**
  String get met;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'Kcal'**
  String get kcal;

  /// No description provided for @calorieConsumptionToday.
  ///
  /// In en, this message translates to:
  /// **'The calorie consumption today is '**
  String get calorieConsumptionToday;

  /// No description provided for @exerciseRecord.
  ///
  /// In en, this message translates to:
  /// **'Exercise Record'**
  String get exerciseRecord;

  /// No description provided for @bodyData.
  ///
  /// In en, this message translates to:
  /// **'Body Data'**
  String get bodyData;

  /// No description provided for @bodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index'**
  String get bodyMassIndex;

  /// No description provided for @burnRank.
  ///
  /// In en, this message translates to:
  /// **'Burn Rank'**
  String get burnRank;

  /// No description provided for @ranks.
  ///
  /// In en, this message translates to:
  /// **'Ranks'**
  String get ranks;

  /// No description provided for @todaysBurn.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Burn'**
  String get todaysBurn;

  /// No description provided for @kcalCons.
  ///
  /// In en, this message translates to:
  /// **'Kcal cons'**
  String get kcalCons;

  /// No description provided for @checkInTask.
  ///
  /// In en, this message translates to:
  /// **'Check-in Task'**
  String get checkInTask;

  /// No description provided for @dailyTask.
  ///
  /// In en, this message translates to:
  /// **'Daily Task'**
  String get dailyTask;

  /// No description provided for @aiPt.
  ///
  /// In en, this message translates to:
  /// **'AI PT'**
  String get aiPt;

  /// No description provided for @fitnessGoals.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goals'**
  String get fitnessGoals;

  /// No description provided for @onlineStore.
  ///
  /// In en, this message translates to:
  /// **'Online Store'**
  String get onlineStore;

  /// No description provided for @sportsGoal.
  ///
  /// In en, this message translates to:
  /// **'Sports Goal'**
  String get sportsGoal;

  /// No description provided for @sportsReport.
  ///
  /// In en, this message translates to:
  /// **'Sports Report'**
  String get sportsReport;

  /// No description provided for @deviceManual.
  ///
  /// In en, this message translates to:
  /// **'Device Manual'**
  String get deviceManual;

  /// No description provided for @onlineManual.
  ///
  /// In en, this message translates to:
  /// **'Online Manual'**
  String get onlineManual;

  /// No description provided for @underWeight.
  ///
  /// In en, this message translates to:
  /// **'Under Weight'**
  String get underWeight;

  /// No description provided for @normalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal Weight'**
  String get normalWeight;

  /// No description provided for @overWeight.
  ///
  /// In en, this message translates to:
  /// **'Over Weight'**
  String get overWeight;

  /// No description provided for @obesity.
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get obesity;

  /// No description provided for @bodyMassIndexColon.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index:'**
  String get bodyMassIndexColon;

  /// No description provided for @physicalFitnessAssessment.
  ///
  /// In en, this message translates to:
  /// **'Physical fitness assessment:'**
  String get physicalFitnessAssessment;

  /// No description provided for @bmiLowWeight.
  ///
  /// In en, this message translates to:
  /// **'Low body weight, may pose health risks such as malnutrition'**
  String get bmiLowWeight;

  /// No description provided for @bmiNormalRange.
  ///
  /// In en, this message translates to:
  /// **'Normal range, indicating good physical condition'**
  String get bmiNormalRange;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight, pay attention to diet and exercise'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese body type, with risk of chronic diseases'**
  String get bmiObese;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @fitnessAi.
  ///
  /// In en, this message translates to:
  /// **'Fitness AI'**
  String get fitnessAi;

  /// No description provided for @medal.
  ///
  /// In en, this message translates to:
  /// **'Medal'**
  String get medal;

  /// No description provided for @medalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medals'**
  String get medalsTitle;

  /// No description provided for @medalTotal.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get medalTotal;

  /// No description provided for @pleaseTryToGetMedal.
  ///
  /// In en, this message translates to:
  /// **'Please try to get a medal'**
  String get pleaseTryToGetMedal;

  /// No description provided for @medalDetails.
  ///
  /// In en, this message translates to:
  /// **'Medal details'**
  String get medalDetails;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @spinBike.
  ///
  /// In en, this message translates to:
  /// **'Spin    Bike'**
  String get spinBike;

  /// No description provided for @treadmillMachine.
  ///
  /// In en, this message translates to:
  /// **'Treadmill Machine'**
  String get treadmillMachine;

  /// No description provided for @ellipticalMachine.
  ///
  /// In en, this message translates to:
  /// **'Elliptical Machine'**
  String get ellipticalMachine;

  /// No description provided for @rowingMachine.
  ///
  /// In en, this message translates to:
  /// **'Rowing Machine'**
  String get rowingMachine;

  /// No description provided for @strengthStation.
  ///
  /// In en, this message translates to:
  /// **'Strength Station'**
  String get strengthStation;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @rankUnit.
  ///
  /// In en, this message translates to:
  /// **''**
  String get rankUnit;

  /// No description provided for @achieved.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get achieved;

  /// No description provided for @unachieved.
  ///
  /// In en, this message translates to:
  /// **'Unachieved'**
  String get unachieved;

  /// No description provided for @customized.
  ///
  /// In en, this message translates to:
  /// **'Customized'**
  String get customized;

  /// No description provided for @unsatisfactory.
  ///
  /// In en, this message translates to:
  /// **'Unsatisfactory'**
  String get unsatisfactory;

  /// No description provided for @goalSetting.
  ///
  /// In en, this message translates to:
  /// **'Goal Setting'**
  String get goalSetting;

  /// No description provided for @annualSportsReview.
  ///
  /// In en, this message translates to:
  /// **'Annual Sports Review'**
  String get annualSportsReview;

  /// No description provided for @manualDownload.
  ///
  /// In en, this message translates to:
  /// **'Manual Download'**
  String get manualDownload;

  /// No description provided for @jdShopping.
  ///
  /// In en, this message translates to:
  /// **'JD Selection'**
  String get jdShopping;

  /// No description provided for @reasonableGoalSetting.
  ///
  /// In en, this message translates to:
  /// **'Set suitable goals'**
  String get reasonableGoalSetting;

  /// No description provided for @annualSportsSummary.
  ///
  /// In en, this message translates to:
  /// **'Annual Sports Summary'**
  String get annualSportsSummary;

  /// No description provided for @sportsGoalSetting.
  ///
  /// In en, this message translates to:
  /// **'Sports Goal Setting'**
  String get sportsGoalSetting;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading....'**
  String get loading;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @genderSelection.
  ///
  /// In en, this message translates to:
  /// **'Gender Selection'**
  String get genderSelection;

  /// No description provided for @dateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get dateSelection;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @selectDateBeforeToday.
  ///
  /// In en, this message translates to:
  /// **'Please select date before today'**
  String get selectDateBeforeToday;

  /// No description provided for @aerobic.
  ///
  /// In en, this message translates to:
  /// **'Aerobic'**
  String get aerobic;

  /// No description provided for @anaerobic.
  ///
  /// In en, this message translates to:
  /// **'Anaerobic'**
  String get anaerobic;

  /// No description provided for @rehab.
  ///
  /// In en, this message translates to:
  /// **'Rehab'**
  String get rehab;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @hiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get hiit;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @shaping.
  ///
  /// In en, this message translates to:
  /// **'Shaping'**
  String get shaping;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @stage1.
  ///
  /// In en, this message translates to:
  /// **'Stage 1'**
  String get stage1;

  /// No description provided for @stage2.
  ///
  /// In en, this message translates to:
  /// **'Stage 2'**
  String get stage2;

  /// No description provided for @stage3.
  ///
  /// In en, this message translates to:
  /// **'Stage 3'**
  String get stage3;

  /// No description provided for @aerobicContent.
  ///
  /// In en, this message translates to:
  /// **'Oxygen-based endurance exercises: running, swimming, cycling, aerobics, ball games'**
  String get aerobicContent;

  /// No description provided for @anaerobicContent.
  ///
  /// In en, this message translates to:
  /// **'High-intensity strength training: weightlifting, resistance training, push-ups, squats, sprints, planks'**
  String get anaerobicContent;

  /// No description provided for @rehabContent.
  ///
  /// In en, this message translates to:
  /// **'Recovery exercises: phased training for injuries, cardiac rehab under medical supervision'**
  String get rehabContent;

  /// No description provided for @basicArea.
  ///
  /// In en, this message translates to:
  /// **'Seniors/Pregnant/Rehab'**
  String get basicArea;

  /// No description provided for @moderateArea.
  ///
  /// In en, this message translates to:
  /// **'General fitness/Weight loss'**
  String get moderateArea;

  /// No description provided for @hiitArea.
  ///
  /// In en, this message translates to:
  /// **'Advanced fitness/Busy schedules'**
  String get hiitArea;

  /// No description provided for @strengthArea.
  ///
  /// In en, this message translates to:
  /// **'Builds strength & bone density'**
  String get strengthArea;

  /// No description provided for @shapingArea.
  ///
  /// In en, this message translates to:
  /// **'Shapes muscles & posture'**
  String get shapingArea;

  /// No description provided for @powerArea.
  ///
  /// In en, this message translates to:
  /// **'Explosive power training: sprints, box jumps'**
  String get powerArea;

  /// No description provided for @stage1Area.
  ///
  /// In en, this message translates to:
  /// **'Prevents muscle atrophy, maintains mobility'**
  String get stage1Area;

  /// No description provided for @stage2Area.
  ///
  /// In en, this message translates to:
  /// **'Strengthens joints & stability'**
  String get stage2Area;

  /// No description provided for @stage3Area.
  ///
  /// In en, this message translates to:
  /// **'Restores daily functions'**
  String get stage3Area;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @virtualCoach.
  ///
  /// In en, this message translates to:
  /// **'Virtual Coach'**
  String get virtualCoach;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @sportsSettings.
  ///
  /// In en, this message translates to:
  /// **'Sports Settings'**
  String get sportsSettings;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurity;

  /// No description provided for @softwareUpdate.
  ///
  /// In en, this message translates to:
  /// **'Software Update'**
  String get softwareUpdate;

  /// No description provided for @userPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'User Privacy Policy'**
  String get userPrivacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @reLogin.
  ///
  /// In en, this message translates to:
  /// **'Re-login'**
  String get reLogin;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @basicSettings.
  ///
  /// In en, this message translates to:
  /// **'Basic Settings'**
  String get basicSettings;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @setNickName.
  ///
  /// In en, this message translates to:
  /// **'Set NickName'**
  String get setNickName;

  /// No description provided for @theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname.
  ///
  /// In en, this message translates to:
  /// **'The nickname is used to hide your real name. Other users in the system can see your nickname.'**
  String
  get theNicknameIsUsedToHideYourRealNameOtherUsersInTheSystemCanSeeYourNickname;

  /// No description provided for @theNumberOfWordsShouldNotBeLessThan3PleaseReEnter.
  ///
  /// In en, this message translates to:
  /// **'The number of words should not be less than 3, please re-enter'**
  String get theNumberOfWordsShouldNotBeLessThan3PleaseReEnter;

  /// No description provided for @thereAreMoreThan10WordsPleaseReEnter.
  ///
  /// In en, this message translates to:
  /// **'There are more than 10 words, please re-enter'**
  String get thereAreMoreThan10WordsPleaseReEnter;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @pictureSelect.
  ///
  /// In en, this message translates to:
  /// **'Picture Select'**
  String get pictureSelect;

  /// No description provided for @returnButton.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnButton;

  /// No description provided for @serviceHotline.
  ///
  /// In en, this message translates to:
  /// **'Service Hotline'**
  String get serviceHotline;

  /// No description provided for @legalInformation.
  ///
  /// In en, this message translates to:
  /// **'Legal Information'**
  String get legalInformation;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @courseProposal.
  ///
  /// In en, this message translates to:
  /// **'Course Proposal'**
  String get courseProposal;

  /// No description provided for @courseDescription.
  ///
  /// In en, this message translates to:
  /// **'Course Description'**
  String get courseDescription;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @sportCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get sportCount;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// No description provided for @courseTraining.
  ///
  /// In en, this message translates to:
  /// **'Course Training'**
  String get courseTraining;

  /// No description provided for @realScene.
  ///
  /// In en, this message translates to:
  /// **'Real Scene'**
  String get realScene;

  /// No description provided for @cityAdventure.
  ///
  /// In en, this message translates to:
  /// **'City Adventure'**
  String get cityAdventure;

  /// No description provided for @recreationalFitness.
  ///
  /// In en, this message translates to:
  /// **'Recreational Fitness'**
  String get recreationalFitness;

  /// No description provided for @deviceConnection.
  ///
  /// In en, this message translates to:
  /// **'Device Connection'**
  String get deviceConnection;

  /// No description provided for @pleaseConnectDevice.
  ///
  /// In en, this message translates to:
  /// **'Please connect the device first'**
  String get pleaseConnectDevice;

  /// No description provided for @deviceSelection.
  ///
  /// In en, this message translates to:
  /// **'Device Selection'**
  String get deviceSelection;

  /// No description provided for @pleaseOpenBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Please turn on Bluetooth'**
  String get pleaseOpenBluetooth;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @deviceDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Device disconnected'**
  String get deviceDisconnected;

  /// No description provided for @deviceSearch.
  ///
  /// In en, this message translates to:
  /// **'Device Search'**
  String get deviceSearch;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// No description provided for @pleaseMakeSureDeviceOn.
  ///
  /// In en, this message translates to:
  /// **'Please make sure the device is turned on, Bluetooth is enabled'**
  String get pleaseMakeSureDeviceOn;

  /// No description provided for @searchedDevices.
  ///
  /// In en, this message translates to:
  /// **'Searched Devices'**
  String get searchedDevices;

  /// No description provided for @reScan.
  ///
  /// In en, this message translates to:
  /// **'Re-scan'**
  String get reScan;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @searchDevice.
  ///
  /// In en, this message translates to:
  /// **'Search Device'**
  String get searchDevice;

  /// No description provided for @connectDevice.
  ///
  /// In en, this message translates to:
  /// **'Connect Device'**
  String get connectDevice;

  /// No description provided for @deleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get deleteDevice;

  /// No description provided for @warningDeleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Warning: Delete the device from the list?'**
  String get warningDeleteDevice;

  /// No description provided for @coursePlayPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Course Play Placeholder'**
  String get coursePlayPlaceholder;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get courseTitle;

  /// No description provided for @courseEndedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Course Ended'**
  String get courseEndedPlaceholder;

  /// No description provided for @keyPoint.
  ///
  /// In en, this message translates to:
  /// **'Key Point'**
  String get keyPoint;

  /// No description provided for @deviceSkipping.
  ///
  /// In en, this message translates to:
  /// **'Skipping'**
  String get deviceSkipping;

  /// No description provided for @deviceGrip.
  ///
  /// In en, this message translates to:
  /// **'Grip'**
  String get deviceGrip;

  /// No description provided for @deviceDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get deviceDumbbell;

  /// No description provided for @deviceAdjDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Adj-Dumbbell'**
  String get deviceAdjDumbbell;

  /// No description provided for @devicePushUp.
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get devicePushUp;

  /// No description provided for @deviceKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get deviceKettlebell;

  /// No description provided for @deviceGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get deviceGame;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @courseActionImage.
  ///
  /// In en, this message translates to:
  /// **'Course Action Image'**
  String get courseActionImage;

  /// No description provided for @currentSet.
  ///
  /// In en, this message translates to:
  /// **'Current Set'**
  String get currentSet;

  /// No description provided for @actionName.
  ///
  /// In en, this message translates to:
  /// **'Action Name'**
  String get actionName;

  /// No description provided for @confirmExitCourse.
  ///
  /// In en, this message translates to:
  /// **'Confirm exit course?'**
  String get confirmExitCourse;

  /// No description provided for @trackAnimation.
  ///
  /// In en, this message translates to:
  /// **'Track Animation'**
  String get trackAnimation;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// No description provided for @courseImage.
  ///
  /// In en, this message translates to:
  /// **'Course Image'**
  String get courseImage;

  /// No description provided for @courseDetailsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Course details placeholder'**
  String get courseDetailsPlaceholder;

  /// No description provided for @entryCourse.
  ///
  /// In en, this message translates to:
  /// **'Entry Course'**
  String get entryCourse;

  /// No description provided for @startPlaying.
  ///
  /// In en, this message translates to:
  /// **'Start Playing'**
  String get startPlaying;

  /// No description provided for @downloadCourse.
  ///
  /// In en, this message translates to:
  /// **'Download Course'**
  String get downloadCourse;

  /// No description provided for @courseList.
  ///
  /// In en, this message translates to:
  /// **'Course List'**
  String get courseList;

  /// No description provided for @realscene.
  ///
  /// In en, this message translates to:
  /// **'Realscene'**
  String get realscene;

  /// No description provided for @gameContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Game content placeholder'**
  String get gameContentPlaceholder;

  /// No description provided for @exitGame.
  ///
  /// In en, this message translates to:
  /// **'Exit Game'**
  String get exitGame;

  /// No description provided for @areYouSureWantToExit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get areYouSureWantToExit;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @kcalUnit.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcalUnit;

  /// No description provided for @kmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get bpm;

  /// No description provided for @defaultNickName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultNickName;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @placeholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get placeholderTitle;

  /// No description provided for @spinBikeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Bike'**
  String get spinBikeSubtitle;

  /// No description provided for @treadmillMachineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get treadmillMachineSubtitle;

  /// No description provided for @ellipticalMachineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Elliptical Trainer'**
  String get ellipticalMachineSubtitle;

  /// No description provided for @rowingMachineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rowing Machine'**
  String get rowingMachineSubtitle;

  /// No description provided for @strengthStationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Strength Station'**
  String get strengthStationSubtitle;

  /// No description provided for @quickStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStartSubtitle;

  /// No description provided for @courseTrainingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Course Training'**
  String get courseTrainingSubtitle;

  /// No description provided for @realSceneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real Scene'**
  String get realSceneSubtitle;

  /// No description provided for @cityAdventureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'City Adventure'**
  String get cityAdventureSubtitle;

  /// No description provided for @recreationalFitnessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recreational Fitness'**
  String get recreationalFitnessSubtitle;

  /// No description provided for @coachMichael.
  ///
  /// In en, this message translates to:
  /// **'Michael'**
  String get coachMichael;

  /// No description provided for @coachVicky.
  ///
  /// In en, this message translates to:
  /// **'Vicky'**
  String get coachVicky;

  /// No description provided for @coachFiona.
  ///
  /// In en, this message translates to:
  /// **'Fiona'**
  String get coachFiona;

  /// No description provided for @coachPaul.
  ///
  /// In en, this message translates to:
  /// **'Paul'**
  String get coachPaul;

  /// No description provided for @coachLucy.
  ///
  /// In en, this message translates to:
  /// **'Lucy'**
  String get coachLucy;

  /// No description provided for @coachJack.
  ///
  /// In en, this message translates to:
  /// **'Jack'**
  String get coachJack;

  /// No description provided for @coachCarol.
  ///
  /// In en, this message translates to:
  /// **'Carol'**
  String get coachCarol;

  /// No description provided for @copyrightInfo.
  ///
  /// In en, this message translates to:
  /// **'Dongguan Quanchuang Optoelectronics Industrial Co., Ltd. All Rights Reserved @2022-2024'**
  String get copyrightInfo;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: {message}'**
  String networkError(String message);

  /// No description provided for @devOneClickLogin.
  ///
  /// In en, this message translates to:
  /// **'DEV One-Click Login'**
  String get devOneClickLogin;

  /// No description provided for @permissionRequestInstructions.
  ///
  /// In en, this message translates to:
  /// **'Permission Request Instructions'**
  String get permissionRequestInstructions;

  /// No description provided for @permissionDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'   \'Location Permission\' and \'Nearby Device Permission\': When you use Bluetooth pairing and other functions, we need to request and obtain this permission to complete the pairing and use of Bluetooth devices. If you do not agree to this permission, it may affect the normal use of Fitness Monster. You can access system settings at any time to manage your system permissions. If refused, no reminder will be given within 48 hours.\n     This notice comes from Article 6 of the \"User Agreement and Privacy Policy\".'**
  String get permissionDialogMessage;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @disagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// No description provided for @pleaseResumeTheMachine.
  ///
  /// In en, this message translates to:
  /// **'Please resume the machine'**
  String get pleaseResumeTheMachine;

  /// No description provided for @deviceInMotionPleaseStop.
  ///
  /// In en, this message translates to:
  /// **'The device is in motion, please stop the device before starting quick start'**
  String get deviceInMotionPleaseStop;

  /// No description provided for @noDataTapToRetry.
  ///
  /// In en, this message translates to:
  /// **'No data? Tap to retry'**
  String get noDataTapToRetry;

  /// No description provided for @finishedTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get finishedTime;

  /// No description provided for @finishedDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get finishedDistance;

  /// No description provided for @finishedCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get finishedCalories;

  /// No description provided for @finishedCounts.
  ///
  /// In en, this message translates to:
  /// **'Counts'**
  String get finishedCounts;

  /// No description provided for @trainingIntensity.
  ///
  /// In en, this message translates to:
  /// **'Training Intensity'**
  String get trainingIntensity;

  /// No description provided for @courseRating.
  ///
  /// In en, this message translates to:
  /// **'Course Rating'**
  String get courseRating;

  /// No description provided for @speedBarChart.
  ///
  /// In en, this message translates to:
  /// **'Speed Bar Chart'**
  String get speedBarChart;

  /// No description provided for @courseOver.
  ///
  /// In en, this message translates to:
  /// **'Course Over'**
  String get courseOver;

  /// No description provided for @finishedSportTime.
  ///
  /// In en, this message translates to:
  /// **'Sport Time'**
  String get finishedSportTime;

  /// No description provided for @finishedTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get finishedTotalDistance;

  /// No description provided for @finishedTotalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get finishedTotalCalories;

  /// No description provided for @finishedPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get finishedPace;

  /// No description provided for @finishedMaxPace.
  ///
  /// In en, this message translates to:
  /// **'Max Pace'**
  String get finishedMaxPace;

  /// No description provided for @finishedAvgCadence.
  ///
  /// In en, this message translates to:
  /// **'Avg Cadence'**
  String get finishedAvgCadence;

  /// No description provided for @finishedMaxCadence.
  ///
  /// In en, this message translates to:
  /// **'Max Cadence'**
  String get finishedMaxCadence;

  /// No description provided for @finishedMaxHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Max Heart Rate'**
  String get finishedMaxHeartRate;

  /// No description provided for @finishedTotalCadence.
  ///
  /// In en, this message translates to:
  /// **'Total Cadence'**
  String get finishedTotalCadence;

  /// No description provided for @finishedRestTime.
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get finishedRestTime;

  /// No description provided for @finishedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get finishedCompletion;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @stability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get stability;

  /// No description provided for @pedalingEff.
  ///
  /// In en, this message translates to:
  /// **'Pacing Eff'**
  String get pedalingEff;

  /// No description provided for @cadence.
  ///
  /// In en, this message translates to:
  /// **'Cadence'**
  String get cadence;

  /// No description provided for @moderateChallenge.
  ///
  /// In en, this message translates to:
  /// **'Moderate Challenge'**
  String get moderateChallenge;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @sportPaused.
  ///
  /// In en, this message translates to:
  /// **'Sport Paused'**
  String get sportPaused;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @exitCourse.
  ///
  /// In en, this message translates to:
  /// **'Exit Course'**
  String get exitCourse;

  /// No description provided for @leaveLevelA.
  ///
  /// In en, this message translates to:
  /// **'Level A'**
  String get leaveLevelA;

  /// No description provided for @leaveLevelB.
  ///
  /// In en, this message translates to:
  /// **'Level B'**
  String get leaveLevelB;

  /// No description provided for @leaveLevelC.
  ///
  /// In en, this message translates to:
  /// **'Level C'**
  String get leaveLevelC;

  /// No description provided for @leaveLevelD.
  ///
  /// In en, this message translates to:
  /// **'Level D'**
  String get leaveLevelD;

  /// No description provided for @leaveLevelE.
  ///
  /// In en, this message translates to:
  /// **'Level E'**
  String get leaveLevelE;

  /// No description provided for @leisurely.
  ///
  /// In en, this message translates to:
  /// **'Leisurely'**
  String get leisurely;

  /// No description provided for @lightAdapt.
  ///
  /// In en, this message translates to:
  /// **'Light Adapt'**
  String get lightAdapt;

  /// No description provided for @easyAdaptation.
  ///
  /// In en, this message translates to:
  /// **'Easy Adaptation'**
  String get easyAdaptation;

  /// No description provided for @moderateImprovement.
  ///
  /// In en, this message translates to:
  /// **'Moderate Improvement'**
  String get moderateImprovement;

  /// No description provided for @intenseLoad.
  ///
  /// In en, this message translates to:
  /// **'Intense Load'**
  String get intenseLoad;

  /// No description provided for @extremeBreakthrough.
  ///
  /// In en, this message translates to:
  /// **'Extreme Breakthrough'**
  String get extremeBreakthrough;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @unionId.
  ///
  /// In en, this message translates to:
  /// **'Unionid'**
  String get unionId;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @chooseOtherVerification.
  ///
  /// In en, this message translates to:
  /// **'Choose Other Verification Methods'**
  String get chooseOtherVerification;

  /// No description provided for @confirmOwnOperation.
  ///
  /// In en, this message translates to:
  /// **'To confirm that it is your own operation, please verify your identity.'**
  String get confirmOwnOperation;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code Sent'**
  String get codeSent;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get passwordMismatch;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get passwordRequirements;

  /// No description provided for @atLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Chars;

  /// No description provided for @bindNewPhone.
  ///
  /// In en, this message translates to:
  /// **'Bind a new phone'**
  String get bindNewPhone;

  /// No description provided for @bindNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Bind a new email'**
  String get bindNewEmail;

  /// No description provided for @accountBound.
  ///
  /// In en, this message translates to:
  /// **'The account has been bound'**
  String get accountBound;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @unbound.
  ///
  /// In en, this message translates to:
  /// **'Unbound'**
  String get unbound;

  /// No description provided for @warningDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Warning: Do you want to cancel your account so that you will delete personal information?'**
  String get warningDeleteAccount;

  /// No description provided for @rankTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get rankTotal;

  /// No description provided for @rankAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get rankAnnual;

  /// No description provided for @rankMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get rankMonthly;

  /// No description provided for @rankSelectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select Device'**
  String get rankSelectDevice;

  /// No description provided for @rankCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get rankCalories;

  /// No description provided for @rankCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get rankCount;

  /// No description provided for @rankNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get rankNoData;

  /// No description provided for @rankPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get rankPageTitle;

  /// No description provided for @rankAllDevice.
  ///
  /// In en, this message translates to:
  /// **'All Device'**
  String get rankAllDevice;

  /// No description provided for @rankSpinBike.
  ///
  /// In en, this message translates to:
  /// **'Spin Bike'**
  String get rankSpinBike;

  /// No description provided for @rankTreadmill.
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get rankTreadmill;

  /// No description provided for @rankElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get rankElliptical;

  /// No description provided for @rankRower.
  ///
  /// In en, this message translates to:
  /// **'Rower'**
  String get rankRower;

  /// No description provided for @pictureCropping.
  ///
  /// In en, this message translates to:
  /// **'Picture Cropping'**
  String get pictureCropping;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get uploading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait'**
  String get pleaseWait;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload Success'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please check network'**
  String get uploadFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
