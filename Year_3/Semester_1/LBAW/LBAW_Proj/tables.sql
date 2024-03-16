--SET search_path = lbaw22116;

DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS poll CASCADE;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS attendee;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS event_features;
DROP TABLE IF EXISTS report CASCADE;

DROP TYPE IF EXISTS gender_op;
DROP TYPE IF EXISTS notification_status;

--DROP EXTENSION IF EXISTS pg_trgm CASCADE;
--DROP EXTENSION IF EXISTS btree_gin CASCADE;

DROP FUNCTION IF EXISTS event_owner();
DROP FUNCTION IF EXISTS event_search_update();
DROP FUNCTION IF EXISTS check_report();
DROP FUNCTION IF EXISTS check_notification();

--CREATE EXTENSION pg_trgm;
--CREATE EXTENSION btree_gin;

CREATE TYPE gender_op as ENUM ('male', 'female', 'other');
CREATE TYPE notification_status as ENUM ('accepted', 'declined', 'pending');

CREATE TABLE users (
   id SERIAL PRIMARY KEY,
   email TEXT NOT NULL CONSTRAINT users_email_uk UNIQUE,
   image TEXT,
   wallet_balance INT DEFAULT 0 CHECK (wallet_balance >= 0),
   name TEXT NOT NULL,
   gender gender_op NOT NULL,
   date_of_birth TIMESTAMP NOT NULL CHECK (date_of_birth < now()),
   nationality TEXT NOT NULL,
   password TEXT NOT NULL
);

CREATE TABLE event (
   id SERIAL PRIMARY KEY,
   owner_id INT NOT NULL REFERENCES users(id),
   name TEXT NOT NULL,
   description TEXT NOT NULL,
   tag TEXT,
   start_datetime TIMESTAMP NOT NULL CHECK (start_datetime >= now()),
   end_datetime TIMESTAMP NOT NULL CHECK (end_datetime > start_datetime),
   price FLOAT DEFAULT 0.0,
   max_capacity INT DEFAULT NULL,
   attendee_counter INT DEFAULT 0 CHECK (attendee_counter <= max_capacity AND attendee_counter >= 0),
   location TEXT NOT NULL,
   image TEXT NOT NULL,
   is_private BOOLEAN DEFAULT false,
   is_full BOOLEAN DEFAULT false
);

CREATE TABLE poll (
   id SERIAL PRIMARY KEY,
   event_id INT NOT NULL REFERENCES event(id),
   poll_title TEXT NOT NULL
);

CREATE TABLE comment (
   id SERIAL PRIMARY KEY,
   users_id INT NOT NULL REFERENCES users(id),
   poll_id INT NOT NULL REFERENCES poll(id),
   content TEXT NOT NULL,
   image TEXT,
   likes INT DEFAULT 0,
   dislikes INT DEFAULT 0
);

CREATE TABLE attendee (
   id SERIAL PRIMARY KEY,
   users_id INT NOT NULL REFERENCES users(id),
   event_id INT NOT NULL REFERENCES event(id),
   join_datetime TIMESTAMP DEFAULT now()
);

CREATE TABLE notification (
   id SERIAL PRIMARY KEY,
   event_id INT NOT NULL REFERENCES event(id),
   sent_users_id INT NOT NULL REFERENCES users(id) CHECK (sent_users_id != receiver_users_id),
   receiver_users_id INT NOT NULL REFERENCES users(id),
   status notification_status NOT NULL
);

CREATE TABLE event_features (
   id SERIAL PRIMARY KEY,
   event_id INT NOT NULL REFERENCES event(id),
   feature TEXT NOT NULL
);

CREATE TABLE report (
   id SERIAL PRIMARY KEY,
   users_id INT NOT NULL REFERENCES users(id),
   event_id INT NOT NULL REFERENCES event(id),
   description TEXT
);

-----------------------------------------
-- INDEXES
-----------------------------------------

--CREATE INDEX event_start ON event USING btree (start_datetime);

--CREATE INDEX event_tag ON event USING GIN (tag);

--CREATE INDEX users_email ON users USING btree (email);

-- FTS INDEXES

-- Add column to work to store computed ts_vectors.
ALTER TABLE event
ADD COLUMN tsvectors TSVECTOR;

-- Create a function to automatically update ts_vectors.
CREATE FUNCTION event_search_update() RETURNS TRIGGER AS $$
BEGIN
 IF TG_OP = 'INSERT' THEN
        NEW.tsvectors = (
         setweight(to_tsvector('english', NEW.name), 'A') ||
         setweight(to_tsvector('english', NEW.description), 'B')
        );
 END IF;
 IF TG_OP = 'UPDATE' THEN
         IF (NEW.name <> OLD.name OR NEW.description <> OLD.description) THEN
           NEW.tsvectors = (
             setweight(to_tsvector('english', NEW.name), 'A') ||
             setweight(to_tsvector('english', NEW.description), 'B')
           );
         END IF;
 END IF;
 RETURN NEW;
END $$
LANGUAGE plpgsql;

-- Create a trigger before insert or update on work.
CREATE TRIGGER event_search_update
 BEFORE INSERT OR UPDATE ON event
 FOR EACH ROW
 EXECUTE PROCEDURE event_search_update();

-- Finally, create a GIN index for ts_vectors.
CREATE INDEX search_event ON event USING GIST (tsvectors);

-----------------------------------------
-- TRIGGERS and UDFs
-----------------------------------------

-- TRIGGER01
-- You can not attend your own events.

--CREATE FUNCTION event_owner() RETURNS TRIGGER AS
--$BODY$
--BEGIN
--        IF EXISTS (SELECT * FROM event
--           INNER JOIN attendee ON event.id = attendee.event_id
--           WHERE event.owner_id = attendee.users_id ) THEN
--        RAISE EXCEPTION 'An event cannot be joined by its owner.';
--        END IF;
--        RETURN NEW;
--END
--$BODY$
--LANGUAGE plpgsql;

--CREATE TRIGGER event_owner
--        BEFORE INSERT OR UPDATE ON event
--        FOR EACH ROW
--        EXECUTE PROCEDURE event_owner();

-- TRIGGER02
--Notification can't be sent to the same user
--Notification can't be sent for a user that is already attending the event

CREATE FUNCTION check_notification() RETURNS TRIGGER AS
$BODY$
BEGIN
        IF EXISTS (SELECT * FROM notification 
	   INNER JOIN attendee ON attendee.event_id = NEW.event_id
           WHERE NEW.sent_users_id = NEW.receiver_users_id
           OR (attendee.users_id = new.receiver_users_id AND attendee.event_id = new.event_id)) THEN
        RAISE EXCEPTION 'The notification could not be sent because the user is already attending the event';
        END IF;
        RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER check_notification
        BEFORE INSERT OR UPDATE ON notification
        FOR EACH ROW
        EXECUTE PROCEDURE check_notification();

-- TRIGGER03
--A user can't report their own event

CREATE FUNCTION check_report() RETURNS TRIGGER AS
$BODY$
BEGIN
        IF EXISTS (SELECT * FROM report 
	    INNER JOIN event ON event.owner_id = NEW.users_id) THEN
        RAISE EXCEPTION 'You can´t report your own event';
        END IF;
        RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER check_report
       BEFORE INSERT OR UPDATE ON report
       FOR EACH ROW
       EXECUTE PROCEDURE check_report();

-----------------------------------------
-- end
-----------------------------------------
