DROP TABLE IF EXISTS BlogEntryCategories; -- IF STARTING OVER THIS WILL NOT BE OVERWRITTEN

ALTER TABLE BlogComments ADD COLUMN bco_beiid INT(11) AFTER bco_benid;
UPDATE BlogComments set bco_beiid=0;

ALTER TABLE MemberRequests ADD COLUMN mr_hearabout VARCHAR(200) AFTER mr_promo;

ALTER TABLE BlogEntriesCategories RENAME TO BlogEntryCategories;

DROP TABLE IF EXISTS BlogEntryImages;

CREATE TABLE BlogEntryImages (
  bei_beiid                             INT(11) NOT NULL AUTO_INCREMENT,
  bei_benid                             INT(11) NOT NULL,
  bei_uiid                              INT(11) NOT NULL,
  bei_caption                           VARCHAR(2000),
  bei_added                             DATETIME,
  bei_dla                               DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (bei_beiid),
  KEY(bei_benid),
  KEY(bei_uiid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- PARSED OUT USING SQL
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (5, 95);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (5, 98);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (5, 100);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (5, 105, 'metal weights');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (5, 106, 'sandbag weights');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (5, 94, 'Finished glove weight');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (5, 99, 'My helping hand!');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (6, 108);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (6, 124);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (7, 111);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 112);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 114);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 117);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 118);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 119);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (8, 120);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (9, 121);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (10, 115);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (10, 116);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (11, 128);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (13, 172);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (13, 173);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (14, 2);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 197);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 198);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 199);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 200);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 201);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 202);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 203);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (15, 222);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (19, 292);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (20, 310);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (21, 146);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (21, 314);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (22, 259);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (23, 325);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (23, 326, 'The blackening in the tube is caused by lead being deposited on the surface of the glass as a result of too much gas in the flame. This won\'t happen with lead-free glass.');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (23, 327, 'Lead-free glass is on the left here and the lead glass is on the right');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (23, 331, 'Lead glass on the left, lead-free glass on the right');
/* INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (24, 314); */
/* INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (24, 335); */
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 361);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 362);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 363);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 364);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 365);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (25, 366);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (28, 367);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (28, 368);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (29, 369);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (30, 372);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (31, 381);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (31, 383);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (31, 384);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (32, 403);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (33, 426);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (34, 436);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (34, 442);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (35, 443);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (36, 446);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (38, 452);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (39, 466);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (40, 468);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (41, 426);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (41, 473);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (41, 474);
/* INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (42, 493); */
/* INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (42, 494); */
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (43, 495);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (43, 496);
/* INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (44, 532); */
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (45, 404);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (45, 533);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (46, 534);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (46, 535);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (47, 544);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (47, 546);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (48, 557);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (48, 558);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (50, 381);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (50, 567);
INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES (50, 569, 'Attendees of the 2023 Benders Bash at Uptown Neon in Richmond Virgina');
INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES (51, 124);

-- MISSING BLOG IMAGES
INSERT INTO userImages values
(249, 2, 0,0,0,'rolled-jpg',null,'2022-08-05 09:24:55'), -- 249 077E29B11BE80AB57E1A2ECABB7DA330
(250, 2, 0,0,0,'folded-jpg',null,'2022-08-05 09:24:55'), -- 250 6C9882BBAC1C7093BD25041881277658
(251, 2, 0,0,0,'labeling-jpg',null,'2022-08-05 09:24:55'), -- 251 19F3CD308F1455B3FA09A282E0D496F4
(252, 2, 0,0,0,'sorting-jpg',null,'2022-08-05 09:24:55'), -- 252 03C6B06952C750899BB03D998E631860
(254, 2, 0,0,0,'new-system-jpg',null,'2022-08-05 09:24:55'), -- 254 C52F1BD66CC19D05628BD8BF27AF3AD6
(255, 2, 0,0,0,'organized',null,'2022-08-05 09:24:55'), -- 255 FE131D7F5A6B38B23CC967316C13DAE2
(261, 2, 0,0,0,'blurry picture of old storage system',null,'2022-08-05 09:24:55'), -- 261 B1A59B315FC9A3002CE38BBE070EC3F5
(283, 2, 0,0,0,'blacklight-eye-jpg',null,'2022-10-02 20:57:38'),
(285, 2, 0,0,0,'blacklight-eye-zoom-jpg',null,'2022-10-02 20:57:38');

INSERT INTO BlogEntryImages(bei_benid,bei_uiid) VALUES
  (17, 249), (17, 250), (17, 251), (17, 252), (17, 254), (17, 255),
  (18, 283), (18, 285);

INSERT INTO BlogEntryImages(bei_benid,bei_uiid,bei_caption) VALUES
  (17, 261, 'The only photo I had of my old storage system. I kept my patterns in their weird, triangular shelf');

DELETE FROM BlogEntries WHERE ben_benid IN (12,16,24,26,27,37,42,44,49,51);

update blogentries set ben_image=null where ben_image like '%99C5E07B4D5DE9D18C350CDF64C5AA3D%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%6E2713A6EFEE97BACB63E52C54F0ADA0%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%ED265BC903A5A097F61D3EC064D96D2E%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%33E8075E9970DE0CFEA955AFD4644BB2%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%298F95E1BF9136124592C8D4825A06FC%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%B534BA68236BA543AE44B22BD110A1D6%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%1BE3BC32E6564055D5CA3E5A354ACBEF%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%877A9BA7A98F75B90A9D49F53F15A858%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%E836D813FD184325132FCA8EDCDFB40E%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%9431C87F273E507E6040FCB07DCB4509%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%1A5B1E4DAAE265B790965A275B53AE50%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%13F3CF8C531952D72E5847C4183E6910%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%C203D8A151612ACF12457E4D67635A95%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%6ECBDD6EC859D284DC13885A37CE8D81%'; -- 2 row(s) affected
update blogentries set ben_image=null where ben_image like '%4F4ADCBF8C6F66DCFC8A3282AC2BF10A%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%BBF94B34EB32268ADA57A3BE5062FE7D%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%BEED13602B9B0E6ECB5B568FF5058F07%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%24B16FEDE9A67C9251D3E7C7161C83AC%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%0C74B7F78409A4022A2C4C5A5CA3EE19%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%05049E90FA4F5039A8CADC6ACBB4B2CC%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%5EF698CD9FE650923EA331C15AF3B160%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%F9B902FC3289AF4DD08DE5D1DE54F68F%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%B83AAC23B9528732C23CC7352950E880%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%758874998F5BD0C393DA094E1967A72B%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%06EB61B839A0CEFEE4967C67CCB099DC%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%1700002963A49DA13542E0726B7BB758%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%CFA0860E83A4C3A763A7E62D825349F7%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%BCBE3365E6AC95EA2C0343A2395834DD%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%1FF8A7B5DC7A7D1F0ED65AAA29C04B1E%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%76DC611D6EBAAFC66CC0879C71B5DB5C%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%C8FFE9A587B126F152ED3D89A146B445%'; -- 2 row(s) affected
update blogentries set ben_image=null where ben_image like '%4C56FF4CE4AAF9573AA5DFF913DF997A%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%C45147DEE729311EF5B5C3003946C48F%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%5FD0B37CD7DBBB00F97BA6CE92BF5ADD%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%698D51A19D8A121CE581499D7B701668%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%F899139DF5E1059396431415E770C6DD%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%C81E728D9D4C2F636F067F89CC14862C%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%0E01938FC48A2CFB5F2217FBFB00722D%'; -- 1 row(s) affected
update blogentries set ben_image=null where ben_image like '%FE131D7F5A6B38B23CC967316C13DAE2%'; -- 1 row(s) affected
UPDATE BlogEntries set ben_image=null where ben_image='/assets/images/1200x600.png';

UPDATE BlogEntries set ben_morebody = ben_body where length(ben_morebody)=0; -- EMPTY

UPDATE BlogEntries b
       INNER JOIN (
         SELECT ben_benid AS old_benid, ben_body AS old_body, ben_morebody AS old_morebody
           FROM BlogEntries
       ) AS temp ON ben_benid = old_benid
   SET ben_body     = old_morebody,
       ben_morebody = old_body;

UPDATE BlogEntries set ben_morebody='' where ben_body = ben_morebody;

update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<img class="', ben_body) - 1), SUBSTRING(ben_body, LOCATE('>', ben_body, LOCATE('<img class="', ben_body)) + 1)) WHERE ben_body LIKE '%<img class="%';

update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<figure', ben_body) - 1), SUBSTRING(ben_body, LOCATE('figure>', ben_body, LOCATE('<figure', ben_body)) + 7)) WHERE ben_body LIKE '%<figure%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<figure', ben_body) - 1), SUBSTRING(ben_body, LOCATE('figure>', ben_body, LOCATE('<figure', ben_body)) + 7)) WHERE ben_body LIKE '%<figure%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<figure', ben_body) - 1), SUBSTRING(ben_body, LOCATE('figure>', ben_body, LOCATE('<figure', ben_body)) + 7)) WHERE ben_body LIKE '%<figure%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<figure', ben_body) - 1), SUBSTRING(ben_body, LOCATE('figure>', ben_body, LOCATE('<figure', ben_body)) + 7)) WHERE ben_body LIKE '%<figure%';
update blogentries SET ben_body = CONCAT(LEFT(ben_body, LOCATE('<figure', ben_body) - 1), SUBSTRING(ben_body, LOCATE('figure>', ben_body, LOCATE('<figure', ben_body)) + 7)) WHERE ben_body LIKE '%<figure%';
