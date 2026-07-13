String password = "Admin@123";
Runtime.getRuntime().exec(userInput);
String sql = "SELECT * FROM users WHERE id=" + userInput;
MessageDigest md = MessageDigest.getInstance("MD5");
