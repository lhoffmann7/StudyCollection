--select 'alter table '||table_name||' drop constraint '||constraint_name||';' from user_constraints where constraint_type ='R';
--alter table MOUNTAINONISLAND drop constraint MNT;
--alter table LOCATEDON drop constraint CITLOCON;
--alter table LOCATEDON drop constraint PROVLOCON;
--alter table LOCATEDON drop constraint CUNTLOCON;
--alter table LOCATED drop constraint CITLOC;
--alter table LOCATED drop constraint PROVLOC;
--alter table LOCATED drop constraint CUNTLOC;
--alter table GEO_ESTUARY drop constraint PROVEST;
--alter table GEO_ESTUARY drop constraint CUNTEST;
--alter table GEO_SOURCE drop constraint PROVSRC;
--alter table GEO_SOURCE drop constraint CUNTSRC;
--alter table GEO_LAKE drop constraint PROVLAKE;
--alter table GEO_LAKE drop constraint CUNTLAKE;
--alter table GEO_SEA drop constraint PROVSEA;
--alter table GEO_SEA drop constraint CUNTSEA;
--alter table GEO_RIVER drop constraint PROVRIV;
--alter table GEO_RIVER drop constraint CUNTRIV;
--alter table GEO_ISLAND drop constraint PROVISL;
--alter table GEO_ISLAND drop constraint CUNTISL;
--alter table GEO_DESERT drop constraint PROVDES;
--alter table GEO_DESERT drop constraint CUNTDES;
--alter table GEO_MOUNTAIN drop constraint DELM;
--alter table ISMEMBER drop constraint PLZNODEL;
--alter table ISMEMBER drop constraint SYS_C0056166;
--alter table ISMEMBER drop constraint SYS_C0056165;
--alter table ORGANIZATION drop constraint FCITY;
--alter table ENCOMPASSES drop constraint SYS_C0056159;
--alter table ENCOMPASSES drop constraint SYS_C0056158;
--alter table BORDERS drop constraint SYS_C0056155;
--alter table BORDERS drop constraint SYS_C0056154;
--alter table CITYPOPS drop constraint FOREIGNKEY1;
--alter table COUNTRYPOPS drop constraint SYS_C0056143;
--alter table ETHNICGROUP drop constraint SYS_C0056139;
--alter table LANGUAGE drop constraint SYS_C0056133;
--alter table POLITICS drop constraint SYS_C0056130;
--alter table POPULATION drop constraint SYS_C0056129;
--alter table ECONOMY drop constraint SYS_C0056128;
--alter table CITY drop constraint PROV;
--alter table PROVINCE drop constraint PCAP;
--alter table PROVINCE drop constraint CUNT;
--alter table COUNTRY drop constraint CAP;

begin
    for r in ( select table_name, constraint_name
               from user_constraints
               where constraint_type = 'R' )
    loop
        execute immediate 'alter table '||r.table_name
                          ||' disable constraint '||r.constraint_name;
    end loop;
end loop;
/
