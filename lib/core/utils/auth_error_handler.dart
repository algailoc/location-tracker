String mapErrorToMessage(String error) {
  switch (error) {
    case 'weak-password':
      return 'Слишком короткий пароль';
    case 'email-already-in-use':
      return 'Пользователь уже существует';
    case 'user-not-found':
      return 'Пользователь с такой почтой не найде';
    case 'wrong-password':
      return 'Неверный пароль';
    default:
      return error;
  }
}
