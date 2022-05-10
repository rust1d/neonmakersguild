DROP procedure IF EXISTS userimages_uses;

delimiter ;;

CREATE PROCEDURE userimages_uses(
  IN _uiid  VARCHAR(50)
)
BEGIN
  SELECT 'profile' AS src_table, up_upid AS src_pkid
    FROM userprofile
   WHERE up_bio REGEXP _uiid
  UNION
  SELECT 'entries' AS src_table, ben_benid AS src_pkid
    FROM blogentries
   WHERE ben_image REGEXP _uiid OR ben_body REGEXP _uiid OR ben_morebody REGEXP _uiid
  UNION
  SELECT 'pages' AS src_table, bpa_bpaid AS src_pkid
    FROM blogpages
   WHERE bpa_body REGEXP _uiid
  UNION
  SELECT 'textblocks' AS src_table, btb_btbid AS src_pkid
    FROM blogtextblocks
   WHERE btb_body REGEXP _uiid;
END;;

delimiter ;
