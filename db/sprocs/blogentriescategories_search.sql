DROP procedure IF EXISTS blogentriescategories_search;

delimiter ;;

CREATE PROCEDURE blogentriescategories_search(
  IN _becid    int(11),
  IN _benid    int(11),
  IN _bcaid    int(11),
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
