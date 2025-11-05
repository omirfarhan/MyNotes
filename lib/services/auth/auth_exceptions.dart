

//login exception
class UsernotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

//Register exception
class EmailAreadyInuseAuthException implements Exception{}

class WeekPasswordAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}


//Unknown exception
class GenericEmailAuthException implements Exception{}

//if user not log in then happened exception
class UserNotloggedinAuthException implements Exception{}