CREATE TABLE users (
  username TEXT PRIMARY KEY UNIQUE NOT NULL,
  displayName TEXT NOT NULL,
  email TEXT NOT NULL,
  passwordHash TEXT NOT NULL
);

CREATE TABLE friendships (
  user1 TEXT NOT NULL,
  user2 TEXT NOT NULL,
  accepted CHAR(1) NOT NULL, -- Either 'P' (pending), 'N' (no), or 'Y' (yes)
  FOREIGN KEY(user1) REFERENCES users(username),
  FOREIGN KEY(user2) REFERENCES users(username)
);

CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipient TEXT NOT NULL, -- The user receiving the message
  sender TEXT NOT NULL, -- The user who sent the message
  type CHAR(1) NOT NULL, -- Either 'S' (still image) or 'A' (audio only)
  stillPath TEXT DEFAULT NULL, -- Nullable file path to still image
  audioPath TEXT NOT NULL, -- Mandatory file path to audio clip
  sentAt DATETIME NOT NULL, -- Time at which the message was sent
  openedAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- Time at which it was first opened
  viewed INT DEFAULT 0, -- Number of times viewed (0|1 => keep, 2 => replay then delete)
  FOREIGN KEY(recipient) REFERENCES users(username),
  FOREIGN KEY(sender) REFERENCES users(username)
);
