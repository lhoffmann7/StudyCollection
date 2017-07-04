-- connect by, laenge des amazonas flussnetzes, anzuwenden auf zaire und blub

--select 'Amazonas',sum(length) from river start with name='Amazonas' connect by river = prior name;

--anwendung auf zaire und donau
create or replace view riverorlake as select name,river,0 as length from lake l union (select name,river,length from river r) union (select name,lake,length from river);

select 'Zaire',sum(length) from riverorlake start with name='Zaire' connect by nocycle river = prior name;

--select 'Zaire',sum(length) from river start with name='Zaire' connect by river = prior name;

select 'Donau',sum(length) from riverorlake start with name='Donau' connect by nocycle river = prior name;

--select 'Donau',sum(length) from river start with name='Donau' connect by river = prior name;
