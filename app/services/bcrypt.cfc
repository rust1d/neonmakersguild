component {
  public bcrypt function init() {
    variables.encryptor = createObject(type='Java', classname='BCrypt');

    return this;
  }

  public string function hashpw(required string password) {
    return encryptor.hashpw(password, encryptor.gensalt());
  }

  public boolean function checkpw(required string password, required string hashed) {
    return encryptor.checkpw(password, hashed);
  }
}
