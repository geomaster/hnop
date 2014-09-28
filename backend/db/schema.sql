CREATE TABLE IF NOT EXISTS `users` (
  id 
    INTEGER 
    UNIQUE
    PRIMARY KEY
    NOT NULL,
  name
    VARCHAR(255) 
    NOT NULL,
  authcookie
    VARCHAR(64)
    NOT NULL
);

CREATE TABLE IF NOT EXISTS `authcodes` (
  id 
    INTEGER
    UNIQUE
    PRIMARY KEY
    NOT NULL,
  itemid
    INTEGER
    NOT NULL,
  authcode
    VARCHAR(64)
    NOT NULL,
  uid
    INTEGER
    NOT NULL,
  FOREIGN KEY(uid) REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);



