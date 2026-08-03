// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 bool get isLoading; bool get isAuthenticated; bool get agreedToPrivacy; String? get accessToken; int? get userId; FitUserInfo? get userInfo; String? get errorMessage; String get emailAccount; String get password; String get changepassword; String get countryCode; int get phoneNumber; String get captcha; String get wechatCode; int get countdown; bool get reGetCode; bool get reGetCode2; bool get showPassword; int get loginType; bool get ishasInternet; int get languageNum;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.agreedToPrivacy, agreedToPrivacy) || other.agreedToPrivacy == agreedToPrivacy)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.emailAccount, emailAccount) || other.emailAccount == emailAccount)&&(identical(other.password, password) || other.password == password)&&(identical(other.changepassword, changepassword) || other.changepassword == changepassword)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.captcha, captcha) || other.captcha == captcha)&&(identical(other.wechatCode, wechatCode) || other.wechatCode == wechatCode)&&(identical(other.countdown, countdown) || other.countdown == countdown)&&(identical(other.reGetCode, reGetCode) || other.reGetCode == reGetCode)&&(identical(other.reGetCode2, reGetCode2) || other.reGetCode2 == reGetCode2)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.loginType, loginType) || other.loginType == loginType)&&(identical(other.ishasInternet, ishasInternet) || other.ishasInternet == ishasInternet)&&(identical(other.languageNum, languageNum) || other.languageNum == languageNum));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isAuthenticated,agreedToPrivacy,accessToken,userId,userInfo,errorMessage,emailAccount,password,changepassword,countryCode,phoneNumber,captcha,wechatCode,countdown,reGetCode,reGetCode2,showPassword,loginType,ishasInternet,languageNum]);

@override
String toString() {
  return 'AuthState(isLoading: $isLoading, isAuthenticated: $isAuthenticated, agreedToPrivacy: $agreedToPrivacy, accessToken: $accessToken, userId: $userId, userInfo: $userInfo, errorMessage: $errorMessage, emailAccount: $emailAccount, password: $password, changepassword: $changepassword, countryCode: $countryCode, phoneNumber: $phoneNumber, captcha: $captcha, wechatCode: $wechatCode, countdown: $countdown, reGetCode: $reGetCode, reGetCode2: $reGetCode2, showPassword: $showPassword, loginType: $loginType, ishasInternet: $ishasInternet, languageNum: $languageNum)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isAuthenticated, bool agreedToPrivacy, String? accessToken, int? userId, FitUserInfo? userInfo, String? errorMessage, String emailAccount, String password, String changepassword, String countryCode, int phoneNumber, String captcha, String wechatCode, int countdown, bool reGetCode, bool reGetCode2, bool showPassword, int loginType, bool ishasInternet, int languageNum
});


$FitUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isAuthenticated = null,Object? agreedToPrivacy = null,Object? accessToken = freezed,Object? userId = freezed,Object? userInfo = freezed,Object? errorMessage = freezed,Object? emailAccount = null,Object? password = null,Object? changepassword = null,Object? countryCode = null,Object? phoneNumber = null,Object? captcha = null,Object? wechatCode = null,Object? countdown = null,Object? reGetCode = null,Object? reGetCode2 = null,Object? showPassword = null,Object? loginType = null,Object? ishasInternet = null,Object? languageNum = null,}) {
  return _then(AuthState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,agreedToPrivacy: null == agreedToPrivacy ? _self.agreedToPrivacy : agreedToPrivacy // ignore: cast_nullable_to_non_nullable
as bool,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as FitUserInfo?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,emailAccount: null == emailAccount ? _self.emailAccount : emailAccount // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,changepassword: null == changepassword ? _self.changepassword : changepassword // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as int,captcha: null == captcha ? _self.captcha : captcha // ignore: cast_nullable_to_non_nullable
as String,wechatCode: null == wechatCode ? _self.wechatCode : wechatCode // ignore: cast_nullable_to_non_nullable
as String,countdown: null == countdown ? _self.countdown : countdown // ignore: cast_nullable_to_non_nullable
as int,reGetCode: null == reGetCode ? _self.reGetCode : reGetCode // ignore: cast_nullable_to_non_nullable
as bool,reGetCode2: null == reGetCode2 ? _self.reGetCode2 : reGetCode2 // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,loginType: null == loginType ? _self.loginType : loginType // ignore: cast_nullable_to_non_nullable
as int,ishasInternet: null == ishasInternet ? _self.ishasInternet : ishasInternet // ignore: cast_nullable_to_non_nullable
as bool,languageNum: null == languageNum ? _self.languageNum : languageNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $FitUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isAuthenticated,  bool agreedToPrivacy,  String? accessToken,  int? userId,  FitUserInfo? userInfo,  String? errorMessage,  String emailAccount,  String password,  String changepassword,  String countryCode,  int phoneNumber,  String captcha,  String wechatCode,  int countdown,  bool reGetCode,  bool reGetCode2,  bool showPassword,  int loginType,  bool ishasInternet,  int languageNum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.isLoading,_that.isAuthenticated,_that.agreedToPrivacy,_that.accessToken,_that.userId,_that.userInfo,_that.errorMessage,_that.emailAccount,_that.password,_that.changepassword,_that.countryCode,_that.phoneNumber,_that.captcha,_that.wechatCode,_that.countdown,_that.reGetCode,_that.reGetCode2,_that.showPassword,_that.loginType,_that.ishasInternet,_that.languageNum);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isAuthenticated,  bool agreedToPrivacy,  String? accessToken,  int? userId,  FitUserInfo? userInfo,  String? errorMessage,  String emailAccount,  String password,  String changepassword,  String countryCode,  int phoneNumber,  String captcha,  String wechatCode,  int countdown,  bool reGetCode,  bool reGetCode2,  bool showPassword,  int loginType,  bool ishasInternet,  int languageNum)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.isLoading,_that.isAuthenticated,_that.agreedToPrivacy,_that.accessToken,_that.userId,_that.userInfo,_that.errorMessage,_that.emailAccount,_that.password,_that.changepassword,_that.countryCode,_that.phoneNumber,_that.captcha,_that.wechatCode,_that.countdown,_that.reGetCode,_that.reGetCode2,_that.showPassword,_that.loginType,_that.ishasInternet,_that.languageNum);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isAuthenticated,  bool agreedToPrivacy,  String? accessToken,  int? userId,  FitUserInfo? userInfo,  String? errorMessage,  String emailAccount,  String password,  String changepassword,  String countryCode,  int phoneNumber,  String captcha,  String wechatCode,  int countdown,  bool reGetCode,  bool reGetCode2,  bool showPassword,  int loginType,  bool ishasInternet,  int languageNum)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.isLoading,_that.isAuthenticated,_that.agreedToPrivacy,_that.accessToken,_that.userId,_that.userInfo,_that.errorMessage,_that.emailAccount,_that.password,_that.changepassword,_that.countryCode,_that.phoneNumber,_that.captcha,_that.wechatCode,_that.countdown,_that.reGetCode,_that.reGetCode2,_that.showPassword,_that.loginType,_that.ishasInternet,_that.languageNum);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.isLoading = false, this.isAuthenticated = false, this.agreedToPrivacy = false, this.accessToken, this.userId, this.userInfo, this.errorMessage, this.emailAccount = '', this.password = '', this.changepassword = '', this.countryCode = '', this.phoneNumber = 0, this.captcha = '', this.wechatCode = '', this.countdown = 60, this.reGetCode = true, this.reGetCode2 = true, this.showPassword = true, this.loginType = 0, this.ishasInternet = false, this.languageNum = 0});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isAuthenticated;
@override@JsonKey() final  bool agreedToPrivacy;
@override final  String? accessToken;
@override final  int? userId;
@override final  FitUserInfo? userInfo;
@override final  String? errorMessage;
@override@JsonKey() final  String emailAccount;
@override@JsonKey() final  String password;
@override@JsonKey() final  String changepassword;
@override@JsonKey() final  String countryCode;
@override@JsonKey() final  int phoneNumber;
@override@JsonKey() final  String captcha;
@override@JsonKey() final  String wechatCode;
@override@JsonKey() final  int countdown;
@override@JsonKey() final  bool reGetCode;
@override@JsonKey() final  bool reGetCode2;
@override@JsonKey() final  bool showPassword;
@override@JsonKey() final  int loginType;
@override@JsonKey() final  bool ishasInternet;
@override@JsonKey() final  int languageNum;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.agreedToPrivacy, agreedToPrivacy) || other.agreedToPrivacy == agreedToPrivacy)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.emailAccount, emailAccount) || other.emailAccount == emailAccount)&&(identical(other.password, password) || other.password == password)&&(identical(other.changepassword, changepassword) || other.changepassword == changepassword)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.captcha, captcha) || other.captcha == captcha)&&(identical(other.wechatCode, wechatCode) || other.wechatCode == wechatCode)&&(identical(other.countdown, countdown) || other.countdown == countdown)&&(identical(other.reGetCode, reGetCode) || other.reGetCode == reGetCode)&&(identical(other.reGetCode2, reGetCode2) || other.reGetCode2 == reGetCode2)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.loginType, loginType) || other.loginType == loginType)&&(identical(other.ishasInternet, ishasInternet) || other.ishasInternet == ishasInternet)&&(identical(other.languageNum, languageNum) || other.languageNum == languageNum));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isAuthenticated,agreedToPrivacy,accessToken,userId,userInfo,errorMessage,emailAccount,password,changepassword,countryCode,phoneNumber,captcha,wechatCode,countdown,reGetCode,reGetCode2,showPassword,loginType,ishasInternet,languageNum]);

@override
String toString() {
  return 'AuthState(isLoading: $isLoading, isAuthenticated: $isAuthenticated, agreedToPrivacy: $agreedToPrivacy, accessToken: $accessToken, userId: $userId, userInfo: $userInfo, errorMessage: $errorMessage, emailAccount: $emailAccount, password: $password, changepassword: $changepassword, countryCode: $countryCode, phoneNumber: $phoneNumber, captcha: $captcha, wechatCode: $wechatCode, countdown: $countdown, reGetCode: $reGetCode, reGetCode2: $reGetCode2, showPassword: $showPassword, loginType: $loginType, ishasInternet: $ishasInternet, languageNum: $languageNum)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isAuthenticated, bool agreedToPrivacy, String? accessToken, int? userId, FitUserInfo? userInfo, String? errorMessage, String emailAccount, String password, String changepassword, String countryCode, int phoneNumber, String captcha, String wechatCode, int countdown, bool reGetCode, bool reGetCode2, bool showPassword, int loginType, bool ishasInternet, int languageNum
});


@override $FitUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isAuthenticated = null,Object? agreedToPrivacy = null,Object? accessToken = freezed,Object? userId = freezed,Object? userInfo = freezed,Object? errorMessage = freezed,Object? emailAccount = null,Object? password = null,Object? changepassword = null,Object? countryCode = null,Object? phoneNumber = null,Object? captcha = null,Object? wechatCode = null,Object? countdown = null,Object? reGetCode = null,Object? reGetCode2 = null,Object? showPassword = null,Object? loginType = null,Object? ishasInternet = null,Object? languageNum = null,}) {
  return _then(_AuthState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,agreedToPrivacy: null == agreedToPrivacy ? _self.agreedToPrivacy : agreedToPrivacy // ignore: cast_nullable_to_non_nullable
as bool,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as FitUserInfo?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,emailAccount: null == emailAccount ? _self.emailAccount : emailAccount // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,changepassword: null == changepassword ? _self.changepassword : changepassword // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as int,captcha: null == captcha ? _self.captcha : captcha // ignore: cast_nullable_to_non_nullable
as String,wechatCode: null == wechatCode ? _self.wechatCode : wechatCode // ignore: cast_nullable_to_non_nullable
as String,countdown: null == countdown ? _self.countdown : countdown // ignore: cast_nullable_to_non_nullable
as int,reGetCode: null == reGetCode ? _self.reGetCode : reGetCode // ignore: cast_nullable_to_non_nullable
as bool,reGetCode2: null == reGetCode2 ? _self.reGetCode2 : reGetCode2 // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,loginType: null == loginType ? _self.loginType : loginType // ignore: cast_nullable_to_non_nullable
as int,ishasInternet: null == ishasInternet ? _self.ishasInternet : ishasInternet // ignore: cast_nullable_to_non_nullable
as bool,languageNum: null == languageNum ? _self.languageNum : languageNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FitUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $FitUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
