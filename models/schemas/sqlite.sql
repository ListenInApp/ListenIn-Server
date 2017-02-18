CREATE TABLE users (
  username TEXT PRIMARY KEY UNIQUE NOT NULL,
  displayname TEXT NOT NULL,
  email TEXT NOT NULL,
  password TEXT NOT NULL -- (Hashed)
);

CREATE TABLE friendships (
  user1 TEXT NOT NULL,
  user2 TEXT NOT NULL,
  accepted CHAR(1) NOT NULL, -- Either 'P' (pending), 'N' (no), or 'Y' (yes)
  FOREIGN KEY(user1) REFERENCES users(username),
  FOREIGN KEY(user2) REFERENCES users(username)
);

CREATE TABLE messages (
  id INTEGER AUTOINCREMENT PRIMARY KEY UNIQUE NOT NULL,
  to TEXT NOT NULL, -- The user receiving the message
  from TEXT NOT NULL, -- The user who sent the message
  type TEXT CHAR(1) NOT NULL, -- Either 'S' (still image) or 'A' (audio only)
  stillPath TEXT, -- Nullable file path to still image
  audioPath TEXT NOT NULL, -- Mandatory file path to audio clip
  sentAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Time at which the message was sent
  openedAt DATETIME DEFAULT NULL, -- Time at which it was first opened
  viewed INT DEFAULT 0, -- Number of times viewed (0|1 => keep, 2 => replay then delete)
  FOREIGN KEY(to) REFERENCES users(username),
  FOREIGN KEY(from) REFERENCES users(username)
);
