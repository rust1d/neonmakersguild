ALTER TABLE BlogLinks ADD COLUMN bli_added DATETIME AFTER bli_clicks;

UPDATE BlogLinks set bli_added = bli_dla;

DROP TEMPORARY TABLE IF EXISTS bloglinks_fix;

CREATE TEMPORARY TABLE bloglinks_fix AS
  SELECT bli.bli_bliid AS current_id,
        (
          SELECT MIN(b2.bli_added)
          FROM bloglinks AS b2
          WHERE b2.bli_bliid > bli.bli_bliid
        ) AS new_added
  FROM bloglinks AS bli
  WHERE (
    SELECT MIN(b2.bli_added)
    FROM bloglinks AS b2
    WHERE b2.bli_bliid > bli.bli_bliid
  ) < bli.bli_added;


UPDATE bloglinks AS bli
       INNER JOIN bloglinks_fix AS fix ON fix.current_id = bli.bli_bliid
   SET bli.bli_added = fix.new_added;
