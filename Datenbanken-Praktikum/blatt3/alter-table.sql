alter table country add constraint cap foreign key (capital,code,province) references city(name,country,province) on delete cascade;
alter table country disable constraint cap;
--
alter table city add constraint cit foreign key (province,country) references province (name,country) on delete cascade;
alter table city disable constraint cit;
