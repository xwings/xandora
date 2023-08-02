truncate stat_ip;
truncate stat_domain;
truncate stat_country;
truncate stat_malware;

insert into stat_country(country, count) 
select country, count(country) as count from trafficinfo group by country;

insert into stat_domain(domain, country, count) 
select domain, country, count(domain) as count from trafficinfo group by
domain;

insert into stat_ip(ipv4, country, count) 
select ipv4, country, count(ipv4) as count from trafficinfo group by ipv4;

insert into stat_malware(name, count) 
select scaninfo.name, count(scaninfo.name) as count from malwareinfo,scaninfo
where malwareinfo.xid=scaninfo.xid group by scaninfo.name order by count desc;
