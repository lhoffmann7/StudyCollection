-- Aufruf der Dateien zur Erzeugung der Mondial-Datenbasis

spool /afs/informatik.uni-goettingen.de/user/s/stefan.siemer/wuff/create.log

start mondial-drop-tables;
start XYmondial-schema;
--start alter-table;
start mondial-inputs;
start enable-constraints;

spool off
prompt Logfile 'create.log' erzeugt...
