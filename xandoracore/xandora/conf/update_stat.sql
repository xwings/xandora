truncate stat_ip;
truncate stat_domain;
truncate stat_country;
truncate stat_malware;

insert into stat_country(country, count) select country,
count(country) as count from trafficinfo where country !='IP' group by country;

insert into stat_domain(domain, country, count) select domain,
country, count(domain) as count from trafficinfo where country !='IP' and domain != '' group by domain;

insert into stat_ip(ipv4, country, count) select ipv4, country,
count(ipv4) as count from trafficinfo where country !='IP' and ipv4 != '192.228.128.18' group by ipv4;

insert into stat_malware(md5, count) select md5, count(md5) as count
from malwareinfo group by md5;
