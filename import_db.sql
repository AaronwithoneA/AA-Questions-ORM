-- users

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Aron", "Cutler"), ("Boris", "Grogg"), ("Peter", "Parker");

-- questions

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  questions(title, body, user_id)
SELECT
  "Tuition", "How much is tuition?", users.id
FROM
  users
WHERE
    users.fname = 'Aron' AND users.lname = 'Cutler';

INSERT INTO
  questions(title, body, user_id)
SELECT
  "curriculum", "What do you teach?", users.id
FROM
  users
WHERE
    users.fname = 'Boris' AND users.lname = 'Grogg';

-- question_follows

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_follows(follower_id, question_id)
VALUES
((SELECT id FROM users WHERE fname = "Aron" AND lname = "Cutler"),
(SELECT id FROM questions WHERE title = "Tuition")),

((SELECT id FROM users WHERE fname = "Boris" AND lname = "Grogg"),
(SELECT id FROM questions WHERE title = "curriculum")
);

-- replies

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "Tuition"),
  NULL,
  (SELECT id FROM users WHERE fname = "Aron" AND lname = "Cutler"),
   "HATE!!!"
);

 INSERT INTO
   replies(question_id, parent_id, user_id, body)
 VALUES
   ((SELECT id FROM questions WHERE title = "Tuition"),
   (SELECT id FROM replies WHERE body = "HATE!!!"),
   (SELECT id FROM users WHERE fname = "Boris" AND lname = "Grogg"),
    "WRONG"
);

-- question_likes

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  liker_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (liker_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes(liker_id, question_id)
VALUES
  (1,2);

INSERT INTO
  question_likes(liker_id, question_id)
VALUES
  (2,2);
