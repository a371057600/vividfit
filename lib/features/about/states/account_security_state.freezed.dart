// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_security_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountSecurityState {

 String get phoneNumber; String get emailAddress; String get unionId; bool get hasPhoneNumber; bool get hasEmailAddress; String get verCode; bool get isCounting; int get counter; int get accountAddType; String get bindAccount; String get areaCode; bool get isLoading; bool get ishasInternet;
/// Create a copy of AccountSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSecurityStateCopyWith<AccountSecurityState> get copyWith => _$AccountSecurityStateCopyWithImpl<AccountSecurityState>(this as AccountSecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSecurityState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.hasPhoneNumber, hasPhoneNumber) || other.hasPhoneNumber == hasPhoneNumber)&&(identical(other.hasEmailAddress, hasEmailAddress) || other.hasEmailAddress == hasEmailAddress)&&(identical(other.verCode, verCode) || other.verCode == verCode)&&(identical(other.isCounting, isCounting) || other.isCounting == isCounting)&&(identical(other.counter, counter) || other.counter == counter)&&(identical(other.accountAddType, accountAddType) || other.accountAddType == accountAddType)&&(identical(other.bindAccount, bindAccount) || other.bindAccount == bindAccount)&&(identical(other.areaCode, areaCode) || other.areaCode == areaCode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.ishasInternet, ishasInternet) || other.ishasInternet == ishasInternet));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,emailAddress,unionId,hasPhoneNumber,hasEmailAddress,verCode,isCounting,counter,accountAddType,bindAccount,areaCode,isLoading,ishasInternet);

@override
String toString() {
  return 'AccountSecurityState(phoneNumber: $phoneNumber, emailAddress: $emailAddress, unionId: $unionId, hasPhoneNumber: $hasPhoneNumber, hasEmailAddress: $hasEmailAddress, verCode: $verCode, isCounting: $isCounting, counter: $counter, accountAddType: $accountAddType, bindAccount: $bindAccount, areaCode: $areaCode, isLoading: $isLoading, ishasInternet: $ishasInternet)';
}


}

/// @nodoc
abstract mixin class $AccountSecurityStateCopyWith<$Res>  {
  factory $AccountSecurityStateCopyWith(AccountSecurityState value, $Res Function(AccountSecurityState) _then) = _$AccountSecurityStateCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, String emailAddress, String unionId, bool hasPhoneNumber, bool hasEmailAddress, String verCode, bool isCounting, int counter, int accountAddType, String bindAccount, String areaCode, bool isLoading, bool ishasInternet
});




}
/// @nodoc
class _$AccountSecurityStateCopyWithImpl<$Res>
    implements $AccountSecurityStateCopyWith<$Res> {
  _$AccountSecurityStateCopyWithImpl(this._self, this._then);

  final AccountSecurityState _self;
  final $Res Function(AccountSecurityState) _then;

/// Create a copy of AccountSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? emailAddress = null,Object? unionId = null,Object? hasPhoneNumber = null,Object? hasEmailAddress = null,Object? verCode = null,Object? isCounting = null,Object? counter = null,Object? accountAddType = null,Object? bindAccount = null,Object? areaCode = null,Object? isLoading = null,Object? ishasInternet = null,}) {
  return _then(AccountSecurityState(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,unionId: null == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String,hasPhoneNumber: null == hasPhoneNumber ? _self.hasPhoneNumber : hasPhoneNumber // ignore: cast_nullable_to_non_nullable
as bool,hasEmailAddress: null == hasEmailAddress ? _self.hasEmailAddress : hasEmailAddress // ignore: cast_nullable_to_non_nullable
as bool,verCode: null == verCode ? _self.verCode : verCode // ignore: cast_nullable_to_non_nullable
as String,isCounting: null == isCounting ? _self.isCounting : isCounting // ignore: cast_nullable_to_non_nullable
as bool,counter: null == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as int,accountAddType: null == accountAddType ? _self.accountAddType : accountAddType // ignore: cast_nullable_to_non_nullable
as int,bindAccount: null == bindAccount ? _self.bindAccount : bindAccount // ignore: cast_nullable_to_non_nullable
as String,areaCode: null == areaCode ? _self.areaCode : areaCode // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,ishasInternet: null == ishasInternet ? _self.ishasInternet : ishasInternet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountSecurityState].
extension AccountSecurityStatePatterns on AccountSecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSecurityState value)  $default,){
final _that = this;
switch (_that) {
case _AccountSecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  String emailAddress,  String unionId,  bool hasPhoneNumber,  bool hasEmailAddress,  String verCode,  bool isCounting,  int counter,  int accountAddType,  String bindAccount,  String areaCode,  bool isLoading,  bool ishasInternet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSecurityState() when $default != null:
return $default(_that.phoneNumber,_that.emailAddress,_that.unionId,_that.hasPhoneNumber,_that.hasEmailAddress,_that.verCode,_that.isCounting,_that.counter,_that.accountAddType,_that.bindAccount,_that.areaCode,_that.isLoading,_that.ishasInternet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  String emailAddress,  String unionId,  bool hasPhoneNumber,  bool hasEmailAddress,  String verCode,  bool isCounting,  int counter,  int accountAddType,  String bindAccount,  String areaCode,  bool isLoading,  bool ishasInternet)  $default,) {final _that = this;
switch (_that) {
case _AccountSecurityState():
return $default(_that.phoneNumber,_that.emailAddress,_that.unionId,_that.hasPhoneNumber,_that.hasEmailAddress,_that.verCode,_that.isCounting,_that.counter,_that.accountAddType,_that.bindAccount,_that.areaCode,_that.isLoading,_that.ishasInternet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  String emailAddress,  String unionId,  bool hasPhoneNumber,  bool hasEmailAddress,  String verCode,  bool isCounting,  int counter,  int accountAddType,  String bindAccount,  String areaCode,  bool isLoading,  bool ishasInternet)?  $default,) {final _that = this;
switch (_that) {
case _AccountSecurityState() when $default != null:
return $default(_that.phoneNumber,_that.emailAddress,_that.unionId,_that.hasPhoneNumber,_that.hasEmailAddress,_that.verCode,_that.isCounting,_that.counter,_that.accountAddType,_that.bindAccount,_that.areaCode,_that.isLoading,_that.ishasInternet);case _:
  return null;

}
}

}

/// @nodoc


class _AccountSecurityState implements AccountSecurityState {
  const _AccountSecurityState({this.phoneNumber = '', this.emailAddress = '', this.unionId = '', this.hasPhoneNumber = false, this.hasEmailAddress = false, this.verCode = '', this.isCounting = false, this.counter = 0, this.accountAddType = 0, this.bindAccount = '', this.areaCode = '', this.isLoading = false, this.ishasInternet = true});
  

@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String emailAddress;
@override@JsonKey() final  String unionId;
@override@JsonKey() final  bool hasPhoneNumber;
@override@JsonKey() final  bool hasEmailAddress;
@override@JsonKey() final  String verCode;
@override@JsonKey() final  bool isCounting;
@override@JsonKey() final  int counter;
@override@JsonKey() final  int accountAddType;
@override@JsonKey() final  String bindAccount;
@override@JsonKey() final  String areaCode;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool ishasInternet;

/// Create a copy of AccountSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSecurityStateCopyWith<_AccountSecurityState> get copyWith => __$AccountSecurityStateCopyWithImpl<_AccountSecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSecurityState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.hasPhoneNumber, hasPhoneNumber) || other.hasPhoneNumber == hasPhoneNumber)&&(identical(other.hasEmailAddress, hasEmailAddress) || other.hasEmailAddress == hasEmailAddress)&&(identical(other.verCode, verCode) || other.verCode == verCode)&&(identical(other.isCounting, isCounting) || other.isCounting == isCounting)&&(identical(other.counter, counter) || other.counter == counter)&&(identical(other.accountAddType, accountAddType) || other.accountAddType == accountAddType)&&(identical(other.bindAccount, bindAccount) || other.bindAccount == bindAccount)&&(identical(other.areaCode, areaCode) || other.areaCode == areaCode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.ishasInternet, ishasInternet) || other.ishasInternet == ishasInternet));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,emailAddress,unionId,hasPhoneNumber,hasEmailAddress,verCode,isCounting,counter,accountAddType,bindAccount,areaCode,isLoading,ishasInternet);

@override
String toString() {
  return 'AccountSecurityState(phoneNumber: $phoneNumber, emailAddress: $emailAddress, unionId: $unionId, hasPhoneNumber: $hasPhoneNumber, hasEmailAddress: $hasEmailAddress, verCode: $verCode, isCounting: $isCounting, counter: $counter, accountAddType: $accountAddType, bindAccount: $bindAccount, areaCode: $areaCode, isLoading: $isLoading, ishasInternet: $ishasInternet)';
}


}

/// @nodoc
abstract mixin class _$AccountSecurityStateCopyWith<$Res> implements $AccountSecurityStateCopyWith<$Res> {
  factory _$AccountSecurityStateCopyWith(_AccountSecurityState value, $Res Function(_AccountSecurityState) _then) = __$AccountSecurityStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, String emailAddress, String unionId, bool hasPhoneNumber, bool hasEmailAddress, String verCode, bool isCounting, int counter, int accountAddType, String bindAccount, String areaCode, bool isLoading, bool ishasInternet
});




}
/// @nodoc
class __$AccountSecurityStateCopyWithImpl<$Res>
    implements _$AccountSecurityStateCopyWith<$Res> {
  __$AccountSecurityStateCopyWithImpl(this._self, this._then);

  final _AccountSecurityState _self;
  final $Res Function(_AccountSecurityState) _then;

/// Create a copy of AccountSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? emailAddress = null,Object? unionId = null,Object? hasPhoneNumber = null,Object? hasEmailAddress = null,Object? verCode = null,Object? isCounting = null,Object? counter = null,Object? accountAddType = null,Object? bindAccount = null,Object? areaCode = null,Object? isLoading = null,Object? ishasInternet = null,}) {
  return _then(_AccountSecurityState(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,emailAddress: null == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String,unionId: null == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String,hasPhoneNumber: null == hasPhoneNumber ? _self.hasPhoneNumber : hasPhoneNumber // ignore: cast_nullable_to_non_nullable
as bool,hasEmailAddress: null == hasEmailAddress ? _self.hasEmailAddress : hasEmailAddress // ignore: cast_nullable_to_non_nullable
as bool,verCode: null == verCode ? _self.verCode : verCode // ignore: cast_nullable_to_non_nullable
as String,isCounting: null == isCounting ? _self.isCounting : isCounting // ignore: cast_nullable_to_non_nullable
as bool,counter: null == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as int,accountAddType: null == accountAddType ? _self.accountAddType : accountAddType // ignore: cast_nullable_to_non_nullable
as int,bindAccount: null == bindAccount ? _self.bindAccount : bindAccount // ignore: cast_nullable_to_non_nullable
as String,areaCode: null == areaCode ? _self.areaCode : areaCode // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,ishasInternet: null == ishasInternet ? _self.ishasInternet : ishasInternet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
