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
