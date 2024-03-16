SET search_path = lbaw22116;

DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS poll CASCADE;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS attendee;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS event_features;
DROP TABLE IF EXISTS report CASCADE;
DROP TABLE IF EXISTS favorite;
DROP TABLE IF EXISTS poll_file;

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
   image TEXT DEFAULT 'prof_img.png',
   wallet_balance FLOAT DEFAULT 0 CHECK (wallet_balance >= 0),
   name TEXT NOT NULL,
   gender gender_op NOT NULL,
   date_of_birth TIMESTAMP NOT NULL CHECK (date_of_birth < now()),
   nationality TEXT NOT NULL,
   password TEXT NOT NULL,
   is_admin BOOLEAN DEFAULT 'false'
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

CREATE TABLE favorite (
   id SERIAL PRIMARY KEY,
   users_id INT NOT NULL REFERENCES users(id),
   event_id INT NOT NULL REFERENCES event(id)
);

CREATE TABLE poll_file (
   id SERIAL PRIMARY KEY,
   poll_id INT NOT NULL REFERENCES poll(id),
   file TEXT NOT NULL
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
      INNER JOIN event ON event.owner_id = NEW.users_id AND event.id = NEW.event_id) THEN
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

insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (1, 'fnsdkjfssfs@pbs.org', 'http://dummyimage.com/224x100.png/dddddd/000000', 195, 'Fernas Morin', 'male', '2021-12-05', 'Portugal', '12345667');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (2, 'nsoltan1@pbs.org', 'http://dummyimage.com/224x100.png/dddddd/000000', 195, 'Nikola Soltan', 'male', '2021-12-05', 'Papiamento', '9gv8Tlys1co');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (3, 'misaksson2@hud.gov', 'http://dummyimage.com/126x100.png/5fa2dd/ffffff', 536, 'Marthena Isaksson', 'male', '2021-02-13', 'Moldovan', 'klCLJn4AupP');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (4, 'kwaind3@gizmodo.com', 'http://dummyimage.com/218x100.png/cc0000/ffffff', 952, 'Keven Waind', 'male', '2020-03-28', 'Kannada', 'DJqpbCD');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (5, 'ctrethewey4@nba.com', 'http://dummyimage.com/227x100.png/cc0000/ffffff', 690, 'Camila Trethewey', 'female', '2020-02-11', 'Lithuanian', 'M0V4wJh');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (6, 'kgillimgham5@blogs.com', 'http://dummyimage.com/137x100.png/cc0000/ffffff', 333, 'Kain Gillimgham', 'male', '2020-08-01', 'Malayalam', 'A0SkqePr');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (7, 'pdomanski6@xrea.com', 'http://dummyimage.com/222x100.png/dddddd/000000', 874, 'Peyton Domanski', 'male', '2020-11-14', 'Macedonian', '6j6WH3mw9U');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (8, 'rstarten7@csmonitor.com', 'http://dummyimage.com/125x100.png/5fa2dd/ffffff', 719, 'Rafaello Starten', 'other', '2021-03-22', 'Tajik', 'sZaCZYkz9');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (9, 'gkristof8@europa.eu', 'http://dummyimage.com/172x100.png/dddddd/000000', 424, 'Glori Kristof', 'other', '2021-09-20', 'Lao', 'Km0xlwrfDg');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (10, 'cmcgivena9@scientificamerican.com', 'http://dummyimage.com/164x100.png/dddddd/000000', 203, 'Charmain McGivena', 'male', '2021-03-07', 'Tswana', 'BE96LM4b');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (11, 'dpollastrinoa@eventbrite.com', 'http://dummyimage.com/165x100.png/dddddd/000000', 535, 'Donni Pollastrino', 'other', '2020-08-23', 'Dzongkha', 'O3nfsCDHrep');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (12, 'zforseithb@fastcompany.com', 'http://dummyimage.com/179x100.png/cc0000/ffffff', 339, 'Zerk Forseith', 'other', '2021-08-31', 'Telugu', 'ZNk1RZJe');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (13, 'gcluelowc@ted.com', 'http://dummyimage.com/150x100.png/dddddd/000000', 748, 'Ginevra Cluelow', 'other', '2020-10-27', 'Fijian', 'MSy2dA7Q');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (14, 'lwayond@dmoz.org', 'http://dummyimage.com/231x100.png/cc0000/ffffff', 896, 'Langston Wayon', 'male', '2020-11-08', 'Gujarati', 'RKb79vD');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (15, 'mmarouseke@friendfeed.com', 'http://dummyimage.com/119x100.png/5fa2dd/ffffff', 490, 'Millie Marousek', 'female', '2020-02-16', 'Swedish', 'Z0TxKgg2A');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (16, 'mromneyf@ca.gov', 'http://dummyimage.com/168x100.png/ff4444/ffffff', 833, 'Mike Romney', 'female', '2021-10-10', 'Spanish', 'C2BCfH');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (17, 'mmccotterg@rakuten.co.jp', 'http://dummyimage.com/221x100.png/ff4444/ffffff', 75, 'Merle McCotter', 'male', '2020-06-19', 'Tsonga', 'xGmiaBNxIm');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (18, 'nthompkinsh@xrea.com', 'http://dummyimage.com/142x100.png/dddddd/000000', 878, 'Nico Thompkins', 'other', '2021-01-12', 'Zulu', 'b2LWDgMbDgf');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (19, 'ecurrani@ovh.net', 'http://dummyimage.com/166x100.png/cc0000/ffffff', 529, 'Elmo Curran', 'female', '2021-04-09', 'Croatian', 'ZtsWYLXDsfDR');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (20, 'cdemcakj@jalbum.net', 'http://dummyimage.com/190x100.png/ff4444/ffffff', 869, 'Codi Demcak', 'other', '2020-03-02', 'Yiddish', 'NU7msgfJ6');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (21, 'ashwalbek@aboutads.info', 'http://dummyimage.com/199x100.png/ff4444/ffffff', 923, 'Allyn Shwalbe', 'male', '2020-10-28', 'Tajik', 'ncCkZBe');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (22, 'ebunneyl@posterous.com', 'http://dummyimage.com/147x100.png/cc0000/ffffff', 949, 'Emmy Bunney', 'other', '2021-05-04', 'Hebrew', 'FjNlRMyw7x8');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (23, 'emateikom@bbc.co.uk', 'http://dummyimage.com/135x100.png/dddddd/000000', 809, 'Editha Mateiko', 'male', '2020-05-10', 'Nepali', 'eYJJJ1m');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (24, 'epettetn@dmoz.org', 'http://dummyimage.com/132x100.png/ff4444/ffffff', 827, 'Elwin Pettet', 'female', '2020-07-31', 'Norwegian', 'KYEwZIUyag');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (25, 'gburfieldo@51.la', 'http://dummyimage.com/209x100.png/dddddd/000000', 488, 'Galvan Burfield', 'male', '2021-01-18', 'Telugu', 'N0Ev1VQUR');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (26, 'hjosefsenp@creativecommons.org', 'http://dummyimage.com/140x100.png/5fa2dd/ffffff', 215, 'Heriberto Josefsen', 'other', '2021-10-02', 'Marathi', 'YUKayH6edH');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (27, 'lsomersq@mapy.cz', 'http://dummyimage.com/205x100.png/dddddd/000000', 72, 'Lani Somers', 'female', '2021-03-17', 'Malay', 'QudZDNYnd');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (28, 'plewerr@unesco.org', 'http://dummyimage.com/138x100.png/cc0000/ffffff', 200, 'Parker Lewer', 'male', '2020-08-05', 'Estonian', '1dSvcZV');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (29, 'ltoopins@studiopress.com', 'http://dummyimage.com/221x100.png/dddddd/000000', 609, 'Linnie Toopin', 'male', '2020-06-19', 'Māori', 'JNvIdI7');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (30, 'rhoppnert@reuters.com', 'http://dummyimage.com/122x100.png/dddddd/000000', 251, 'Rita Hoppner', 'female', '2020-08-03', 'Khmer', 'JjtJsd0spa9');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (31, 'cbellardu@pen.io', 'http://dummyimage.com/103x100.png/dddddd/000000', 285, 'Cart Bellard', 'male', '2021-04-17', 'Japanese', 'wWjXkaUjCMJ');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (32, 'dscaysbrookv@alexa.com', 'http://dummyimage.com/232x100.png/ff4444/ffffff', 404, 'Dougie Scaysbrook', 'female', '2020-03-30', 'Thai', 'Myk8AHnIQ3');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (33, 'mvedikhovw@parallels.com', 'http://dummyimage.com/152x100.png/ff4444/ffffff', 65, 'Mikol Vedikhov', 'other', '2021-05-13', 'Danish', 'rQPiyU');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (34, 'sbasinigazzix@php.net', 'http://dummyimage.com/131x100.png/dddddd/000000', 341, 'Sinclare Basini-Gazzi', 'other', '2020-05-04', 'Maltese', 'KuAPFnxnz');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (35, 'vblakesleey@intel.com', 'http://dummyimage.com/222x100.png/dddddd/000000', 889, 'Vito Blakeslee', 'female', '2021-01-07', 'Icelandic', '1Ju03ecer9r');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (36, 'ukirkbyz@epa.gov', 'http://dummyimage.com/124x100.png/dddddd/000000', 130, 'Ulrick Kirkby', 'male', '2020-10-05', 'Kurdish', 'pe3NKyl7e');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (37, 'ccopcote10@illinois.edu', 'http://dummyimage.com/190x100.png/cc0000/ffffff', 315, 'Creighton Copcote', 'other', '2021-04-27', 'Haitian Creole', '1lbBwup');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (38, 'fedginton11@abc.net.au', 'http://dummyimage.com/203x100.png/dddddd/000000', 201, 'Farlee Edginton', 'other', '2021-02-27', 'Catalan', 'K8Iw5JSdx');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (39, 'stindley12@cnbc.com', 'http://dummyimage.com/167x100.png/5fa2dd/ffffff', 721, 'Skyler Tindley', 'female', '2021-06-18', 'Filipino', 'bIBNrU');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (40, 'bsparrow13@barnesandnoble.com', 'http://dummyimage.com/149x100.png/dddddd/000000', 746, 'Baudoin Sparrow', 'male', '2020-11-21', 'Macedonian', 'dePbKwV');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (41, 'dlampitt14@tuttocitta.it', 'http://dummyimage.com/148x100.png/dddddd/000000', 120, 'Dinnie Lampitt', 'male', '2020-09-02', 'Quechua', 'z8Zmp6xkmzIb');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (42, 'mpunch15@usa.gov', 'http://dummyimage.com/133x100.png/cc0000/ffffff', 367, 'Marketa Punch', 'other', '2020-05-18', 'Quechua', 'hRZbc6mG');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (43, 'mevennett16@delicious.com', 'http://dummyimage.com/165x100.png/5fa2dd/ffffff', 912, 'Maryjo Evennett', 'female', '2020-03-15', 'English', 'kNcJSg1U');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (44, 'gchrstine17@techcrunch.com', 'http://dummyimage.com/221x100.png/dddddd/000000', 807, 'Gaile Chrstine', 'female', '2021-09-06', 'Portuguese', '5s2CuWhZ');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (45, 'mleftwich18@hostgator.com', 'http://dummyimage.com/249x100.png/dddddd/000000', 221, 'Maye Leftwich', 'male', '2021-10-08', 'Kannada', 'WYdntdZRdPyW');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (46, 'hhimsworth19@indiegogo.com', 'http://dummyimage.com/179x100.png/dddddd/000000', 331, 'Haven Himsworth', 'female', '2020-03-27', 'Dutch', 'JMwj6N0OY');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (47, 'dlawry1a@de.vu', 'http://dummyimage.com/180x100.png/ff4444/ffffff', 717, 'Dolf Lawry', 'male', '2020-07-30', 'Albanian', 'MaGVVUC');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (48, 'eabdey1b@oracle.com', 'http://dummyimage.com/174x100.png/ff4444/ffffff', 958, 'Emory Abdey', 'female', '2020-09-09', 'English', 'HDOtu2qHkBd');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (49, 'elucock1c@ovh.net', 'http://dummyimage.com/217x100.png/dddddd/000000', 634, 'Eugenia Lucock', 'male', '2021-04-11', 'Swedish', 'fJmMgbO');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (50, 'lfranies1d@cornell.edu', 'http://dummyimage.com/227x100.png/5fa2dd/ffffff', 502, 'Laney Franies', 'female', '2020-11-09', 'Assamese', 'ZJ7gtORYcZaM');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (51, 'troadknight1e@chron.com', 'http://dummyimage.com/172x100.png/5fa2dd/ffffff', 539, 'Trudey Roadknight', 'male', '2021-05-16', 'Kashmiri', '3WfKR6P');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (52, 'cfranzke1f@google.co.jp', 'http://dummyimage.com/223x100.png/5fa2dd/ffffff', 425, 'Catlin Franzke', 'other', '2020-03-18', 'Romanian', '6YtBBzv0H');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (53, 'pcoffey1g@google.fr', 'http://dummyimage.com/232x100.png/cc0000/ffffff', 746, 'Petrina Coffey', 'male', '2020-09-09', 'Bosnian', 'IMuoK5ma');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (54, 'cdella1h@mac.com', 'http://dummyimage.com/102x100.png/5fa2dd/ffffff', 847, 'Constantino Della', 'male', '2021-03-26', 'Malagasy', 'mFnynZjXCBkA');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (55, 'lackenhead1i@meetup.com', 'http://dummyimage.com/119x100.png/cc0000/ffffff', 594, 'Laura Ackenhead', 'other', '2021-06-25', 'Indonesian', 't4Yj25pM5G');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (56, 'livancevic1j@elegantthemes.com', 'http://dummyimage.com/194x100.png/cc0000/ffffff', 319, 'Loren Ivancevic', 'other', '2020-10-05', 'Arabic', 'JDbcMGuZV19');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (57, 'cbothe1k@craigslist.org', 'http://dummyimage.com/214x100.png/cc0000/ffffff', 922, 'Catharina Bothe', 'male', '2021-06-26', 'Dutch', 'mL7RehSUJ1r');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (58, 'kkeers1l@google.com.hk', 'http://dummyimage.com/156x100.png/ff4444/ffffff', 724, 'Kaylyn Keers', 'other', '2021-09-29', 'Guaraní', 'PdFXXkfM5dEE');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (59, 'efarfalameev1m@cargocollective.com', 'http://dummyimage.com/132x100.png/dddddd/000000', 813, 'Elka Farfalameev', 'male', '2021-01-06', 'Swati', 'bsXupZkpv');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (60, 'rqueripel1n@cmu.edu', 'http://dummyimage.com/190x100.png/dddddd/000000', 462, 'Rice Queripel', 'male', '2021-11-08', 'Aymara', 'AWYuoj0HIu');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (61, 'sphilbrook1o@ft.com', 'http://dummyimage.com/208x100.png/ff4444/ffffff', 188, 'Steward Philbrook', 'other', '2020-04-24', 'Latvian', '160pY26lrHLf');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (62, 'fcapper1p@scribd.com', 'http://dummyimage.com/213x100.png/5fa2dd/ffffff', 758, 'Francisca Capper', 'female', '2020-06-16', 'Macedonian', '1Ugtzzm1ROx');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (63, 'vchoudhury1q@nps.gov', 'http://dummyimage.com/136x100.png/ff4444/ffffff', 780, 'Vite Choudhury', 'other', '2020-06-05', 'Luxembourgish', 'dS09I7rGwt');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (64, 'ade1r@wordpress.org', 'http://dummyimage.com/161x100.png/cc0000/ffffff', 821, 'Augusto de Werk', 'male', '2020-04-06', 'Pashto', 'lGQmeI');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (65, 'tfoyle1s@exblog.jp', 'http://dummyimage.com/238x100.png/cc0000/ffffff', 90, 'Tull Foyle', 'female', '2021-03-02', 'Persian', 'jiUDu6pVB');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (66, 'fbairstow1t@vimeo.com', 'http://dummyimage.com/137x100.png/dddddd/000000', 89, 'Francisco Bairstow', 'other', '2020-07-18', 'Icelandic', '8cNxK9');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (67, 'fkonerding1u@google.ru', 'http://dummyimage.com/227x100.png/5fa2dd/ffffff', 639, 'Fancie Konerding', 'other', '2020-04-05', 'German', 'YKnM5kbn');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (68, 'hshevlin1v@arstechnica.com', 'http://dummyimage.com/121x100.png/ff4444/ffffff', 394, 'Horatius Shevlin', 'male', '2020-04-28', 'Kyrgyz', 'PKsj9Lluja');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (69, 'twhal1w@irs.gov', 'http://dummyimage.com/167x100.png/dddddd/000000', 951, 'Tobiah Whal', 'male', '2020-08-15', 'Malayalam', 'vnGJLpuu');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (70, 'asarsfield1x@cdbaby.com', 'http://dummyimage.com/169x100.png/cc0000/ffffff', 740, 'Andrei Sarsfield', 'male', '2021-03-15', 'Czech', 'n3snRCcAi6');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (71, 'abickardike1y@baidu.com', 'http://dummyimage.com/111x100.png/5fa2dd/ffffff', 330, 'Alisha Bickardike', 'male', '2020-02-22', 'Filipino', 'EMrT4rNUGDKR');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (72, 'bgillet1z@goo.ne.jp', 'http://dummyimage.com/120x100.png/cc0000/ffffff', 592, 'Bette Gillet', 'other', '2021-02-20', 'Lao', 'IhYmkiPsNss0');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (73, 'mdix20@sfgate.com', 'http://dummyimage.com/236x100.png/cc0000/ffffff', 338, 'Morten Dix', 'female', '2021-06-12', 'Afrikaans', '0ur0CJzE0Z');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (74, 'mdudmesh21@feedburner.com', 'http://dummyimage.com/163x100.png/dddddd/000000', 156, 'Mathian Dudmesh', 'other', '2021-05-05', 'Georgian', '6MFhltA3dhP1');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (75, 'ssumnall22@geocities.jp', 'http://dummyimage.com/172x100.png/5fa2dd/ffffff', 443, 'Spence Sumnall', 'female', '2021-03-04', 'Dzongkha', 'Q6F26UTe4vNp');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (76, 'lcumbridge23@about.me', 'http://dummyimage.com/124x100.png/ff4444/ffffff', 404, 'Lynett Cumbridge', 'male', '2020-08-20', 'Pashto', 'uGLWVRmL');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (77, 'cdagg24@hubpages.com', 'http://dummyimage.com/166x100.png/dddddd/000000', 688, 'Carce Dagg', 'female', '2020-08-11', 'English', 'rE62Xm5');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (78, 'aproback25@g.co', 'http://dummyimage.com/143x100.png/dddddd/000000', 569, 'Arin Proback', 'male', '2020-01-18', 'Tsonga', 'iMdHlm');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (79, 'krawes26@bluehost.com', 'http://dummyimage.com/205x100.png/5fa2dd/ffffff', 278, 'Katusha Rawes', 'female', '2021-08-18', 'Armenian', '90QCGpr77OJ');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (80, 'pskellington27@sohu.com', 'http://dummyimage.com/192x100.png/dddddd/000000', 942, 'Peyter Skellington', 'female', '2020-10-17', 'English', 'cezvMlnn4X');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (81, 'charmeston28@dagondesign.com', 'http://dummyimage.com/121x100.png/ff4444/ffffff', 483, 'Charisse Harmeston', 'female', '2020-08-24', 'Danish', 'do7Ln9keLZ');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (82, 'bbutterly29@telegraph.co.uk', 'http://dummyimage.com/144x100.png/ff4444/ffffff', 417, 'Butch Butterly', 'other', '2020-09-30', 'Albanian', 'uiZN4CDB');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (83, 'mpetracci2a@wordpress.org', 'http://dummyimage.com/105x100.png/dddddd/000000', 871, 'Madge Petracci', 'male', '2021-09-30', 'Papiamento', 'tfH1pEwSc');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (84, 'csirett2b@nydailynews.com', 'http://dummyimage.com/198x100.png/5fa2dd/ffffff', 180, 'Christiana Sirett', 'female', '2020-07-29', 'Haitian Creole', 'sW4vat');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (85, 'lnegus2c@t.co', 'http://dummyimage.com/228x100.png/dddddd/000000', 310, 'Lenna Negus', 'male', '2021-08-07', 'Marathi', 'fpwi5HGtPR');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (86, 'ldibdale2d@princeton.edu', 'http://dummyimage.com/209x100.png/cc0000/ffffff', 714, 'Lyssa Dibdale', 'other', '2020-01-16', 'Chinese', 'nxK0FJJpTkFB');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (87, 'rstedman2e@shareasale.com', 'http://dummyimage.com/147x100.png/cc0000/ffffff', 668, 'Rockwell Stedman', 'other', '2021-03-16', 'Somali', 'ECKsTCaH');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (88, 'edemoge2f@senate.gov', 'http://dummyimage.com/225x100.png/dddddd/000000', 793, 'Eliot Demoge', 'other', '2020-09-29', 'Tok Pisin', 'j09fJB3');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (89, 'kcumberlidge2g@chron.com', 'http://dummyimage.com/122x100.png/cc0000/ffffff', 853, 'Karil Cumberlidge', 'other', '2020-01-29', 'Dhivehi', 'QBy1o1qz0ZB');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (90, 'mgreenrod2h@nps.gov', 'http://dummyimage.com/129x100.png/dddddd/000000', 758, 'Miner Greenrod', 'female', '2020-11-19', 'Finnish', '2Ws0Rnr8mW');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (91, 'jgolton2i@shinystat.com', 'http://dummyimage.com/118x100.png/dddddd/000000', 97, 'Justus Golton', 'other', '2020-05-10', 'Belarusian', 'DCB9Bx3');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (92, 'gmelloi2j@nih.gov', 'http://dummyimage.com/124x100.png/ff4444/ffffff', 905, 'Garner Melloi', 'male', '2021-04-11', 'Tswana', 'HmtIHUwUvS');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (93, 'znend2k@bbb.org', 'http://dummyimage.com/108x100.png/cc0000/ffffff', 264, 'Zuzana Nend', 'other', '2020-04-02', 'Moldovan', '1N8wvRO9');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (94, 'kweatherburn2l@cafepress.com', 'http://dummyimage.com/125x100.png/cc0000/ffffff', 552, 'Karry Weatherburn', 'male', '2021-06-05', 'Quechua', '9OaMt9QbR3kh');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (95, 'hmackniely2m@marriott.com', 'http://dummyimage.com/211x100.png/5fa2dd/ffffff', 726, 'Haleigh MacKniely', 'male', '2020-05-04', 'Māori', 'OSIdq4gY17');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (96, 'eglynn2n@usatoday.com', 'http://dummyimage.com/168x100.png/5fa2dd/ffffff', 813, 'Edgar Glynn', 'male', '2020-02-06', 'Assamese', '2wCZTQ4');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (97, 'cmichelet2o@abc.net.au', 'http://dummyimage.com/180x100.png/5fa2dd/ffffff', 565, 'Carissa Michelet', 'female', '2020-08-23', 'Greek', 'r0dxN4q6k');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (98, 'mimpey2p@vinaora.com', 'http://dummyimage.com/176x100.png/ff4444/ffffff', 944, 'Mattheus Impey', 'other', '2020-09-07', 'Lithuanian', 'iFY7BJCWN');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (99, 'epescud2q@amazon.co.uk', 'http://dummyimage.com/143x100.png/ff4444/ffffff', 814, 'Elliott Pescud', 'male', '2020-09-24', 'Belarusian', 'I5ZtmZQ6LNg7');
insert into users (id, email, image, wallet_balance, name, gender, date_of_birth, nationality, password) values (100, 'mmacfayden2r@shareasale.com', 'http://dummyimage.com/135x100.png/5fa2dd/ffffff', 945, 'Marian MacFayden', 'male', '2021-07-21', 'Māori', '7vln1qqXeJR');

insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (1, 35, 'wbn enn ntz', 'tkcxysnexclnc', 'mnn uuh mpc', '2024-03-13', '2025-01-26', 59.24, 969, 508, 'porto', 'http://dummyimage.com/221x100.png/5fa2dd/ffffff', 'true', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (2, 8, 'urf zbk qxp', 'zpnmjuratuemx', 'suf fgr ope', '2024-02-21', '2025-01-31', 66.36, 626, 616, 'porto', 'http://dummyimage.com/189x100.png/5fa2dd/ffffff', 'true', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (3, 48, 'obv sfr uvb', 'kgjbbeixjnwcm', 'xln qvt gre', '2024-04-08', '2025-04-08', 87.06, 948, 147, 'coimbra', 'http://dummyimage.com/185x100.png/cc0000/ffffff', 'true', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (4, 81, 'lrf axc faj', 'bnmcgarrdossv', 'hfn pvu svk', '2023-10-10', '2025-01-13', 84.51, 654, 644, 'portugal', 'http://dummyimage.com/212x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (5, 73, 'ksu llj cuv', 'qigcnlbnvkggk', 'xyn izo uli', '2023-12-18', '2025-07-16', 40.58, 292, 237, 'portugal', 'http://dummyimage.com/195x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (6, 39, 'dvd lko vvs', 'ecyymttjanopo', 'rue fhw qgv', '2023-07-04', '2025-01-10', 22.96, 947, 912, 'porto', 'http://dummyimage.com/186x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (7, 100, 'fsb fgy asw', 'pnvrupnbvyqym', 'nzr iaz wrg', '2023-07-12', '2025-07-18', 56.54, 553, 543, 'portugal', 'http://dummyimage.com/194x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (8, 95, 'pzk pag gdg', 'kjwexpqfxsnvj', 'gqy xav fuu', '2023-04-22', '2025-07-14', 46.09, 949, 124, 'aveiro', 'http://dummyimage.com/136x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (9, 40, 'kra wdp zix', 'ijhnvwzegkqsi', 'cyf zhb hgh', '2023-05-19', '2025-06-12', 53.66, 839, 408, 'coimbra', 'http://dummyimage.com/157x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (10, 76, 'zbe tgk vnp', 'ecfpizwqacqac', 'gcy pwd zok', '2023-08-21', '2025-06-12', 91.07, 823, 501, 'porto', 'http://dummyimage.com/240x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (11, 78, 'tsx lxa vau', 'xrirdmveoiqhd', 'igy xdt wjc', '2023-12-14', '2025-02-19', 40.54, 244, 234, 'lisbon', 'http://dummyimage.com/160x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (12, 69, 'utm lcx nzl', 'ovcxxjlnvfutp', 'wpc fje vgk', '2024-02-22', '2025-02-10', 49.31, 521, 511, 'portugal', 'http://dummyimage.com/236x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (13, 91, 'oyh enn jcf', 'qvnnujtsumrni', 'sir vpo fli', '2024-03-18', '2025-02-05', 62.16, 744, 734, 'porto', 'http://dummyimage.com/239x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (14, 54, 'evs gsy etc', 'pmoucrsfrktbs', 'fwq xvn dcb', '2023-04-06', '2025-07-18', 21.75, 734, 724, 'portugal', 'http://dummyimage.com/150x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (15, 40, 'gul ees lyk', 'zlngkpxknrcgb', 'cvt gbr vtf', '2023-03-04', '2025-04-26', 59.23, 641, 631, 'porto', 'http://dummyimage.com/147x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (16, 20, 'zje oqf bym', 'ehppeuczrjump', 'ull nra gwd', '2023-11-27', '2024-11-20', 33.86, 355, 345, 'portugal', 'http://dummyimage.com/109x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (17, 94, 'jfj izq piy', 'pzvuyiozuognz', 'okf yhh epa', '2024-04-08', '2025-04-27', 70.98, 996, 527, 'coimbra', 'http://dummyimage.com/231x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (18, 2, 'vuy fbr dwv', 'jsyppfbectgkv', 'kpk chu cvb', '2023-03-12', '2025-03-12', 88.23, 923, 766, 'aveiro', 'http://dummyimage.com/180x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (19, 96, 'cys jqy tsb', 'ismgpivshzkbi', 'lqk kjy vkc', '2023-03-10', '2025-07-21', 77.37, 872, 161, 'lisbon', 'http://dummyimage.com/140x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (20, 53, 'jfh nqu scw', 'ihbbkfasjcrde', 'nqs uvt mox', '2023-07-03', '2025-05-01', 50.23, 448, 438, 'porto', 'http://dummyimage.com/102x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (21, 91, 'fkc fgo zsa', 'blquitqlswcmv', 'ajm yqt jrg', '2023-05-30', '2025-01-09', 47.11, 544, 275, 'coimbra', 'http://dummyimage.com/243x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (22, 8, 'qqp hxo uhj', 'ttiyadkswcvza', 'toh tsj pqf', '2023-11-04', '2025-04-02', 82.47, 568, 318, 'aveiro', 'http://dummyimage.com/208x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (23, 65, 'git mcw glu', 'xfcffxiaueksc', 'pfg rxg uao', '2023-08-13', '2025-03-09', 34.33, 376, 366, 'porto', 'http://dummyimage.com/198x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (24, 25, 'bej gbr yeq', 'brygtxqwcncog', 'cxi won xyx', '2023-10-25', '2025-07-04', 49.19, 773, 225, 'aveiro', 'http://dummyimage.com/173x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (25, 61, 'pcw udb iit', 'hvandyphevinh', 'xkd ihe esl', '2024-04-19', '2025-07-31', 22.71, 967, 818, 'aveiro', 'http://dummyimage.com/219x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (26, 40, 'gih qky ywc', 'stzooszevdyno', 'wpo tht mjr', '2023-08-17', '2025-03-30', 7.75, 313, 303, 'coimbra', 'http://dummyimage.com/174x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (27, 42, 'aph qhb xdp', 'hhnjnkudfsjld', 'jgv xks fyx', '2023-06-09', '2025-01-14', 95.42, 756, 197, 'porto', 'http://dummyimage.com/195x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (28, 95, 'qqi sqn mes', 'silfygtlgjuhj', 'tac jpx ihe', '2023-11-16', '2025-03-10', 25.68, 899, 889, 'portugal', 'http://dummyimage.com/146x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (29, 96, 'yyh sxj kld', 'taiqcirfmhkkn', 'att ipi ubq', '2023-12-04', '2025-06-01', 16.08, 530, 129, 'portugal', 'http://dummyimage.com/177x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (30, 46, 'trm cnu cyk', 'umaipxkvinuxa', 'sha fkb eyu', '2023-02-25', '2025-01-01', 51.53, 753, 617, 'portugal', 'http://dummyimage.com/203x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (31, 85, 'kzf evx alt', 'ftednfubpzexd', 'mgh dev qhw', '2024-01-06', '2025-05-20', 72.2, 253, 243, 'aveiro', 'http://dummyimage.com/199x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (32, 79, 'ohp sht usi', 'gwunbhauhohja', 'ayb uai jkq', '2023-03-28', '2025-05-29', 2.24, 663, 653, 'coimbra', 'http://dummyimage.com/131x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (33, 33, 'kom woe rtt', 'oshjfnawybksq', 'dyh nmj glc', '2023-02-19', '2024-11-19', 26.71, 723, 664, 'coimbra', 'http://dummyimage.com/211x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (34, 36, 'ggn vsu ujw', 'vnrnkkcfvxeuc', 'niq gib ojt', '2024-02-14', '2025-05-17', 60.83, 964, 274, 'portugal', 'http://dummyimage.com/245x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (35, 32, 'xrm hsx qye', 'jzpsydttrunxn', 'rqy ajx gbi', '2023-09-26', '2025-05-18', 53.34, 810, 800, 'lisbon', 'http://dummyimage.com/106x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (36, 90, 'yxn tgf wjc', 'uosutfpyfzrba', 'trs nzi bso', '2023-09-16', '2025-04-16', 60.52, 687, 283, 'portugal', 'http://dummyimage.com/107x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (37, 10, 'ieu hnj qxs', 'baunefbtofhmr', 'lzy cqa zmz', '2023-01-21', '2025-05-29', 30.85, 967, 736, 'portugal', 'http://dummyimage.com/144x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (38, 63, 'lit nkb hub', 'udtqcogtdphym', 'sbi qfe mhc', '2024-04-24', '2025-02-15', 19.6, 604, 181, 'portugal', 'http://dummyimage.com/130x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (39, 93, 'jat mhb dmu', 'pwsstwscxmwaa', 'zfm pca fxi', '2023-05-25', '2025-03-03', 94.47, 531, 344, 'porto', 'http://dummyimage.com/150x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (40, 12, 'fqz jdt qlc', 'gjhacesshvtrj', 'vgd rpy rwr', '2023-01-12', '2025-03-20', 89.5, 323, 165, 'lisbon', 'http://dummyimage.com/175x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (41, 2, 'tjl cbe nfz', 'jbsitcfakhdoq', 'afe gxz aes', '2023-04-29', '2025-03-02', 51.57, 580, 244, 'aveiro', 'http://dummyimage.com/196x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (42, 78, 'olq qja tig', 'hvajzfizsfowl', 'vgz ckn hqm', '2023-02-05', '2025-01-05', 17.96, 546, 536, 'portugal', 'http://dummyimage.com/137x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (43, 44, 'qld yut yen', 'borplyfsztavh', 'lqn mar mhl', '2023-03-14', '2025-04-11', 13.29, 835, 825, 'portugal', 'http://dummyimage.com/217x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (44, 54, 'msl jaz cit', 'quksknxhqjpzr', 'rqe kbz uly', '2023-01-23', '2025-03-28', 47.81, 410, 275, 'lisbon', 'http://dummyimage.com/223x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (45, 44, 'moa hst vnm', 'xpddpjmsrxwpc', 'xtt yzz rzq', '2023-06-07', '2025-08-02', 83.17, 282, 240, 'porto', 'http://dummyimage.com/153x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (46, 8, 'hoe bpp vsw', 'hininerfgpfzg', 'etw mcb jbn', '2023-07-26', '2025-06-24', 68.72, 406, 396, 'aveiro', 'http://dummyimage.com/246x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (47, 89, 'wdu dbn ypr', 'pxeiwtrgxztyo', 'hvn svs kad', '2024-04-22', '2024-12-19', 59.62, 828, 818, 'coimbra', 'http://dummyimage.com/249x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (48, 19, 'vsf qfs wcq', 'vnhwsffwizqpa', 'fkx sdt euw', '2023-07-31', '2025-06-21', 53.84, 411, 93, 'porto', 'http://dummyimage.com/235x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (49, 7, 'bsi enn pxi', 'dfyecyabmbhuu', 'ndj qwm dqs', '2023-07-10', '2025-04-28', 83.98, 714, 704, 'lisbon', 'http://dummyimage.com/145x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (50, 24, 'xjg qpm icn', 'qwmrkaihngvec', 'jpa jwf syl', '2023-09-11', '2024-11-27', 28.16, 874, 401, 'coimbra', 'http://dummyimage.com/184x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (51, 67, 'fpr lxe sal', 'cqfomgzfjsjpe', 'vxq fjt wpi', '2023-01-03', '2025-02-27', 95.14, 294, 284, 'lisbon', 'http://dummyimage.com/218x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (52, 64, 'hzj aif lgi', 'rgvjujfzgieno', 'cjx lmr hou', '2023-11-08', '2025-04-19', 27.52, 510, 500, 'portugal', 'http://dummyimage.com/215x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (53, 62, 'qmh rvh lus', 'vqzvxksgyormm', 'xkr lpd tvm', '2023-07-16', '2024-11-20', 94.19, 325, 272, 'lisbon', 'http://dummyimage.com/115x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (54, 59, 'gze saf xcw', 'wkdacqgbwtkce', 'tps nml ttb', '2023-11-10', '2024-11-07', 16.54, 874, 384, 'coimbra', 'http://dummyimage.com/196x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (55, 41, 'vol ayq scn', 'pcbsqaqjkwdoh', 'ncm klk jmi', '2023-05-31', '2024-11-12', 37.83, 723, 481, 'portugal', 'http://dummyimage.com/188x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (56, 69, 'ipp lez ver', 'tttipppadzzuw', 'zqq chn plo', '2023-10-17', '2025-02-13', 54.16, 779, 521, 'porto', 'http://dummyimage.com/158x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (57, 1, 'hns kcx vyq', 'hzyngpurkkkxm', 'uzk wkq tec', '2023-01-08', '2025-07-16', 58.64, 546, 499, 'coimbra', 'http://dummyimage.com/249x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (58, 54, 'kdw wev tzr', 'wvdnbvzcqjyeq', 'bij hwk pcv', '2023-11-06', '2025-07-15', 55.42, 866, 555, 'portugal', 'http://dummyimage.com/204x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (59, 74, 'ysb vxs qft', 'lgtgpatyrkvgz', 'ond mob wfc', '2023-10-26', '2025-07-18', 69.62, 219, 209, 'porto', 'http://dummyimage.com/151x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (60, 59, 'pdu wmv jrn', 'ixthyjepyimgi', 'xlp mwz atn', '2024-01-15', '2024-12-13', 34.17, 705, 675, 'lisbon', 'http://dummyimage.com/238x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (61, 95, 'yht pgb fav', 'peomtpjapmjiy', 'olj nvn ysn', '2023-12-11', '2024-12-27', 64.18, 822, 511, 'coimbra', 'http://dummyimage.com/149x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (62, 39, 'kpq vyj apz', 'cipuwtfynvibx', 'zft dab ony', '2024-01-17', '2025-07-10', 90.69, 238, 148, 'coimbra', 'http://dummyimage.com/192x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (63, 44, 'bjs ntp yhw', 'dnnkzxyjkatsi', 'nbd rgv dqj', '2023-12-10', '2024-12-02', 3.04, 806, 796, 'aveiro', 'http://dummyimage.com/193x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (64, 3, 'bsi oge cwn', 'jfzfhdnycghgz', 'jtk jsi crv', '2023-02-25', '2025-04-30', 79.59, 375, 4, 'porto', 'http://dummyimage.com/107x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (65, 96, 'fqy tae ace', 'bswvrivlddeay', 'tpi elk rln', '2023-01-27', '2024-11-09', 5.48, 266, 51, 'coimbra', 'http://dummyimage.com/106x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (66, 34, 'orm aai tdh', 'uecqsvvotpfpy', 'too epa bhs', '2024-04-08', '2025-08-07', 4.93, 453, 443, 'porto', 'http://dummyimage.com/114x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (67, 8, 'qgg lpc kyo', 'qmnpeloqiotri', 'zdn nvm wjx', '2023-03-19', '2025-02-16', 26.32, 803, 796, 'portugal', 'http://dummyimage.com/110x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (68, 37, 'dil tew wtb', 'antleaglzhrgb', 'kgo zly vbe', '2023-05-04', '2024-12-05', 34.44, 366, 356, 'aveiro', 'http://dummyimage.com/220x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (69, 35, 'jjb rmy jvt', 'fuojdsghfeuud', 'rct reb wtv', '2023-07-10', '2024-12-07', 80.98, 694, 449, 'porto', 'http://dummyimage.com/200x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (70, 60, 'ofo vha pmx', 'yozbwijxitpcu', 'hkv hvy cnj', '2023-03-21', '2025-03-30', 78.12, 563, 553, 'lisbon', 'http://dummyimage.com/126x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (71, 27, 'wmv uwl koc', 'sjkbqpggsipbz', 'tkg ldh arm', '2023-05-27', '2025-05-24', 53.67, 823, 813, 'portugal', 'http://dummyimage.com/113x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (72, 51, 'dlf oqh pvu', 'mnypocqkbumay', 'nuu etb vka', '2023-11-29', '2025-07-28', 97.53, 655, 308, 'lisbon', 'http://dummyimage.com/197x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (73, 98, 'cbe gqi plb', 'zvpdecrewgzkb', 'zfy rau pod', '2024-02-28', '2024-12-13', 71.96, 318, 308, 'coimbra', 'http://dummyimage.com/191x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (74, 6, 'dqs ujr bub', 'tgzvnrarmyqnp', 'ykw inp sdb', '2024-01-25', '2025-03-27', 92.88, 518, 327, 'porto', 'http://dummyimage.com/224x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (75, 60, 'gug tpb kyk', 'nlmurkhmtmarx', 'uuw seb uwv', '2024-05-01', '2025-05-12', 33.89, 973, 302, 'portugal', 'http://dummyimage.com/238x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (76, 90, 'ffu itx odt', 'wdzjbfakvyqtl', 'tvr apt xax', '2023-04-10', '2024-11-26', 88.12, 280, 97, 'coimbra', 'http://dummyimage.com/207x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (77, 61, 'pvd auz amw', 'ytastskfnjxup', 'ecm lyv hwf', '2023-12-05', '2025-04-18', 94.37, 984, 141, 'aveiro', 'http://dummyimage.com/248x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (78, 39, 'ryd pgb vmw', 'ntqlaqbhkfpfa', 'oxv zcz bzr', '2024-04-29', '2025-02-09', 3.06, 347, 131, 'portugal', 'http://dummyimage.com/106x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (79, 12, 'api ozp roi', 'znqzgoxvovfys', 'fag kwr rqd', '2023-06-16', '2024-12-25', 41.55, 435, 425, 'lisbon', 'http://dummyimage.com/151x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (80, 62, 'oyw hiw noj', 'tcuimlxzzdpcw', 'liy oyo liu', '2023-09-04', '2025-03-15', 57.74, 946, 559, 'porto', 'http://dummyimage.com/209x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (81, 75, 'cbd zjy dkl', 'sufrbruraicoy', 'wwu opv tny', '2023-11-27', '2025-03-14', 10.84, 757, 614, 'porto', 'http://dummyimage.com/185x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (82, 50, 'qyu ibc xgg', 'chktaumejmluu', 'qep ziu lnz', '2023-07-18', '2025-03-14', 37.99, 682, 84, 'porto', 'http://dummyimage.com/138x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (83, 23, 'eji uzf axr', 'duuhderdlzsvg', 'gma shw owm', '2023-08-22', '2025-02-10', 61.1, 212, 202, 'coimbra', 'http://dummyimage.com/233x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (84, 31, 'yih srw ltu', 'mzhsqjnzklbhv', 'ora kgc yex', '2023-03-07', '2025-06-13', 72.37, 861, 686, 'portugal', 'http://dummyimage.com/143x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (85, 99, 'mqh isz xbn', 'jqbbxmvectrlz', 'grp png tjz', '2023-12-30', '2025-03-27', 24.67, 584, 95, 'portugal', 'http://dummyimage.com/199x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (86, 74, 'kfw lij hrq', 'emzfpjfggwurf', 'bid voy zak', '2024-01-24', '2025-01-01', 58.12, 483, 473, 'coimbra', 'http://dummyimage.com/157x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (87, 30, 'tqx ozc tvs', 'kwwtuptqnbvrc', 'vdt fan bmd', '2023-06-04', '2025-07-27', 92.38, 948, 72, 'lisbon', 'http://dummyimage.com/232x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (88, 67, 'wed vjj nzy', 'ezqksbtsdtybg', 'jxi ofz bwf', '2023-02-14', '2025-06-19', 67.74, 813, 596, 'portugal', 'http://dummyimage.com/216x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (89, 25, 'nod ixl iwl', 'atfjpyegemugm', 'xaa uwc ipj', '2023-11-22', '2025-07-10', 31.24, 249, 239, 'portugal', 'http://dummyimage.com/110x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (90, 28, 'twc boa dfu', 'jnpryyctxxqat', 'zed njm ivh', '2023-08-04', '2025-02-12', 36.44, 745, 370, 'lisbon', 'http://dummyimage.com/159x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (91, 21, 'uic tio olw', 'mhmvljgdopgnh', 'rob wqp eju', '2023-01-18', '2025-05-23', 88.42, 934, 725, 'aveiro', 'http://dummyimage.com/171x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (92, 9, 'okh xzh hnv', 'knbpmvovbfrog', 'zmi rua glu', '2023-08-02', '2025-03-26', 10.47, 287, 277, 'aveiro', 'http://dummyimage.com/113x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (93, 47, 'nxt fbs cah', 'tcjcogcbsnpeh', 'sed znj ftv', '2024-02-09', '2025-02-19', 95.84, 744, 489, 'porto', 'http://dummyimage.com/199x100.png/5fa2dd/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (94, 44, 'utj qkt gdo', 'shemvjhhdxvfa', 'rmm xvz ans', '2023-09-06', '2025-03-28', 39.09, 319, 309, 'porto', 'http://dummyimage.com/247x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (95, 22, 'dqj pqd yhx', 'xewwqrastqezb', 'yqa ncs nas', '2023-07-18', '2025-02-18', 17.61, 950, 518, 'aveiro', 'http://dummyimage.com/199x100.png/dddddd/000000', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (96, 13, 'oyp zsx ozd', 'ubcvzxyhqidbo', 'mti emc xpa', '2023-05-08', '2025-06-19', 80.4, 425, 81, 'aveiro', 'http://dummyimage.com/104x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (97, 35, 'seq mit zzx', 'yojmyuoiqepmq', 'zux exr jeq', '2024-01-16', '2025-07-19', 7.16, 310, 300, 'portugal', 'http://dummyimage.com/141x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (98, 66, 'jbp nfq yzw', 'wyigyfuwqehks', 'jmt bkc wbo', '2023-05-25', '2024-11-28', 73.55, 634, 624, 'aveiro', 'http://dummyimage.com/180x100.png/ff4444/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (99, 71, 'ahg uon chm', 'fmpvdsyelxgzt', 'hgm uaq keo', '2024-05-02', '2025-05-19', 16.35, 807, 766, 'lisbon', 'http://dummyimage.com/227x100.png/cc0000/ffffff', 'false', 'false');
insert into event (id, owner_id, name, description, tag, start_datetime, end_datetime, price, max_capacity, attendee_counter, location, image, is_private, is_full) values (100, 35, 'lpp mld lut', 'tqzuywujtiptp', 'mkn jyt eqp', '2023-09-11', '2025-04-20', 4.8, 520, 37, 'porto', 'http://dummyimage.com/146x100.png/dddddd/000000', 'false', 'false');

insert into poll (id, event_id, poll_title) values (1, 71, 'elnarusnu');
insert into poll (id, event_id, poll_title) values (2, 59, 'hvakxxnbf');
insert into poll (id, event_id, poll_title) values (3, 95, 'bvmmblsmu');
insert into poll (id, event_id, poll_title) values (4, 15, 'plilzinjh');
insert into poll (id, event_id, poll_title) values (5, 80, 'tpyqmnjev');
insert into poll (id, event_id, poll_title) values (6, 33, 'effzcjpyo');
insert into poll (id, event_id, poll_title) values (7, 21, 'wxkvyixtj');
insert into poll (id, event_id, poll_title) values (8, 8, 'skcggaoyp');
insert into poll (id, event_id, poll_title) values (9, 6, 'rokejcsem');
insert into poll (id, event_id, poll_title) values (10, 80, 'pskorzfyh');
insert into poll (id, event_id, poll_title) values (11, 29, 'psletymgx');
insert into poll (id, event_id, poll_title) values (12, 43, 'xumwiyhrn');
insert into poll (id, event_id, poll_title) values (13, 41, 'qtszygdul');
insert into poll (id, event_id, poll_title) values (14, 92, 'qtvgnnbcd');
insert into poll (id, event_id, poll_title) values (15, 79, 'gjihfbuks');
insert into poll (id, event_id, poll_title) values (16, 55, 'tjwmwpeoc');
insert into poll (id, event_id, poll_title) values (17, 61, 'euwxfnpra');
insert into poll (id, event_id, poll_title) values (18, 67, 'pcgrcwosd');
insert into poll (id, event_id, poll_title) values (19, 43, 'soapqdlxi');
insert into poll (id, event_id, poll_title) values (20, 38, 'lejscjbkx');
insert into poll (id, event_id, poll_title) values (21, 61, 'jhsreoflo');
insert into poll (id, event_id, poll_title) values (22, 8, 'bltsrhmci');
insert into poll (id, event_id, poll_title) values (23, 3, 'cbenkvnzb');
insert into poll (id, event_id, poll_title) values (24, 83, 'khmmnziax');
insert into poll (id, event_id, poll_title) values (25, 74, 'kdvscpund');
insert into poll (id, event_id, poll_title) values (26, 91, 'nzuwdblbf');
insert into poll (id, event_id, poll_title) values (27, 74, 'drmbhwjqx');
insert into poll (id, event_id, poll_title) values (28, 4, 'ypceqhyhv');
insert into poll (id, event_id, poll_title) values (29, 44, 'irksuuufa');
insert into poll (id, event_id, poll_title) values (30, 52, 'jijzlcgqx');
insert into poll (id, event_id, poll_title) values (31, 42, 'bqrqqrrwl');
insert into poll (id, event_id, poll_title) values (32, 75, 'qtgtetylw');
insert into poll (id, event_id, poll_title) values (33, 77, 'vwwcqhiqy');
insert into poll (id, event_id, poll_title) values (34, 16, 'pbpxcnjqz');
insert into poll (id, event_id, poll_title) values (35, 37, 'iturkmdyk');
insert into poll (id, event_id, poll_title) values (36, 42, 'jsmbvsxgz');
insert into poll (id, event_id, poll_title) values (37, 94, 'vuxnorqpz');
insert into poll (id, event_id, poll_title) values (38, 95, 'tpecejwlw');
insert into poll (id, event_id, poll_title) values (39, 85, 'dmdapdktg');
insert into poll (id, event_id, poll_title) values (40, 75, 'jcbytwafd');
insert into poll (id, event_id, poll_title) values (41, 71, 'qwauutyps');
insert into poll (id, event_id, poll_title) values (42, 68, 'rsmildysv');
insert into poll (id, event_id, poll_title) values (43, 97, 'iqxbwbvdk');
insert into poll (id, event_id, poll_title) values (44, 10, 'pdgpzyqar');
insert into poll (id, event_id, poll_title) values (45, 51, 'myqzrbhul');
insert into poll (id, event_id, poll_title) values (46, 11, 'tmgugubcg');
insert into poll (id, event_id, poll_title) values (47, 78, 'nyptrgfpe');
insert into poll (id, event_id, poll_title) values (48, 34, 'nguiujxmu');
insert into poll (id, event_id, poll_title) values (49, 71, 'oqrxrynyg');
insert into poll (id, event_id, poll_title) values (50, 15, 'wsqrezmlm');
insert into poll (id, event_id, poll_title) values (51, 18, 'yswppwudy');
insert into poll (id, event_id, poll_title) values (52, 8, 'gymoohdox');
insert into poll (id, event_id, poll_title) values (53, 38, 'hzsqymkel');
insert into poll (id, event_id, poll_title) values (54, 44, 'nidubszdt');
insert into poll (id, event_id, poll_title) values (55, 16, 'lgcjfphrj');
insert into poll (id, event_id, poll_title) values (56, 63, 'thwwjtdvh');
insert into poll (id, event_id, poll_title) values (57, 78, 'vnlctwnbi');
insert into poll (id, event_id, poll_title) values (58, 7, 'mhqcpcksb');
insert into poll (id, event_id, poll_title) values (59, 45, 'ztkvttpvv');
insert into poll (id, event_id, poll_title) values (60, 96, 'sczsbqnao');
insert into poll (id, event_id, poll_title) values (61, 1, 'yigxlkbpx');
insert into poll (id, event_id, poll_title) values (62, 25, 'ihtedkgnv');
insert into poll (id, event_id, poll_title) values (63, 60, 'wmucdhprn');
insert into poll (id, event_id, poll_title) values (64, 71, 'yumqubqwn');
insert into poll (id, event_id, poll_title) values (65, 11, 'iudzsqxkd');
insert into poll (id, event_id, poll_title) values (66, 52, 'nszopzmyb');
insert into poll (id, event_id, poll_title) values (67, 64, 'ckndljavk');
insert into poll (id, event_id, poll_title) values (68, 7, 'kjgbveske');
insert into poll (id, event_id, poll_title) values (69, 28, 'gvmifiayy');
insert into poll (id, event_id, poll_title) values (70, 47, 'mqhvwdqoi');
insert into poll (id, event_id, poll_title) values (71, 58, 'enpcwclac');
insert into poll (id, event_id, poll_title) values (72, 85, 'epnbohsxu');
insert into poll (id, event_id, poll_title) values (73, 7, 'tebhmhiqr');
insert into poll (id, event_id, poll_title) values (74, 65, 'wivnqunql');
insert into poll (id, event_id, poll_title) values (75, 48, 'kdmqqdkly');
insert into poll (id, event_id, poll_title) values (76, 27, 'wlgzpbtxx');
insert into poll (id, event_id, poll_title) values (77, 55, 'eymvffzyr');
insert into poll (id, event_id, poll_title) values (78, 92, 'urvovexvs');
insert into poll (id, event_id, poll_title) values (79, 36, 'dqrqxszth');
insert into poll (id, event_id, poll_title) values (80, 49, 'txmrpjyjf');
insert into poll (id, event_id, poll_title) values (81, 97, 'xnsjbsopg');
insert into poll (id, event_id, poll_title) values (82, 48, 'fnjhptwwg');
insert into poll (id, event_id, poll_title) values (83, 65, 'gypcqdwny');
insert into poll (id, event_id, poll_title) values (84, 89, 'pcfopcvha');
insert into poll (id, event_id, poll_title) values (85, 42, 'splnylrxf');
insert into poll (id, event_id, poll_title) values (86, 58, 'ygfctupkl');
insert into poll (id, event_id, poll_title) values (87, 95, 'qjacsawpx');
insert into poll (id, event_id, poll_title) values (88, 1, 'tywofkgfh');
insert into poll (id, event_id, poll_title) values (89, 88, 'rtvddbqcp');
insert into poll (id, event_id, poll_title) values (90, 13, 'lkverqlqa');
insert into poll (id, event_id, poll_title) values (91, 38, 'rpxhdysbr');
insert into poll (id, event_id, poll_title) values (92, 83, 'rhgjgccwm');
insert into poll (id, event_id, poll_title) values (93, 57, 'njtwykmvg');
insert into poll (id, event_id, poll_title) values (94, 22, 'dcnvfabrc');
insert into poll (id, event_id, poll_title) values (95, 70, 'khcsggkct');
insert into poll (id, event_id, poll_title) values (96, 25, 'lhriveyde');
insert into poll (id, event_id, poll_title) values (97, 43, 'ueyztlsmj');
insert into poll (id, event_id, poll_title) values (98, 70, 'mwogijkop');
insert into poll (id, event_id, poll_title) values (99, 90, 'tktawnija');
insert into poll (id, event_id, poll_title) values (100, 68, 'frvxwcpzn');

insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (1, 78, 16, 'aeorxpblbf', 'http://dummyimage.com/198x100.png/ff4444/ffffff', 66, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (2, 75, 51, 'mbdhyeawex', 'http://dummyimage.com/188x100.png/ff4444/ffffff', 41, 53);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (3, 62, 62, 'dzhcemrvhh', 'http://dummyimage.com/236x100.png/5fa2dd/ffffff', 62, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (4, 20, 91, 'bjitqnjekn', 'http://dummyimage.com/111x100.png/cc0000/ffffff', 48, 18);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (5, 96, 8, 'ojlabkfukm', 'http://dummyimage.com/163x100.png/5fa2dd/ffffff', 16, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (6, 86, 89, 'njzdbglkwp', 'http://dummyimage.com/123x100.png/5fa2dd/ffffff', 69, 89);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (7, 86, 30, 'yxuuhnfooo', 'http://dummyimage.com/111x100.png/cc0000/ffffff', 52, 74);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (8, 63, 28, 'rclnxbtqdj', 'http://dummyimage.com/234x100.png/ff4444/ffffff', 58, 6);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (9, 77, 34, 'cgppzyliqf', 'http://dummyimage.com/241x100.png/ff4444/ffffff', 88, 66);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (10, 96, 63, 'pqxhnvbtns', 'http://dummyimage.com/157x100.png/ff4444/ffffff', 74, 31);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (11, 70, 59, 'xkcssxrrge', 'http://dummyimage.com/140x100.png/cc0000/ffffff', 14, 95);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (12, 39, 8, 'whbcqfesxp', 'http://dummyimage.com/226x100.png/ff4444/ffffff', 47, 47);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (13, 26, 90, 'mynodujoyn', 'http://dummyimage.com/158x100.png/cc0000/ffffff', 14, 6);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (14, 97, 63, 'kabzejvvpt', 'http://dummyimage.com/123x100.png/ff4444/ffffff', 92, 72);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (15, 77, 91, 'uoklwqczsi', 'http://dummyimage.com/117x100.png/cc0000/ffffff', 79, 77);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (16, 79, 57, 'gizjqhmpig', 'http://dummyimage.com/166x100.png/dddddd/000000', 86, 39);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (17, 67, 54, 'btjxhqmgby', 'http://dummyimage.com/209x100.png/5fa2dd/ffffff', 13, 43);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (18, 12, 6, 'jcsxpqtsni', 'http://dummyimage.com/162x100.png/dddddd/000000', 63, 54);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (19, 51, 45, 'kndhmubdwu', 'http://dummyimage.com/213x100.png/ff4444/ffffff', 44, 59);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (20, 58, 21, 'ubocjuavbf', 'http://dummyimage.com/180x100.png/cc0000/ffffff', 13, 53);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (21, 16, 12, 'lcrkgwatgk', 'http://dummyimage.com/121x100.png/cc0000/ffffff', 9, 15);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (22, 23, 72, 'rmgifarfoz', 'http://dummyimage.com/158x100.png/ff4444/ffffff', 45, 79);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (23, 11, 49, 'ytlqcjdqni', 'http://dummyimage.com/153x100.png/5fa2dd/ffffff', 57, 14);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (24, 44, 36, 'zxnryvkmja', 'http://dummyimage.com/150x100.png/5fa2dd/ffffff', 29, 33);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (25, 16, 98, 'ljemcxrowz', 'http://dummyimage.com/116x100.png/5fa2dd/ffffff', 65, 76);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (26, 61, 29, 'lwytjkqizq', 'http://dummyimage.com/170x100.png/dddddd/000000', 9, 74);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (27, 4, 60, 'hlgssuhlbo', 'http://dummyimage.com/126x100.png/ff4444/ffffff', 92, 65);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (28, 52, 29, 'mxijucssza', 'http://dummyimage.com/250x100.png/5fa2dd/ffffff', 41, 17);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (29, 9, 20, 'smrcgwviyl', 'http://dummyimage.com/176x100.png/cc0000/ffffff', 83, 57);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (30, 84, 71, 'dbcrnkekxp', 'http://dummyimage.com/220x100.png/cc0000/ffffff', 75, 25);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (31, 28, 78, 'ylavhrybnh', 'http://dummyimage.com/233x100.png/ff4444/ffffff', 69, 45);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (32, 33, 63, 'uqblyfpfji', 'http://dummyimage.com/186x100.png/cc0000/ffffff', 9, 91);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (33, 50, 43, 'kycrtgqbzu', 'http://dummyimage.com/208x100.png/ff4444/ffffff', 36, 9);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (34, 6, 31, 'bojjchybyn', 'http://dummyimage.com/126x100.png/cc0000/ffffff', 23, 14);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (35, 51, 72, 'pdeypilnal', 'http://dummyimage.com/150x100.png/cc0000/ffffff', 80, 17);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (36, 34, 5, 'eobxtkleyb', 'http://dummyimage.com/218x100.png/5fa2dd/ffffff', 58, 76);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (37, 69, 70, 'enxagiozno', 'http://dummyimage.com/169x100.png/dddddd/000000', 27, 23);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (38, 22, 49, 'dvwdkoiptl', 'http://dummyimage.com/214x100.png/5fa2dd/ffffff', 89, 30);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (39, 92, 69, 'sisaklliau', 'http://dummyimage.com/152x100.png/5fa2dd/ffffff', 38, 26);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (40, 24, 44, 'altotrdrez', 'http://dummyimage.com/196x100.png/dddddd/000000', 18, 85);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (41, 74, 32, 'ihdopbtnot', 'http://dummyimage.com/209x100.png/5fa2dd/ffffff', 36, 79);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (42, 95, 15, 'gzigaxbvyt', 'http://dummyimage.com/123x100.png/dddddd/000000', 28, 55);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (43, 34, 25, 'fzjymwlcse', 'http://dummyimage.com/153x100.png/ff4444/ffffff', 66, 32);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (44, 96, 73, 'zeovzxsdha', 'http://dummyimage.com/209x100.png/5fa2dd/ffffff', 12, 24);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (45, 5, 24, 'zcbwgariid', 'http://dummyimage.com/184x100.png/cc0000/ffffff', 12, 9);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (46, 70, 17, 'mursdiccid', 'http://dummyimage.com/204x100.png/ff4444/ffffff', 18, 85);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (47, 70, 76, 'aealmjlndt', 'http://dummyimage.com/198x100.png/5fa2dd/ffffff', 8, 49);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (48, 56, 1, 'ygezpcqfox', 'http://dummyimage.com/121x100.png/dddddd/000000', 70, 37);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (49, 56, 51, 'eylufvvbvf', 'http://dummyimage.com/175x100.png/cc0000/ffffff', 85, 23);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (50, 27, 82, 'yibczachop', 'http://dummyimage.com/202x100.png/5fa2dd/ffffff', 85, 65);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (51, 97, 87, 'jnaocumnvj', 'http://dummyimage.com/184x100.png/dddddd/000000', 3, 50);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (52, 57, 28, 'jpvucpyewd', 'http://dummyimage.com/173x100.png/dddddd/000000', 14, 22);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (53, 46, 6, 'upqxinigdy', 'http://dummyimage.com/125x100.png/cc0000/ffffff', 88, 3);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (54, 93, 12, 'ewflmgbtbx', 'http://dummyimage.com/124x100.png/cc0000/ffffff', 81, 94);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (55, 76, 7, 'jyovylffgq', 'http://dummyimage.com/244x100.png/ff4444/ffffff', 37, 24);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (56, 20, 95, 'zasoqoybxr', 'http://dummyimage.com/228x100.png/cc0000/ffffff', 96, 39);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (57, 51, 22, 'yxgbyfxjbz', 'http://dummyimage.com/136x100.png/cc0000/ffffff', 84, 38);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (58, 51, 92, 'vfzoanjtuz', 'http://dummyimage.com/123x100.png/dddddd/000000', 9, 93);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (59, 68, 37, 'lxmjuzixri', 'http://dummyimage.com/228x100.png/dddddd/000000', 0, 82);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (60, 93, 99, 'ecnzzdqmge', 'http://dummyimage.com/243x100.png/dddddd/000000', 88, 39);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (61, 82, 100, 'yrqifhddvj', 'http://dummyimage.com/216x100.png/cc0000/ffffff', 17, 61);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (62, 24, 11, 'pyhtrxykoh', 'http://dummyimage.com/171x100.png/cc0000/ffffff', 5, 21);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (63, 69, 22, 'chaazdspyl', 'http://dummyimage.com/133x100.png/ff4444/ffffff', 55, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (64, 69, 18, 'uolmrftmzd', 'http://dummyimage.com/249x100.png/ff4444/ffffff', 27, 53);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (65, 43, 75, 'bhnxcdwdcd', 'http://dummyimage.com/187x100.png/ff4444/ffffff', 80, 51);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (66, 5, 99, 'keearcnjye', 'http://dummyimage.com/141x100.png/dddddd/000000', 46, 62);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (67, 51, 17, 'lyvdwscizc', 'http://dummyimage.com/120x100.png/cc0000/ffffff', 82, 80);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (68, 95, 36, 'ogyxgwdeed', 'http://dummyimage.com/153x100.png/cc0000/ffffff', 29, 22);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (69, 67, 71, 'ftemirbzir', 'http://dummyimage.com/156x100.png/dddddd/000000', 54, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (70, 62, 67, 'kiinlzfqtf', 'http://dummyimage.com/153x100.png/dddddd/000000', 88, 22);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (71, 75, 61, 'ewexwupmby', 'http://dummyimage.com/156x100.png/cc0000/ffffff', 40, 75);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (72, 39, 40, 'nqkrbdcvpc', 'http://dummyimage.com/175x100.png/ff4444/ffffff', 100, 71);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (73, 78, 44, 'imraccsrem', 'http://dummyimage.com/101x100.png/ff4444/ffffff', 38, 10);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (74, 49, 32, 'cdbisxhuhr', 'http://dummyimage.com/246x100.png/5fa2dd/ffffff', 8, 76);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (75, 10, 7, 'olxulhtnri', 'http://dummyimage.com/176x100.png/5fa2dd/ffffff', 98, 53);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (76, 49, 11, 'ouvpbkbgtz', 'http://dummyimage.com/182x100.png/cc0000/ffffff', 52, 76);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (77, 58, 30, 'sfuybbszie', 'http://dummyimage.com/106x100.png/ff4444/ffffff', 74, 54);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (78, 28, 90, 'yxywulsdnr', 'http://dummyimage.com/127x100.png/cc0000/ffffff', 28, 86);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (79, 5, 79, 'vzrvgiparn', 'http://dummyimage.com/138x100.png/5fa2dd/ffffff', 81, 68);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (80, 4, 71, 'xawpjnwoyr', 'http://dummyimage.com/249x100.png/5fa2dd/ffffff', 31, 50);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (81, 21, 74, 'puelnlxzvu', 'http://dummyimage.com/231x100.png/5fa2dd/ffffff', 46, 65);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (82, 21, 39, 'rcalrsuery', 'http://dummyimage.com/246x100.png/ff4444/ffffff', 23, 57);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (83, 78, 97, 'dmrrnrskkc', 'http://dummyimage.com/230x100.png/dddddd/000000', 100, 98);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (84, 10, 18, 'dnqhmwmgma', 'http://dummyimage.com/229x100.png/dddddd/000000', 87, 42);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (85, 43, 94, 'zrjqryrfdt', 'http://dummyimage.com/158x100.png/dddddd/000000', 53, 37);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (86, 99, 79, 'szdqgsfbsa', 'http://dummyimage.com/137x100.png/cc0000/ffffff', 87, 1);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (87, 98, 12, 'tcmpgkigwj', 'http://dummyimage.com/101x100.png/dddddd/000000', 46, 26);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (88, 82, 22, 'snzffdulry', 'http://dummyimage.com/158x100.png/ff4444/ffffff', 30, 96);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (89, 70, 69, 'bujxvcvcxf', 'http://dummyimage.com/200x100.png/5fa2dd/ffffff', 12, 57);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (90, 96, 38, 'aegdyjrvgy', 'http://dummyimage.com/136x100.png/5fa2dd/ffffff', 66, 89);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (91, 34, 30, 'wokeqzoabl', 'http://dummyimage.com/238x100.png/ff4444/ffffff', 47, 29);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (92, 81, 34, 'iuwqwmccqa', 'http://dummyimage.com/210x100.png/cc0000/ffffff', 19, 73);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (93, 75, 23, 'ltcuqtheef', 'http://dummyimage.com/143x100.png/ff4444/ffffff', 0, 15);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (94, 5, 64, 'akanpefght', 'http://dummyimage.com/235x100.png/ff4444/ffffff', 57, 96);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (95, 70, 79, 'trtojtjlpt', 'http://dummyimage.com/161x100.png/cc0000/ffffff', 10, 83);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (96, 22, 81, 'txzmivdjph', 'http://dummyimage.com/146x100.png/ff4444/ffffff', 53, 69);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (97, 87, 10, 'pletonjmcw', 'http://dummyimage.com/219x100.png/ff4444/ffffff', 71, 10);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (98, 16, 49, 'nvjlbcwoxz', 'http://dummyimage.com/145x100.png/ff4444/ffffff', 100, 70);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (99, 42, 20, 'dttczknjau', 'http://dummyimage.com/183x100.png/5fa2dd/ffffff', 20, 27);
insert into comment (id, users_id, poll_id, content, image, likes, dislikes) values (100, 56, 43, 'hdfpkydasp', 'http://dummyimage.com/138x100.png/5fa2dd/ffffff', 27, 94);

insert into attendee (id, users_id, event_id, join_datetime) values (1, 67, 91, '2020-07-21');
insert into attendee (id, users_id, event_id, join_datetime) values (2, 34, 80, '2021-11-09');
insert into attendee (id, users_id, event_id, join_datetime) values (3, 84, 25, '2020-03-11');
insert into attendee (id, users_id, event_id, join_datetime) values (4, 61, 60, '2021-11-21');
insert into attendee (id, users_id, event_id, join_datetime) values (5, 58, 21, '2020-12-24');
insert into attendee (id, users_id, event_id, join_datetime) values (6, 7, 37, '2021-05-11');
insert into attendee (id, users_id, event_id, join_datetime) values (7, 76, 63, '2020-04-15');
insert into attendee (id, users_id, event_id, join_datetime) values (8, 77, 33, '2020-06-17');
insert into attendee (id, users_id, event_id, join_datetime) values (9, 68, 6, '2020-09-23');
insert into attendee (id, users_id, event_id, join_datetime) values (10, 3, 15, '2020-05-24');
insert into attendee (id, users_id, event_id, join_datetime) values (11, 21, 50, '2020-10-06');
insert into attendee (id, users_id, event_id, join_datetime) values (12, 84, 7, '2020-07-13');
insert into attendee (id, users_id, event_id, join_datetime) values (13, 5, 2, '2021-09-21');
insert into attendee (id, users_id, event_id, join_datetime) values (14, 65, 80, '2020-07-12');
insert into attendee (id, users_id, event_id, join_datetime) values (15, 27, 36, '2021-06-14');
insert into attendee (id, users_id, event_id, join_datetime) values (16, 65, 90, '2020-01-14');
insert into attendee (id, users_id, event_id, join_datetime) values (17, 17, 53, '2021-03-26');
insert into attendee (id, users_id, event_id, join_datetime) values (18, 74, 37, '2021-08-08');
insert into attendee (id, users_id, event_id, join_datetime) values (19, 30, 15, '2020-12-05');
insert into attendee (id, users_id, event_id, join_datetime) values (20, 33, 78, '2021-06-27');
insert into attendee (id, users_id, event_id, join_datetime) values (21, 90, 20, '2020-02-25');
insert into attendee (id, users_id, event_id, join_datetime) values (22, 82, 31, '2021-02-10');
insert into attendee (id, users_id, event_id, join_datetime) values (23, 75, 31, '2020-08-01');
insert into attendee (id, users_id, event_id, join_datetime) values (24, 53, 60, '2021-09-05');
insert into attendee (id, users_id, event_id, join_datetime) values (25, 76, 57, '2021-06-12');
insert into attendee (id, users_id, event_id, join_datetime) values (26, 61, 1, '2020-07-16');
insert into attendee (id, users_id, event_id, join_datetime) values (27, 62, 20, '2020-03-04');
insert into attendee (id, users_id, event_id, join_datetime) values (28, 47, 11, '2021-06-17');
insert into attendee (id, users_id, event_id, join_datetime) values (29, 8, 89, '2021-03-12');
insert into attendee (id, users_id, event_id, join_datetime) values (30, 53, 39, '2020-03-03');
insert into attendee (id, users_id, event_id, join_datetime) values (31, 98, 67, '2020-12-22');
insert into attendee (id, users_id, event_id, join_datetime) values (32, 60, 65, '2021-02-26');
insert into attendee (id, users_id, event_id, join_datetime) values (33, 92, 93, '2020-02-26');
insert into attendee (id, users_id, event_id, join_datetime) values (34, 67, 98, '2020-09-19');
insert into attendee (id, users_id, event_id, join_datetime) values (35, 47, 3, '2020-12-28');
insert into attendee (id, users_id, event_id, join_datetime) values (36, 18, 5, '2021-04-20');
insert into attendee (id, users_id, event_id, join_datetime) values (37, 44, 50, '2020-11-05');
insert into attendee (id, users_id, event_id, join_datetime) values (38, 73, 90, '2021-03-14');
insert into attendee (id, users_id, event_id, join_datetime) values (39, 22, 20, '2021-01-26');
insert into attendee (id, users_id, event_id, join_datetime) values (40, 49, 68, '2020-05-23');
insert into attendee (id, users_id, event_id, join_datetime) values (41, 27, 81, '2020-03-24');
insert into attendee (id, users_id, event_id, join_datetime) values (42, 27, 63, '2020-10-06');
insert into attendee (id, users_id, event_id, join_datetime) values (43, 86, 66, '2020-08-12');
insert into attendee (id, users_id, event_id, join_datetime) values (44, 79, 88, '2020-05-08');
insert into attendee (id, users_id, event_id, join_datetime) values (45, 10, 6, '2020-03-05');
insert into attendee (id, users_id, event_id, join_datetime) values (46, 21, 24, '2021-03-19');
insert into attendee (id, users_id, event_id, join_datetime) values (47, 6, 82, '2020-11-30');
insert into attendee (id, users_id, event_id, join_datetime) values (48, 87, 91, '2020-02-12');
insert into attendee (id, users_id, event_id, join_datetime) values (49, 73, 92, '2021-03-05');
insert into attendee (id, users_id, event_id, join_datetime) values (50, 85, 30, '2020-03-24');
insert into attendee (id, users_id, event_id, join_datetime) values (51, 4, 26, '2020-05-15');
insert into attendee (id, users_id, event_id, join_datetime) values (52, 53, 30, '2021-05-13');
insert into attendee (id, users_id, event_id, join_datetime) values (53, 66, 37, '2021-07-28');
insert into attendee (id, users_id, event_id, join_datetime) values (54, 79, 16, '2021-12-01');
insert into attendee (id, users_id, event_id, join_datetime) values (55, 85, 34, '2021-12-04');
insert into attendee (id, users_id, event_id, join_datetime) values (56, 35, 2, '2020-01-30');
insert into attendee (id, users_id, event_id, join_datetime) values (57, 7, 83, '2021-01-25');
insert into attendee (id, users_id, event_id, join_datetime) values (58, 46, 34, '2020-04-04');
insert into attendee (id, users_id, event_id, join_datetime) values (59, 79, 98, '2021-02-10');
insert into attendee (id, users_id, event_id, join_datetime) values (60, 32, 25, '2020-08-18');
insert into attendee (id, users_id, event_id, join_datetime) values (61, 79, 66, '2021-06-23');
insert into attendee (id, users_id, event_id, join_datetime) values (62, 50, 66, '2021-10-11');
insert into attendee (id, users_id, event_id, join_datetime) values (63, 53, 81, '2021-03-07');
insert into attendee (id, users_id, event_id, join_datetime) values (64, 52, 18, '2020-10-22');
insert into attendee (id, users_id, event_id, join_datetime) values (65, 58, 46, '2020-10-25');
insert into attendee (id, users_id, event_id, join_datetime) values (66, 32, 3, '2020-03-19');
insert into attendee (id, users_id, event_id, join_datetime) values (67, 89, 47, '2021-09-17');
insert into attendee (id, users_id, event_id, join_datetime) values (68, 90, 96, '2020-06-22');
insert into attendee (id, users_id, event_id, join_datetime) values (69, 41, 4, '2020-11-30');
insert into attendee (id, users_id, event_id, join_datetime) values (70, 66, 1, '2020-08-07');
insert into attendee (id, users_id, event_id, join_datetime) values (71, 56, 18, '2020-11-22');
insert into attendee (id, users_id, event_id, join_datetime) values (72, 98, 6, '2021-09-13');
insert into attendee (id, users_id, event_id, join_datetime) values (73, 55, 17, '2021-09-05');
insert into attendee (id, users_id, event_id, join_datetime) values (74, 9, 1, '2021-04-22');
insert into attendee (id, users_id, event_id, join_datetime) values (75, 79, 21, '2021-10-11');
insert into attendee (id, users_id, event_id, join_datetime) values (76, 75, 23, '2020-05-15');
insert into attendee (id, users_id, event_id, join_datetime) values (77, 20, 45, '2020-02-23');
insert into attendee (id, users_id, event_id, join_datetime) values (78, 79, 59, '2020-10-26');
insert into attendee (id, users_id, event_id, join_datetime) values (79, 35, 70, '2021-10-30');
insert into attendee (id, users_id, event_id, join_datetime) values (80, 13, 41, '2020-07-15');
insert into attendee (id, users_id, event_id, join_datetime) values (81, 10, 88, '2021-01-04');
insert into attendee (id, users_id, event_id, join_datetime) values (82, 96, 15, '2020-04-07');
insert into attendee (id, users_id, event_id, join_datetime) values (83, 1, 71, '2021-04-21');
insert into attendee (id, users_id, event_id, join_datetime) values (84, 53, 9, '2021-09-13');
insert into attendee (id, users_id, event_id, join_datetime) values (85, 39, 32, '2020-01-21');
insert into attendee (id, users_id, event_id, join_datetime) values (86, 37, 37, '2021-06-21');
insert into attendee (id, users_id, event_id, join_datetime) values (87, 50, 51, '2020-03-08');
insert into attendee (id, users_id, event_id, join_datetime) values (88, 80, 95, '2020-07-06');
insert into attendee (id, users_id, event_id, join_datetime) values (89, 61, 19, '2020-01-27');
insert into attendee (id, users_id, event_id, join_datetime) values (90, 7, 15, '2021-10-16');
insert into attendee (id, users_id, event_id, join_datetime) values (91, 73, 69, '2020-07-13');
insert into attendee (id, users_id, event_id, join_datetime) values (92, 75, 84, '2020-01-14');
insert into attendee (id, users_id, event_id, join_datetime) values (93, 56, 28, '2021-11-27');
insert into attendee (id, users_id, event_id, join_datetime) values (94, 60, 71, '2020-06-24');
insert into attendee (id, users_id, event_id, join_datetime) values (95, 13, 79, '2020-02-21');
insert into attendee (id, users_id, event_id, join_datetime) values (96, 90, 72, '2020-07-08');
insert into attendee (id, users_id, event_id, join_datetime) values (97, 24, 88, '2021-07-20');
insert into attendee (id, users_id, event_id, join_datetime) values (98, 22, 33, '2021-08-25');
insert into attendee (id, users_id, event_id, join_datetime) values (99, 16, 96, '2020-02-06');
insert into attendee (id, users_id, event_id, join_datetime) values (100, 31, 8, '2020-05-08');

insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (1, 7, 78, 89, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (2, 20, 29, 75, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (3, 64, 12, 82, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (4, 89, 49, 89, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (5, 51, 16, 72, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (6, 12, 13, 5, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (7, 48, 37, 40, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (8, 13, 99, 88, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (9, 75, 26, 70, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (10, 92, 8, 48, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (11, 18, 62, 90, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (12, 55, 68, 41, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (13, 82, 4, 28, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (14, 23, 27, 2, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (15, 95, 27, 95, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (16, 50, 40, 100, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (17, 84, 61, 47, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (18, 32, 11, 22, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (19, 38, 43, 87, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (20, 76, 11, 67, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (21, 75, 40, 36, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (22, 78, 20, 13, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (23, 30, 16, 48, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (24, 82, 30, 42, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (25, 51, 65, 51, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (26, 34, 38, 18, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (27, 92, 39, 62, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (28, 9, 30, 77, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (29, 22, 42, 45, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (30, 21, 20, 88, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (31, 72, 67, 41, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (32, 77, 61, 89, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (33, 64, 6, 93, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (34, 72, 8, 40, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (35, 21, 22, 26, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (36, 43, 24, 84, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (37, 88, 6, 47, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (38, 8, 71, 5, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (39, 97, 93, 97, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (40, 25, 54, 15, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (41, 68, 95, 24, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (42, 77, 16, 57, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (43, 50, 92, 19, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (44, 40, 15, 8, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (45, 30, 69, 16, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (46, 4, 73, 10, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (47, 34, 21, 65, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (48, 51, 25, 35, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (49, 1, 48, 37, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (50, 27, 44, 94, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (51, 6, 48, 35, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (52, 24, 63, 92, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (53, 83, 94, 47, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (54, 72, 66, 18, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (55, 100, 31, 65, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (56, 53, 63, 10, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (57, 58, 79, 27, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (58, 75, 52, 67, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (59, 38, 72, 7, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (60, 49, 60, 92, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (61, 11, 22, 59, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (62, 97, 28, 40, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (63, 40, 14, 21, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (64, 30, 100, 73, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (65, 23, 69, 42, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (66, 30, 25, 98, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (67, 61, 9, 22, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (68, 4, 31, 18, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (69, 21, 20, 87, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (70, 70, 40, 74, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (71, 27, 21, 49, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (72, 63, 57, 31, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (73, 49, 36, 71, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (74, 3, 87, 100, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (75, 12, 52, 38, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (76, 86, 93, 2, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (77, 67, 62, 96, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (78, 18, 86, 78, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (79, 93, 27, 81, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (80, 17, 8, 74, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (81, 81, 86, 95, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (82, 26, 47, 73, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (83, 31, 88, 38, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (84, 21, 64, 5, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (85, 17, 47, 3, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (86, 70, 10, 39, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (87, 23, 15, 78, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (88, 22, 94, 37, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (89, 74, 42, 33, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (90, 32, 54, 35, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (91, 53, 18, 75, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (92, 8, 28, 80, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (93, 18, 94, 97, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (94, 63, 68, 95, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (95, 22, 14, 72, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (96, 100, 37, 32, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (97, 97, 76, 5, 'accepted');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (98, 99, 76, 52, 'pending');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (99, 15, 51, 43, 'declined');
insert into notification (id, event_id, sent_users_id, receiver_users_id, status) values (100, 74, 29, 4, 'declined');

insert into event_features (id, event_id, feature) values (1, 72, 'yfnpvtts');
insert into event_features (id, event_id, feature) values (2, 22, 'xftpgdgl');
insert into event_features (id, event_id, feature) values (3, 75, 'xbmfjzpb');
insert into event_features (id, event_id, feature) values (4, 47, 'cdhqregf');
insert into event_features (id, event_id, feature) values (5, 75, 'mwyuwkls');
insert into event_features (id, event_id, feature) values (6, 12, 'nfjxfqud');
insert into event_features (id, event_id, feature) values (7, 78, 'dzbdjnhd');
insert into event_features (id, event_id, feature) values (8, 84, 'neyfeigp');
insert into event_features (id, event_id, feature) values (9, 86, 'qbwpyfxb');
insert into event_features (id, event_id, feature) values (10, 22, 'wnmtzium');
insert into event_features (id, event_id, feature) values (11, 14, 'hlkjsddy');
insert into event_features (id, event_id, feature) values (12, 2, 'gsewwtsj');
insert into event_features (id, event_id, feature) values (13, 64, 'izplurqh');
insert into event_features (id, event_id, feature) values (14, 36, 'urciyuvw');
insert into event_features (id, event_id, feature) values (15, 26, 'eaunzydb');
insert into event_features (id, event_id, feature) values (16, 81, 'zfniaasq');
insert into event_features (id, event_id, feature) values (17, 44, 'cjnmsdqv');
insert into event_features (id, event_id, feature) values (18, 80, 'gctvciuu');
insert into event_features (id, event_id, feature) values (19, 33, 'svuqyljh');
insert into event_features (id, event_id, feature) values (20, 60, 'narxtljx');
insert into event_features (id, event_id, feature) values (21, 79, 'eayqcnxf');
insert into event_features (id, event_id, feature) values (22, 11, 'dlsdgzli');
insert into event_features (id, event_id, feature) values (23, 74, 'murljnij');
insert into event_features (id, event_id, feature) values (24, 24, 'kzybvcjf');
insert into event_features (id, event_id, feature) values (25, 50, 'eungaiii');
insert into event_features (id, event_id, feature) values (26, 61, 'xvpyciiq');
insert into event_features (id, event_id, feature) values (27, 99, 'zllfcxvj');
insert into event_features (id, event_id, feature) values (28, 94, 'ziokmeiz');
insert into event_features (id, event_id, feature) values (29, 74, 'jkrphuma');
insert into event_features (id, event_id, feature) values (30, 85, 'mrikyewr');
insert into event_features (id, event_id, feature) values (31, 20, 'jxkihmyi');
insert into event_features (id, event_id, feature) values (32, 84, 'vtukhmzx');
insert into event_features (id, event_id, feature) values (33, 98, 'tjimdmrh');
insert into event_features (id, event_id, feature) values (34, 53, 'chgdajwt');
insert into event_features (id, event_id, feature) values (35, 43, 'ktmwlxjv');
insert into event_features (id, event_id, feature) values (36, 7, 'ncufsilg');
insert into event_features (id, event_id, feature) values (37, 1, 'mmuhwput');
insert into event_features (id, event_id, feature) values (38, 71, 'faxuhcgh');
insert into event_features (id, event_id, feature) values (39, 2, 'juixjwej');
insert into event_features (id, event_id, feature) values (40, 5, 'xvbrpzlp');
insert into event_features (id, event_id, feature) values (41, 80, 'mgvnqxrr');
insert into event_features (id, event_id, feature) values (42, 49, 'xfweeujp');
insert into event_features (id, event_id, feature) values (43, 97, 'mggliakm');
insert into event_features (id, event_id, feature) values (44, 49, 'yfgrhhjt');
insert into event_features (id, event_id, feature) values (45, 24, 'wxofdxsx');
insert into event_features (id, event_id, feature) values (46, 29, 'jpnsimnq');
insert into event_features (id, event_id, feature) values (47, 13, 'zjozgrdb');
insert into event_features (id, event_id, feature) values (48, 63, 'naxkrfpl');
insert into event_features (id, event_id, feature) values (49, 66, 'iwsbtxdr');
insert into event_features (id, event_id, feature) values (50, 79, 'shmshwxy');
insert into event_features (id, event_id, feature) values (51, 71, 'hlkssoxn');
insert into event_features (id, event_id, feature) values (52, 41, 'itgaisqw');
insert into event_features (id, event_id, feature) values (53, 94, 'xbdpmkfa');
insert into event_features (id, event_id, feature) values (54, 56, 'mrrdajvl');
insert into event_features (id, event_id, feature) values (55, 78, 'bwptvxoe');
insert into event_features (id, event_id, feature) values (56, 93, 'qmcrpqts');
insert into event_features (id, event_id, feature) values (57, 45, 'gfvnupue');
insert into event_features (id, event_id, feature) values (58, 83, 'kmovwbdx');
insert into event_features (id, event_id, feature) values (59, 65, 'smsoihjm');
insert into event_features (id, event_id, feature) values (60, 23, 'bgfnqoqf');
insert into event_features (id, event_id, feature) values (61, 2, 'iqoqigje');
insert into event_features (id, event_id, feature) values (62, 55, 'rmsnmtyk');
insert into event_features (id, event_id, feature) values (63, 62, 'ffjrptmw');
insert into event_features (id, event_id, feature) values (64, 32, 'trupcbxa');
insert into event_features (id, event_id, feature) values (65, 95, 'iczzyiet');
insert into event_features (id, event_id, feature) values (66, 66, 'dqmjgrcw');
insert into event_features (id, event_id, feature) values (67, 44, 'qddpaerk');
insert into event_features (id, event_id, feature) values (68, 6, 'vxgdaqkt');
insert into event_features (id, event_id, feature) values (69, 60, 'nijioykw');
insert into event_features (id, event_id, feature) values (70, 61, 'nzmaonwe');
insert into event_features (id, event_id, feature) values (71, 96, 'rfgffjbe');
insert into event_features (id, event_id, feature) values (72, 38, 'vvgpgvah');
insert into event_features (id, event_id, feature) values (73, 99, 'kttxoqgo');
insert into event_features (id, event_id, feature) values (74, 85, 'tsxwbupu');
insert into event_features (id, event_id, feature) values (75, 42, 'nwujcoaw');
insert into event_features (id, event_id, feature) values (76, 30, 'refuwzpn');
insert into event_features (id, event_id, feature) values (77, 82, 'ztvomdlb');
insert into event_features (id, event_id, feature) values (78, 77, 'gaocyoqm');
insert into event_features (id, event_id, feature) values (79, 84, 'flsgxaus');
insert into event_features (id, event_id, feature) values (80, 34, 'ptbsgxyz');
insert into event_features (id, event_id, feature) values (81, 69, 'snsvhupy');
insert into event_features (id, event_id, feature) values (82, 77, 'irjdwvma');
insert into event_features (id, event_id, feature) values (83, 41, 'vjxjftap');
insert into event_features (id, event_id, feature) values (84, 4, 'bxdncybd');
insert into event_features (id, event_id, feature) values (85, 43, 'xxzpawfu');
insert into event_features (id, event_id, feature) values (86, 90, 'dpvdglkr');
insert into event_features (id, event_id, feature) values (87, 77, 'smgssidi');
insert into event_features (id, event_id, feature) values (88, 17, 'gxismjep');
insert into event_features (id, event_id, feature) values (89, 51, 'evmsihcn');
insert into event_features (id, event_id, feature) values (90, 71, 'nbccrxhd');
insert into event_features (id, event_id, feature) values (91, 36, 'dbfmiatg');
insert into event_features (id, event_id, feature) values (92, 1, 'ntctkzgn');
insert into event_features (id, event_id, feature) values (93, 95, 'lzmucyfo');
insert into event_features (id, event_id, feature) values (94, 64, 'pvgyelgd');
insert into event_features (id, event_id, feature) values (95, 71, 'tascdxzt');
insert into event_features (id, event_id, feature) values (96, 25, 'jctldfzv');
insert into event_features (id, event_id, feature) values (97, 99, 'pslhhmpb');
insert into event_features (id, event_id, feature) values (98, 43, 'xytybxkg');
insert into event_features (id, event_id, feature) values (99, 37, 'utajhxgy');
insert into event_features (id, event_id, feature) values (100, 96, 'ynntfpas');

insert into report (id, users_id, event_id, description) values (1, 1, 20, 'zjp znh gdt');
