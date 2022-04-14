DROP procedure IF EXISTS blogcategories_delete;

delimiter ;;

CREATE PROCEDURE blogcategories_delete(
  IN _bcaid integer
)
BEGIN
  DELETE
    FROM blogcategories
   WHERE bca_bcaid = _bcaid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogcategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogcategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogcategories
         INNER JOIN _id_list ON _il_id = bca_bcaid;
END;;

delimiter ;
DROP procedure IF EXISTS blogcategories_insert;

delimiter ;;

CREATE PROCEDURE blogcategories_insert(
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN

  INSERT INTO blogcategories (
    bca_blog, bca_category, bca_alias
  ) VALUES (
    _blog, _category, _alias
  );

  CALL blogcategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogcategories_search;

delimiter ;;

CREATE PROCEDURE blogcategories_search(
  IN _bcaid       int(11),
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN
  SELECT blogcategories.*, us_user AS bca_blogname,
         (SELECT COUNT(*) FROM blogentriescategories WHERE bec_bcaid=bca_bcaid) AS bca_entrycnt
    FROM blogcategories
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_bcaid IS NULL OR bca_bcaid = _bcaid)
     AND (_blog IS NULL OR bca_blog = _blog)
     AND (_category IS NULL OR bca_category = _category)
     AND (_alias IS NULL OR bca_alias = _alias)
     ORDER BY bca_category;
END;;

delimiter ;
DROP procedure IF EXISTS blogcategories_update;

delimiter ;;

CREATE PROCEDURE blogcategories_update(
  IN _bcaid       int(11),
  IN _blog        int(11),
  IN _category    varchar(50),
  IN _alias       varchar(50)
)
BEGIN
  UPDATE blogcategories
     SET bca_blog     = IFNULL(_blog,      bca_blog),
         bca_category = IFNULL(_category,  bca_category),
         bca_alias    = IFNULL(_alias,     bca_alias)
   WHERE bca_bcaid = _bcaid;

  CALL blogcategories_get_by_ids(_bcaid);
END;;

delimiter ;
DROP procedure IF EXISTS blogcomments_delete;

delimiter ;;

CREATE PROCEDURE blogcomments_delete(
  IN _bcoid integer
)
BEGIN
  DELETE
    FROM blogcomments
   WHERE bco_bcoid = _bcoid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogcomments_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogcomments_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogcomments
         INNER JOIN _id_list ON _il_id = bco_bcoid;
END;;

delimiter ;
DROP procedure IF EXISTS blogcomments_insert;

delimiter ;;

CREATE PROCEDURE blogcomments_insert(
  IN _blog             int(11),
  IN _benid            int(11),
  IN _usid             int(11),
  IN _name             varchar(50),
  IN _email            varchar(50),
  IN _comment          text,
  IN _posted           datetime,
  IN _subscribe        tinyint(1),
  IN _website          varchar(255),
  IN _moderated        tinyint(1),
  IN _subscribeonly    tinyint(1),
  IN _kill             varchar(35)
)
BEGIN

  INSERT INTO blogcomments (
    bco_blog, bco_benid, ben_usid, bco_name, bco_email, bco_comment, bco_posted, bco_subscribe, bco_website, bco_moderated, bco_subscribeonly, bco_kill
  ) VALUES (
    _blog, _benid, _usid, _name, _email, _comment, _posted, _subscribe, _website, _moderated, _subscribeonly, _kill
  );

  CALL blogcomments_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogcomments_search;

delimiter ;;

CREATE PROCEDURE blogcomments_search(
  IN _bcoid        int(11),
  IN _blog         int(11),
  IN _benid        int(11),
  IN _name         varchar(50),
  IN _email        varchar(50),
  IN _posted       datetime,
  IN _moderated    tinyint(1)
)
BEGIN
  SELECT *
    FROM blogcomments
   WHERE (_bcoid IS NULL OR bco_bcoid = _bcoid)
     AND (_blog IS NULL OR bco_blog = _blog)
     AND (_benid IS NULL OR bco_benid = _benid)
     AND (_name IS NULL OR bco_name = _name)
     AND (_email IS NULL OR bco_email = _email)
     AND (_posted IS NULL OR bco_posted = _posted)
     AND (_moderated IS NULL OR bco_moderated = _moderated);
END;;

delimiter ;
DROP procedure IF EXISTS blogcomments_update;

delimiter ;;

CREATE PROCEDURE blogcomments_update(
  IN _bcoid            int(11),
  IN _blog             int(11),
  IN _benid            int(11),
  IN _usid             int(11),
  IN _name             varchar(50),
  IN _email            varchar(50),
  IN _comment          text,
  IN _posted           datetime,
  IN _subscribe        tinyint(1),
  IN _website          varchar(255),
  IN _moderated        tinyint(1),
  IN _subscribeonly    tinyint(1),
  IN _kill             varchar(35)
)
BEGIN
  UPDATE blogcomments
     SET bco_blog          = IFNULL(_blog,           bco_blog),
         bco_benid         = IFNULL(_benid,          bco_benid),
         ben_usid          = IFNULL(_usid,           ben_usid),
         bco_name          = IFNULL(_name,           bco_name),
         bco_email         = IFNULL(_email,          bco_email),
         bco_comment       = IFNULL(_comment,        bco_comment),
         bco_posted        = IFNULL(_posted,         bco_posted),
         bco_subscribe     = IFNULL(_subscribe,      bco_subscribe),
         bco_website       = IFNULL(_website,        bco_website),
         bco_moderated     = IFNULL(_moderated,      bco_moderated),
         bco_subscribeonly = IFNULL(_subscribeonly,  bco_subscribeonly),
         bco_kill          = IFNULL(_kill,           bco_kill)
   WHERE bco_bcoid = _bcoid;

  CALL blogcomments_get_by_ids(_bcoid);
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_delete;

delimiter ;;

CREATE PROCEDURE blogentriescategories_delete(
  IN _becid integer
)
BEGIN
  DELETE
    FROM blogentriescategories
   WHERE bec_becid = _becid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentriescategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentriescategories
         INNER JOIN _id_list ON _il_id = bec_becid;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_insert;

delimiter ;;

CREATE PROCEDURE blogentriescategories_insert(
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN

  INSERT INTO blogentriescategories (
    bec_benid, bec_bcaid
  ) VALUES (
    _benid, _bcaid
  );

  CALL blogentriescategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_replace;

delimiter ;;

CREATE PROCEDURE blogentriescategories_replace(
  IN _benid   INT,
  IN _bcaids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogentriescategories
   WHERE bec_benid = _benid;

  CALL create_temp_table_id_list(_bcaids);

  INSERT INTO blogentriescategories (bec_benid, bec_bcaid)
    SELECT _benid, bca_bcaid
      FROM blogcategories
           INNER JOIN _id_list ON _il_id = bca_bcaid;

  SELECT *
    FROM blogentriescategories
   WHERE bec_benid = _benid;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_search;

delimiter ;;

CREATE PROCEDURE blogentriescategories_search(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN
  SELECT blogentriescategories.*,
         bca_category AS bec_category, bca_alias AS bec_alias, us_user AS bec_blogname
    FROM blogentriescategories
         INNER JOIN blogCategories ON bca_bcaid = bec_bcaid
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_becid IS NULL OR bec_becid = _becid)
     AND (_benid IS NULL OR bec_benid = _benid)
     AND (_bcaid IS NULL OR bec_bcaid = _bcaid);
END;;

delimiter ;
DROP procedure IF EXISTS blogentriescategories_update;

delimiter ;;

CREATE PROCEDURE blogentriescategories_update(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11)
)
BEGIN
  UPDATE blogentriescategories
     SET bec_benid = IFNULL(_benid,  bec_benid),
         bec_bcaid = IFNULL(_bcaid,  bec_bcaid)
   WHERE bec_becid = _becid;

  CALL blogentriescategories_get_by_ids(_becid);
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_delete;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_delete(
  IN _breid integer
)
BEGIN
  DELETE
    FROM blogentriesrelated
   WHERE bre_breid = _breid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentriesrelated
         INNER JOIN _id_list ON _il_id = bre_breid;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_insert;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_insert(
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN

  INSERT INTO blogentriesrelated (
    bre_benid, bre_relbenid
  ) VALUES (
    _benid, _relbenid
  );

  CALL blogentriesrelated_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_replace;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_replace(
  IN _benid   INT,
  IN _relids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogentriesrelated
   WHERE ber_benid = _benid;

  CALL create_temp_table_id_list(_relids);

  INSERT INTO blogentriesrelated (bre_benid, bre_relbenid)
    SELECT _benid, ben_benid
      FROM blogentries
           INNER JOIN _id_list ON _il_id = ben_benid;

  SELECT *
    FROM blogentriesrelated
   WHERE bre_benid = _benid;
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_search;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_search(
  IN _breid       int(11),
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN
  SELECT *
    FROM blogentriesrelated
   WHERE (_breid IS NULL OR bre_breid = _breid)
     AND (_benid IS NULL OR bre_benid = _benid)
     AND (_relbenid IS NULL OR bre_relbenid = _relbenid);
END;;

delimiter ;
DROP procedure IF EXISTS blogentriesrelated_update;

delimiter ;;

CREATE PROCEDURE blogentriesrelated_update(
  IN _breid       int(11),
  IN _benid       int(11),
  IN _relbenid    int(11)
)
BEGIN
  UPDATE blogentriesrelated
     SET bre_benid    = IFNULL(_benid,     bre_benid),
         bre_relbenid = IFNULL(_relbenid,  bre_relbenid)
   WHERE bre_breid = _breid;

  CALL blogentriesrelated_get_by_ids(_breid);
END;;

delimiter ;
DROP procedure IF EXISTS blogentries_delete;

delimiter ;;

CREATE PROCEDURE blogentries_delete(
  IN _benid integer
)
BEGIN
  DELETE
    FROM blogentries
   WHERE ben_benid = _benid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogentries_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogentries_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogentries
         INNER JOIN _id_list ON _il_id = ben_benid;
END;;

delimiter ;
DROP procedure IF EXISTS blogentries_insert;

delimiter ;;

CREATE PROCEDURE blogentries_insert(
  IN _blog             int(11),
  IN _usid             int(11),
  IN _title            varchar(100),
  IN _body             longtext,
  IN _posted           datetime,
  IN _morebody         longtext,
  IN _alias            varchar(100),
  IN _allowcomments    tinyint(1),
  IN _attachment       varchar(255),
  IN _filesize         int(11) unsigned,
  IN _mimetype         varchar(255),
  IN _views            int(11) unsigned,
  IN _released         tinyint(1),
  IN _mailed           tinyint(1)
)
BEGIN

  INSERT INTO blogentries (
    ben_blog, ben_usid, ben_title, ben_body, ben_posted, ben_morebody, ben_alias, ben_allowcomments, ben_attachment, ben_filesize, ben_mimetype, ben_views, ben_released, ben_mailed
  ) VALUES (
    _blog, _usid, _title, _body, _posted, _morebody, _alias, _allowcomments, _attachment, _filesize, _mimetype, _views, _released, _mailed
  );

  CALL blogentries_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogentries_search;

delimiter ;;

CREATE PROCEDURE blogentries_search(
  IN _benid       int(11),
  IN _blog        int(11),
  IN _usid        int(11),
  IN _title       varchar(100),
  IN _posted      datetime,
  IN _alias       varchar(100),
  IN _released    tinyint(1),
  IN _bcaid       int(11)
)
BEGIN
  SELECT blogentries.*, us_user AS ben_blogname
    FROM blogentries
         INNER JOIN users ON us_usid = ben_blog
   WHERE (_benid IS NULL OR ben_benid = _benid)
     AND (_blog IS NULL OR ben_blog = _blog)
     AND (_usid IS NULL OR ben_usid = _usid)
     AND (_title IS NULL OR ben_title = _title)
     AND (_posted IS NULL OR ben_posted = _posted)
     AND (_alias IS NULL OR ben_alias = _alias)
     AND (_released IS NULL OR ben_released = _released)
     AND (_bcaid IS NULL OR EXISTS (SELECT 1 FROM BlogEntriesCategories WHERE bec_bcaid=_bcaid AND bec_benid=ben_benid))
  ORDER BY ben_posted DESC;
END;;

delimiter ;
DROP procedure IF EXISTS blogentries_update;

delimiter ;;

CREATE PROCEDURE blogentries_update(
  IN _benid            int(11),
  IN _blog             int(11),
  IN _usid             int(11),
  IN _title            varchar(100),
  IN _body             longtext,
  IN _posted           datetime,
  IN _morebody         longtext,
  IN _alias            varchar(100),
  IN _allowcomments    tinyint(1),
  IN _attachment       varchar(255),
  IN _filesize         int(11) unsigned,
  IN _mimetype         varchar(255),
  IN _views            int(11) unsigned,
  IN _released         tinyint(1),
  IN _mailed           tinyint(1)
)
BEGIN
  UPDATE blogentries
     SET ben_blog          = IFNULL(_blog,           ben_blog),
         ben_usid          = IFNULL(_usid,           ben_usid),
         ben_title         = IFNULL(_title,          ben_title),
         ben_body          = IFNULL(_body,           ben_body),
         ben_posted        = IFNULL(_posted,         ben_posted),
         ben_morebody      = IFNULL(_morebody,       ben_morebody),
         ben_alias         = IFNULL(_alias,          ben_alias),
         ben_allowcomments = IFNULL(_allowcomments,  ben_allowcomments),
         ben_attachment    = IFNULL(_attachment,     ben_attachment),
         ben_filesize      = IFNULL(_filesize,       ben_filesize),
         ben_mimetype      = IFNULL(_mimetype,       ben_mimetype),
         ben_views         = IFNULL(_views,          ben_views),
         ben_released      = IFNULL(_released,       ben_released),
         ben_mailed        = IFNULL(_mailed,         ben_mailed)
   WHERE ben_benid = _benid;

  CALL blogentries_get_by_ids(_benid);
END;;

delimiter ;
DROP procedure IF EXISTS bloglinks_delete;

delimiter ;;

CREATE PROCEDURE bloglinks_delete(
  IN _bliid integer
)
BEGIN
  DELETE
    FROM bloglinks
   WHERE bli_bliid = _bliid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS bloglinks_get_by_ids;

delimiter ;;

CREATE PROCEDURE bloglinks_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM bloglinks
         INNER JOIN _id_list ON _il_id = bli_bliid;
END;;

delimiter ;
DROP procedure IF EXISTS bloglinks_insert;

delimiter ;;

CREATE PROCEDURE bloglinks_insert(
  IN _blog     int(11),
  IN _url      varchar(200),
  IN _title    varchar(100),
  IN _type     varchar(15)
)
BEGIN

  INSERT INTO bloglinks (
    bli_blog, bli_url, bli_title, bli_type
  ) VALUES (
    _blog, _url, _title, _type
  );

  CALL bloglinks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS bloglinks_search;

delimiter ;;

CREATE PROCEDURE bloglinks_search(
  IN _bliid    int(11),
  IN _blog     int(11)
)
BEGIN
  SELECT *
    FROM bloglinks
   WHERE (_bliid IS NULL OR bli_bliid = _bliid)
     AND (_blog IS NULL OR bli_blog = _blog);
END;;

delimiter ;
DROP procedure IF EXISTS bloglinks_update;

delimiter ;;

CREATE PROCEDURE bloglinks_update(
  IN _bliid    int(11),
  IN _blog     int(11),
  IN _url      varchar(200),
  IN _title    varchar(100),
  IN _type     varchar(15)
)
BEGIN
  UPDATE bloglinks
     SET bli_blog  = IFNULL(_blog,   bli_blog),
         bli_url   = IFNULL(_url,    bli_url),
         bli_title = IFNULL(_title,  bli_title),
         bli_type  = IFNULL(_type,   bli_type)
   WHERE bli_bliid = _bliid;

  CALL bloglinks_get_by_ids(_bliid);
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_delete;

delimiter ;;

CREATE PROCEDURE blogpagescategories_delete(
  IN _bpcid integer
)
BEGIN
  DELETE
    FROM blogpagescategories
   WHERE bpc_bpcid = _bpcid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogpagescategories_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogpagescategories
         INNER JOIN _id_list ON _il_id = bpc_bpcid;
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_insert;

delimiter ;;

CREATE PROCEDURE blogpagescategories_insert(
  IN _bcaid    int(11),
  IN _bpaid    int(11)
)
BEGIN

  INSERT INTO blogpagescategories (
    bpc_bcaid, bpc_bpaid
  ) VALUES (
    _bcaid, _bpaid
  );

  CALL blogpagescategories_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_replace;

delimiter ;;

CREATE PROCEDURE blogpagescategories_replace(
  IN _bpaid   INT,
  IN _bcaids  VARCHAR(100)
)
BEGIN
  DELETE
    FROM blogpagescategories
   WHERE bpc_bpaid = _bpaid;

  CALL create_temp_table_id_list(_bcaids);

  INSERT INTO blogpagescategories (bpc_bpaid, bpc_bcaid)
    SELECT _bpaid, bca_bcaid
      FROM blogcategories
           INNER JOIN _id_list ON _il_id = bca_bcaid;

  SELECT *
    FROM blogpagescategories
   WHERE bpc_bpaid = _bpaid;
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_search;

delimiter ;;

CREATE PROCEDURE blogpagescategories_search(
  IN _bpcid    int(11),
  IN _bpaid    int(11),
  IN _bcaid    int(11)
)
BEGIN
  SELECT *
    FROM blogpagescategories
         INNER JOIN blogCategories ON bca_bcaid = bpc_bcaid
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_bpcid IS NULL OR bpc_bpcid = _bpcid)
     AND (_bpaid IS NULL OR bpc_bpaid = _bpaid)
     AND (_bcaid IS NULL OR bpc_bcaid = _bcaid);
END;;

delimiter ;
DROP procedure IF EXISTS blogpagescategories_update;

delimiter ;;

CREATE PROCEDURE blogpagescategories_update(
  IN _bpcid    int(11),
  IN _bcaid    int(11),
  IN _bpaid    int(11)
)
BEGIN
  UPDATE blogpagescategories
     SET bpc_bcaid = IFNULL(_bcaid,  bpc_bcaid),
         bpc_bpaid = IFNULL(_bpaid,  bpc_bpaid)
   WHERE bpc_bpcid = _bpcid;

  CALL blogpagescategories_get_by_ids(_bpcid);
END;;

delimiter ;
DROP procedure IF EXISTS blogpages_delete;

delimiter ;;

CREATE PROCEDURE blogpages_delete(
  IN _bpaid integer
)
BEGIN
  DELETE
    FROM blogpages
   WHERE bpa_bpaid = _bpaid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogpages_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogpages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogpages
         INNER JOIN _id_list ON _il_id = bpa_bpaid;
END;;

delimiter ;
DROP procedure IF EXISTS blogpages_insert;

delimiter ;;

CREATE PROCEDURE blogpages_insert(
  IN _blog          int(11),
  IN _title         varchar(100),
  IN _alias         varchar(100),
  IN _body          longtext,
  IN _standalone    tinyint(1)
)
BEGIN
  SET _standalone = IFNULL(_standalone, 0);

  INSERT INTO blogpages (
    bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_standalone
  ) VALUES (
    _blog, _title, _alias, _body, _standalone
  );

  CALL blogpages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogpages_search;

delimiter ;;

CREATE PROCEDURE blogpages_search(
  IN _bpaid    int(11),
  IN _blog     int(11),
  IN _title    varchar(100),
  IN _alias    varchar(100)
)
BEGIN
  SELECT blogpages.*, us_user AS bpa_blogname
    FROM blogpages
         INNER JOIN users ON us_usid = bpa_blog
   WHERE (_bpaid IS NULL OR bpa_bpaid = _bpaid)
     AND (_blog IS NULL OR bpa_blog = _blog)
     AND (_title IS NULL OR bpa_title = _title)
     AND (_alias IS NULL OR bpa_alias = _alias);
END;;

delimiter ;
DROP procedure IF EXISTS blogpages_update;

delimiter ;;

CREATE PROCEDURE blogpages_update(
  IN _bpaid         int(11),
  IN _blog          int(11),
  IN _title         varchar(100),
  IN _alias         varchar(100),
  IN _body          longtext,
  IN _standalone    tinyint(1)
)
BEGIN
  UPDATE blogpages
     SET bpa_blog       = IFNULL(_blog,        bpa_blog),
         bpa_title      = IFNULL(_title,       bpa_title),
         bpa_alias      = IFNULL(_alias,       bpa_alias),
         bpa_body       = IFNULL(_body,        bpa_body),
         bpa_standalone = IFNULL(_standalone,  bpa_standalone)
   WHERE bpa_bpaid = _bpaid;

  CALL blogpages_get_by_ids(_bpaid);
END;;

delimiter ;
DROP procedure IF EXISTS blogroles_delete;

delimiter ;;

CREATE PROCEDURE blogroles_delete(
  IN _broid integer
)
BEGIN
  DELETE
    FROM blogroles
   WHERE bro_broid = _broid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogroles_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogroles_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogroles
         INNER JOIN _id_list ON _il_id = bro_broid;
END;;

delimiter ;
DROP procedure IF EXISTS blogroles_insert;

delimiter ;;

CREATE PROCEDURE blogroles_insert(
  IN _role           varchar(50),
  IN _description    varchar(255)
)
BEGIN

  INSERT INTO blogroles (
    bro_role, bro_description
  ) VALUES (
    _role, _description
  );

  CALL blogroles_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogroles_search;

delimiter ;;

CREATE PROCEDURE blogroles_search(
  IN _broid    int(11),
  IN _role     varchar(50)
)
BEGIN
  SELECT *
    FROM blogroles
   WHERE (_broid IS NULL OR bro_broid = _broid)
     AND (_role IS NULL OR bro_role = _role);
END;;

delimiter ;
DROP procedure IF EXISTS blogroles_update;

delimiter ;;

CREATE PROCEDURE blogroles_update(
  IN _broid          int(11),
  IN _role           varchar(50),
  IN _description    varchar(255)
)
BEGIN
  UPDATE blogroles
     SET bro_role        = IFNULL(_role,         bro_role),
         bro_description = IFNULL(_description,  bro_description)
   WHERE bro_broid = _broid;

  CALL blogroles_get_by_ids(_broid);
END;;

delimiter ;
DROP procedure IF EXISTS blogtextblocks_delete;

delimiter ;;

CREATE PROCEDURE blogtextblocks_delete(
  IN _btbid integer
)
BEGIN
  DELETE
    FROM blogtextblocks
   WHERE btb_btbid = _btbid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS blogtextblocks_get_by_ids;

delimiter ;;

CREATE PROCEDURE blogtextblocks_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM blogtextblocks
         INNER JOIN _id_list ON _il_id = btb_btbid;
END;;

delimiter ;
DROP procedure IF EXISTS blogtextblocks_insert;

delimiter ;;

CREATE PROCEDURE blogtextblocks_insert(
  IN _blog     int(11),
  IN _label    varchar(100),
  IN _body     longtext
)
BEGIN

  INSERT INTO blogtextblocks (
    btb_blog, btb_label, btb_body
  ) VALUES (
    _blog, _label, _body
  );

  CALL blogtextblocks_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS blogtextblocks_search;

delimiter ;;

CREATE PROCEDURE blogtextblocks_search(
  IN _btbid    int(11),
  IN _blog     int(11),
  IN _label    varchar(100)
)
BEGIN
  SELECT *
    FROM blogtextblocks
   WHERE (_btbid IS NULL OR btb_btbid = _btbid)
     AND (_blog IS NULL OR btb_blog = _blog)
     AND (_label IS NULL OR btb_label = _label);
END;;

delimiter ;
DROP procedure IF EXISTS blogtextblocks_update;

delimiter ;;

CREATE PROCEDURE blogtextblocks_update(
  IN _btbid    int(11),
  IN _blog     int(11),
  IN _label    varchar(100),
  IN _body     longtext
)
BEGIN
  UPDATE blogtextblocks
     SET btb_blog  = IFNULL(_blog,   btb_blog),
         btb_label = IFNULL(_label,  btb_label),
         btb_body  = IFNULL(_body,   btb_body)
   WHERE btb_btbid = _btbid;

  CALL blogtextblocks_get_by_ids(_btbid);
END;;

delimiter ;
DROP procedure IF EXISTS bloguserroles_delete;

delimiter ;;

CREATE PROCEDURE bloguserroles_delete(
  IN _burid integer
)
BEGIN
  DELETE
    FROM bloguserroles
   WHERE bur_burid = _burid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS bloguserroles_get_by_ids;

delimiter ;;

CREATE PROCEDURE bloguserroles_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM bloguserroles
         INNER JOIN _id_list ON _il_id = bur_burid;
END;;

delimiter ;
DROP procedure IF EXISTS bloguserroles_insert;

delimiter ;;

CREATE PROCEDURE bloguserroles_insert(
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN

  INSERT INTO bloguserroles (
    bur_usid, bur_broid, bur_blog
  ) VALUES (
    _usid, _broid, _blog
  );

  CALL bloguserroles_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS bloguserroles_search;

delimiter ;;

CREATE PROCEDURE bloguserroles_search(
  IN _burid    int(11),
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN
  SELECT *
    FROM bloguserroles
   WHERE (_burid IS NULL OR bur_burid = _burid)
     AND (_usid IS NULL OR bur_usid = _usid)
     AND (_broid IS NULL OR bur_broid = _broid)
     AND (_blog IS NULL OR bur_blog = _blog);
END;;

delimiter ;
DROP procedure IF EXISTS bloguserroles_update;

delimiter ;;

CREATE PROCEDURE bloguserroles_update(
  IN _burid    int(11),
  IN _usid     int(11),
  IN _broid    int(11),
  IN _blog     int(11)
)
BEGIN
  UPDATE bloguserroles
     SET bur_usid  = IFNULL(_usid,   bur_usid),
         bur_broid = IFNULL(_broid,  bur_broid),
         bur_blog  = IFNULL(_blog,   bur_blog)
   WHERE bur_burid = _burid;

  CALL bloguserroles_get_by_ids(_burid);
END;;

delimiter ;
DROP PROCEDURE IF EXISTS create_temp_table_id_list;

delimiter ;;

CREATE PROCEDURE create_temp_table_id_list(
  IN _ids TEXT
)
BEGIN
  DECLARE id INT;
  DECLARE pos INT DEFAULT INSTR(_ids, ',');

  DROP TEMPORARY TABLE IF EXISTS _id_list;
  CREATE TEMPORARY TABLE _id_list (_il_id INT PRIMARY KEY);

  IF LENGTH(_ids) THEN
    WHILE pos > 0 DO
      INSERT INTO _id_list VALUES (SUBSTRING_INDEX(_ids, ',', 1));
      SET _ids = MID(_ids, pos + 1, CHAR_LENGTH(_ids));
      SET pos = INSTR(_ids, ',');
    END WHILE;
    INSERT INTO _id_list VALUES (_ids);
  END IF;
END
;;

delimiter ;
DROP PROCEDURE IF EXISTS create_temp_table_sid_list;

delimiter ;;

CREATE PROCEDURE create_temp_table_sid_list(
  IN _ids TEXT
)
BEGIN
  DECLARE pos INT DEFAULT INSTR(_ids, ',');

  DROP TEMPORARY TABLE IF EXISTS _sid_list;
  CREATE TEMPORARY TABLE _sid_list (_il_sid VARCHAR(10) PRIMARY KEY);

  IF LENGTH(_ids) THEN
    WHILE pos > 0 DO
      INSERT INTO _sid_list VALUES (SUBSTRING_INDEX(_ids, ',', 1));
      SET _ids = MID(_ids, pos + 1, CHAR_LENGTH(_ids));
      SET pos = INSTR(_ids, ',');
    END WHILE;
    INSERT INTO _sid_list VALUES (_ids);
  END IF;
END
;;

delimiter ;
DROP procedure IF EXISTS userimages_delete;

delimiter ;;

CREATE PROCEDURE userimages_delete(
  IN _uiid integer
)
BEGIN
  DELETE
    FROM userimages
   WHERE ui_uiid = _uiid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS userimages_get_by_ids;

delimiter ;;

CREATE PROCEDURE userimages_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM userimages
         INNER JOIN _id_list ON _il_id = ui_uiid;
END;;

delimiter ;
DROP procedure IF EXISTS userimages_insert;

delimiter ;;

CREATE PROCEDURE userimages_insert(
  IN _usid       int(11),
  IN _width      int(11),
  IN _height     int(11),
  IN _size       int(11),
  IN _filename   varchar(100),
  IN _type       varchar(10)
)
BEGIN
  INSERT INTO userimages (
    ui_usid, ui_width, ui_height, ui_size, ui_filename, ui_type, ui_dla
  ) VALUES (
    _usid, _width, _height, _size, _filename, _type, CURRENT_TIMESTAMP
  );

  CALL userimages_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS userimages_search;

delimiter ;;

CREATE PROCEDURE userimages_search(
  IN _uiid   int(11),
  IN _usid   int(11),
  IN _term   VARCHAR(50)
)
BEGIN
  SELECT *
    FROM userimages
   WHERE (_uiid IS NULL OR ui_uiid = _uiid)
     AND (_usid IS NULL OR ui_usid = _usid)
     AND (_term IS NULL OR ui_filename REGEXP CONVERT(_term USING latin1));
END;;

delimiter ;
DROP procedure IF EXISTS userimages_update;

delimiter ;;

CREATE PROCEDURE userimages_update(
  IN _uiid       int(11),
  IN _usid       int(11),
  IN _width      int(11),
  IN _height     int(11),
  IN _size       int(11),
  IN _filename   varchar(100),
  IN _type       varchar(10)
)
BEGIN
  UPDATE userimages
     SET ui_usid     = IFNULL(_usid,     ui_usid),
         ui_width    = IFNULL(_width,    ui_width),
         ui_height   = IFNULL(_height,   ui_height),
         ui_size     = IFNULL(_size,     ui_size),
         ui_filename = IFNULL(_filename, ui_filename),
         ui_type     = IFNULL(_type,     ui_type),
         ui_dla      = CURRENT_TIMESTAMP
   WHERE ui_uiid = _uiid;

  CALL userimages_get_by_ids(_uiid);
END;;

delimiter ;
DROP procedure IF EXISTS userprofile_delete;

delimiter ;;

CREATE PROCEDURE userprofile_delete(
  IN _upid integer
)
BEGIN
  DELETE
    FROM userprofile
   WHERE up_upid = _upid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS userprofile_get_by_ids;

delimiter ;;

CREATE PROCEDURE userprofile_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM userprofile
         INNER JOIN _id_list ON _il_id = up_upid;
END;;

delimiter ;
DROP procedure IF EXISTS userprofile_insert;

delimiter ;;

CREATE PROCEDURE userprofile_insert(
  IN _usid        int(11),
  IN _firstname   varchar(50),
  IN _lastname    varchar(50),
  IN _bio         text,
  IN _location    varchar(100)
)
BEGIN
  INSERT INTO userprofile (
    up_usid, up_firstname, up_lastname, up_bio, up_location, up_dla
  ) VALUES (
    _usid, _firstname, _lastname, _bio, _location, CURRENT_TIMESTAMP
  );

  CALL userprofile_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS userprofile_search;

delimiter ;;

CREATE PROCEDURE userprofile_search(
  IN _upid   int(11),
  IN _usid   int(11)
)
BEGIN
  SELECT *
    FROM userprofile
   WHERE (_upid IS NULL OR up_upid = _upid)
     AND (_usid IS NULL OR up_usid = _usid);
END;;

delimiter ;
DROP procedure IF EXISTS userprofile_update;

delimiter ;;

CREATE PROCEDURE userprofile_update(
  IN _upid        int(11),
  IN _usid        int(11),
  IN _firstname   varchar(50),
  IN _lastname    varchar(50),
  IN _bio         text,
  IN _location    varchar(100)
)
BEGIN
  UPDATE userprofile
     SET up_usid      = IFNULL(_usid,      up_usid),
         up_firstname = IFNULL(_firstname, up_firstname),
         up_lastname  = IFNULL(_lastname,  up_lastname),
         up_bio       = IFNULL(_bio,       up_bio),
         up_location  = IFNULL(_location,  up_location),
         up_dla       = CURRENT_TIMESTAMP
   WHERE up_upid = _upid;

  CALL userprofile_get_by_ids(_upid);
END;;

delimiter ;
DROP procedure IF EXISTS users_delete;

delimiter ;;

CREATE PROCEDURE users_delete(
  IN _usid integer
)
BEGIN
  DELETE
    FROM users
   WHERE us_usid = _usid;

  SELECT ROW_COUNT() AS delete_count;
END;;

delimiter ;
DROP procedure IF EXISTS users_get_by_ids;

delimiter ;;

CREATE PROCEDURE users_get_by_ids(
  IN _ids text
)
BEGIN
  CALL create_temp_table_id_list(_ids);

  SELECT *
    FROM users
         INNER JOIN _id_list ON _il_id = us_usid;
END;;

delimiter ;
DROP procedure IF EXISTS users_insert;

delimiter ;;

CREATE PROCEDURE users_insert(
  IN _user          varchar(50),
  IN _password      varchar(100),
  IN _email         varchar(50),
  IN _permissions   tinyint(4),
  IN _active        tinyint(1),
  IN _deleted       tinyint(1)
)
BEGIN
  SET _permissions = IFNULL(_permissions, 0);
  SET _active = IFNULL(_active, 1);
  SET _deleted = IFNULL(_deleted, 0);

  INSERT INTO users (
    us_user, us_password, us_email, us_permissions, us_active, us_deleted, us_added, us_dla
  ) VALUES (
    _user, _password, _email, _permissions, _active, _deleted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  );

  CALL users_get_by_ids(LAST_INSERT_ID());
END;;

delimiter ;
DROP procedure IF EXISTS users_search;

delimiter ;;

CREATE PROCEDURE users_search(
  IN _usid     int(11),
  IN _user     varchar(50),
  IN _email    varchar(50)
)
BEGIN
  SELECT *
    FROM users
   WHERE (_usid IS NULL OR us_usid = _usid)
     AND (_user IS NULL OR us_user = CONVERT(_user USING latin1))
     AND (_email IS NULL OR us_email = CONVERT(_email USING latin1));
END;;

delimiter ;
DROP procedure IF EXISTS users_update;

delimiter ;;

CREATE PROCEDURE users_update(
  IN _usid          int(11),
  IN _user          varchar(50),
  IN _password      varchar(100),
  IN _email         varchar(50),
  IN _permissions   tinyint(4),
  IN _active        tinyint(1),
  IN _deleted       tinyint(1)
)
BEGIN
  UPDATE users
     SET us_user        = IFNULL(_user,        us_user),
         us_password    = IFNULL(_password,    us_password),
         us_email       = IFNULL(_email,       us_email),
         us_permissions = IFNULL(_permissions, us_permissions),
         us_active      = IFNULL(_active,      us_active),
         us_deleted     = IFNULL(_deleted,     us_deleted),
         us_dla         = CURRENT_TIMESTAMP
   WHERE us_usid = _usid;

  CALL users_get_by_ids(_usid);
END;;

delimiter ;
