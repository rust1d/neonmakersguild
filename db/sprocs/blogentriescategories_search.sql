DROP procedure IF EXISTS blogentriescategories_search;

delimiter ;;

CREATE PROCEDURE blogentriescategories_search(
  IN _becid    int(11),
  IN _benid    int(11)
)
BEGIN
  SELECT blogentriescategories.*, bca_category AS bec_category, bca_alias AS bec_alias
    FROM blogentriescategories
         INNER JOIN blogCategories ON bca_bcaid = bec_bcaid
   WHERE (_becid IS NULL OR bec_becid = _becid)
     AND (_benid IS NULL OR bec_benid = _benid);
END;;

delimiter ;
