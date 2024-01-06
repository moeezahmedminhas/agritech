class SignUpWithEmailAndPasswordFailure {
  final String message;
  const SignUpWithEmailAndPasswordFailure(
      [this.message = "ایک نامعلوم خرابی پیش آگئی"]);
  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
            'براہ کرم ایک مضبوط پاس ورڈ درج کریں');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
            'ای میل درست نہیں ہے یا غلط فارمیٹ شدہ ہے');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
            'اس ای میل کے لیے ایک اکاؤنٹ پہلے سے موجود ہے');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
            'آپریشن کی اجازت نہیں ہے۔ براہ کرم سپورٹ سے رابطہ کریں');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
            'اس صارف کو غیر فعال کر دیا گیا ہے۔ براہ کرم مدد کے لیے سپورٹ سے رابطہ کریں');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
