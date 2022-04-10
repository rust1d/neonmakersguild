DROP procedure IF EXISTS blogpagescategories_search;

delimiter ;;

CREATE PROCEDURE blogpagescategories_search(
  IN _bpcid    int(11),
  IN _bcaid    int(11),
  IN _bpaid    int(11)
)
BEGIN
  SELECT blogpagescategories.*,
         bca_category AS bpc_category, bca_alias AS bpc_alias, us_user AS bpc_blogname
    FROM blogpagescategories
         INNER JOIN blogCategories ON bca_bcaid = bpc_bcaid
         INNER JOIN users ON us_usid = bca_blog
   WHERE (_bpcid IS NULL OR bpc_bpcid = _bpcid)
     AND (_bcaid IS NULL OR bpc_bcaid = _bcaid)
     AND (_bpaid IS NULL OR bpc_bpaid = _bpaid);
END;;

delimiter ;
