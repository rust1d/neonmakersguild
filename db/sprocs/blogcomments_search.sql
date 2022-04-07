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
