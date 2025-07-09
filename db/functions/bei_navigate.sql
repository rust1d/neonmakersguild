/* GIVEN A BEIID/UIID ATTEMPT TO FIND THE NEXT RECORD TO NAVIGATE TO */

DROP FUNCTION IF EXISTS bei_navigate;

DELIMITER ;;

CREATE FUNCTION bei_navigate(
  _beiid     INT,
  _uiid      INT,
  _direction TINYINT
)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE _benid  INT;
  DECLARE _posted DATETIME;
  DECLARE _next   INT;
  DECLARE _count  INT;
  DECLARE _new    INT;

  SELECT bei_benid, ben_posted INTO _benid, _posted
    FROM blogentryimages
    JOIN blogentries ON ben_benid = bei_benid
   WHERE bei_beiid = _beiid;

  SELECT COUNT(*) INTO _count
    FROM blogentryimages
   WHERE bei_benid = _benid;

  -- If only one image: go to next/prev blogentry
  IF _count = 1 THEN
    SELECT ben_benid INTO _new
      FROM blogentries
     WHERE (_direction = 1 AND ben_posted > _posted OR _direction = 0 AND ben_posted < _posted)
       AND (_uiid IS NULL OR ben_uiid = _uiid)
     ORDER BY CASE WHEN _direction = 1 THEN ben_benid ELSE -ben_benid END
     LIMIT 1;

    IF _new IS NULL THEN
      RETURN _beiid;
    END IF;

    SELECT bei_beiid INTO _next
      FROM blogentryimages
     WHERE bei_benid = _new
     ORDER BY CASE WHEN _direction = 1 THEN bei_beiid ELSE -bei_beiid END
     LIMIT 1;

    RETURN _next;
  END IF;

  -- Try next/prev image within same post
  SELECT bei_beiid INTO _next
    FROM blogentryimages
   WHERE bei_benid = _benid
     AND (_direction = 1 AND bei_beiid > _beiid) OR (_direction = 0 AND bei_beiid < _beiid)
   ORDER BY CASE WHEN _direction = 1 THEN bei_beiid ELSE -bei_beiid END
   LIMIT 1;

  IF _next IS NOT NULL THEN
    RETURN _next;
  END IF;

  -- Rotate to first/last in current post
  SELECT bei_beiid INTO _next
    FROM blogentryimages
   WHERE bei_benid = _benid
   ORDER BY CASE WHEN _direction = 1 THEN bei_beiid ELSE -bei_beiid END
   LIMIT 1;

  RETURN _next;
END;;

DELIMITER ;
