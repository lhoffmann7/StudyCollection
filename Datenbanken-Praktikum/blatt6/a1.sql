create or replace procedure del_riv (name VARCHAR2) as language java name 'DeleteRiver.delRiver(java.lang.String)';
/

create or replace procedure del_lake (name VARCHAR2) as language java name 'DeleteRiver.delLake(java.lang.String)';
/

create or replace procedure del_sea (name VARCHAR2) as language java name 'DeleteRiver.delSea(java.lang.String)';
/
