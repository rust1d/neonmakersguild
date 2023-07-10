DROP procedure IF EXISTS subscriptions_alerts;

delimiter ;;

CREATE PROCEDURE subscriptions_alerts()
BEGIN
  SELECT *
    FROM (
           SELECT subscriptions.*, al_since,
                  (SELECT GROUP_CONCAT(DISTINCT us_user)
                     FROM forumMessages
                          INNER JOIN users ON us_usid = fm_usid
                    WHERE fm_foid = al_foid
                      AND fm_dla >= al_since
                      AND fm_usid <> ss_usid
                  ) AS al_users_posting
             FROM subscriptions
                  INNER JOIN (
                    SELECT ft_foid AS al_foid, MIN(ss_added) AS al_since
                      FROM subscriptions
                           INNER JOIN forumThreads ON ss_fkey=ft_ftid AND ss_table='ForumThreads'
                       WHERE ss_usid=0
                       GROUP BY ft_foid
                  ) AS alerts ON al_foid=ss_fkey AND ss_table='Forums' AND ss_usid<>0

           UNION

           SELECT subscriptions.*, al_since,
                  (SELECT GROUP_CONCAT(DISTINCT us_user)
                     FROM forumMessages
                          INNER JOIN users ON us_usid = fm_usid
                    WHERE fm_ftid = al_ftid
                      AND fm_dla >= al_since
                      AND fm_usid <> ss_usid
                  ) AS al_users_posting
             FROM subscriptions
                  INNER JOIN (
                    SELECT ft_ftid AS al_ftid, MIN(ss_added) AS al_since
                      FROM subscriptions
                           INNER JOIN forumThreads ON ft_ftid=ss_fkey AND ss_table='ForumThreads'
                       WHERE ss_usid=0
                       GROUP BY ft_ftid
                  ) AS alerts ON al_ftid=ss_fkey AND ss_table='ForumThreads' AND ss_usid<>0
         ) AS alerts
   WHERE al_users_posting IS NOT NULL
   ORDER BY ss_usid, ss_table, ss_fkey;
END;;

delimiter ;
