new member callout on front

recent activity - thread/message double dip.

 profile page entry field that opens modal with new entry

new user subscript to forums

reminder notes - color code by age



  db pwd nmg/BLHZ13n05Y3sSiWVnmg -- UN: neonmakeDBAmain / PW: C7g4#$3Qzw$v

  SELECT ben_benid, ben_usid,
         IF(ben_blog = 1 AND OR ben_promoted < CURRENT_TIMESTAMP, 1, 0), ben_frontpage,
         GROUP_CONCAT(bei_beiid) AS ben_beiids
    FROM blogentries
         LEFT OUTER JOIN blogentryimages ON bei_benid = ben_benid
   WHERE ben_released = 1
     AND ben_posted < CURRENT_TIMESTAMP
   GROUP BY ben_benid


        IF(ben_blog = 1 AND (ben_posted < CURRENT_TIMESTAMP OR ben_promoted < CURRENT_TIMESTAMP))


  <span class='me-1'>
    <a class='btn btn-icon btn-icon-link' data-bs-toggle='modal' data-bs-target='##aboutModal' aria-expanded='false'>
      <i class='fa-solid fa-circle-info fa-lg'></i>
    </a>
  </span>
  <div class='modal fade member-about' id='aboutModal' tabindex='-1' aria-hidden='true'>
    <div class='modal-dialog modal-dialog-scrollable modal-fullscreen-xs-down modal-lg'>
      <div class='modal-content'>
        <div class='modal-header'>
          <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
        </div>
        <div class='modal-body'>
          #mUser.UserProfile().bio()#
        </div>
      </div>
    </div>
  </div>