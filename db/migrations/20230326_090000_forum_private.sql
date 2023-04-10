-- alter table forums drop column fo_private;

alter table forums
  add column fo_private     TINYINT(1) DEFAULT 0 after fo_admin
;

update forums set fo_private = 0;
