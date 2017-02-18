CREATE TABLE users (
  username TEXT PRIMARY KEY UNIQUE NOT NULL,
  displayname TEXT NOT NULL,
  email TEXT NOT NULL,
  password TEXT NOT NULL -- (Hashed)
);

CREATE TABLE friendships (
  user1 TEXT,
  user2 TEXT,
  accepted CHAR(1) NOT NULL, -- Either 'P' (pending), 'N' (no), or 'Y' (yes)
  FOREIGN KEY(user1) REFERENCES users(username),
  FOREIGN KEY(user2) REFERENCES users(username)
);

CREATE TABLE messages (
  -- ROWID field as message ID
  to TEXT, -- The user receiving the message
  from TEXT, -- The user who sent the message
  type TEXT CHAR(1) NOT NULL, -- Either 'S' (still image) or 'A' (audio only)
  stillPath TEXT, -- Nullable file path to still image
  audioPath TEXT NOT NULL, -- Mandatory file path to audio clip
  FOREIGN KEY(to) REFERENCES users(username),
  FOREIGN KEY(from) REFERENCES users(username)
);
