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
