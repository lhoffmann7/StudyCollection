-- Aufruf der Dateien zur Erzeugung der Mondial-Datenbasis

spool create.log

start mondial-drop-tables;
start mondial-schema;
start mondial-inputs;

spool off
prompt Logfile 'create.log' erzeugt...
