create database codingchallenge;
 
use codingchallenge;

create table artists ( artistid int primary key, name varchar(255) not null, biography text,
nationality varchar(100));

insert into artists (artistid, name, biography, nationality) values (1, 'pablo picasso', 'renowned spanish painter and sculptor.', 'spanish'), (2, 'vincent van gogh', 'dutch post-impressionist painter.', 'dutch'),
(3, 'leonardo da vinci', 'italian polymath of the renaissance.', 'italian');

create table categories ( categoryid int primary key,
name varchar(100) not null);

insert into categories (categoryid, name) values (1, 'painting'), (2, 'sculpture'),
(3, 'photography');

create table artworks ( artworkid int primary key, title varchar(255) not null, artistid int, categoryid int, year int, description text, imageurl varchar(255), foreign key (artistid) references artists (artistid),
foreign key (categoryid) references categories (categoryid));

insert into artworks (artworkid, title, artistid, categoryid, year, description, imageurl)
values 
    (1, n'starry night', 2, 1, 1889, n'a famous painting by vincent van gogh.', n'starry_night.jpg'),
    (2, n'mona lisa', 3, 1, 1503, n'the iconic portrait by leonardo da vinci.', n'mona_lisa.jpg'),
    (3, n'guernica', 1, 1, 1937, n'pablo picasso''s powerful anti-war mural.', n'guernica.jpg');

create table exhibitions ( exhibitionid int primary key, title varchar(255) not null, startdate date, enddate date,
description text);

insert into exhibitions (exhibitionid, title, startdate, enddate, description) values (1, 'modern art masterpieces', '2023-01-01', '2023-03-01', 'a collection of modern art masterpieces.'),
(2, 'renaissance art', '2023-04-01', '2023-06-01', 'a showcase of renaissance art treasures.');

create table exhibitionartworks ( exhibitionid int, artworkid int, primary key (exhibitionid, artworkid), foreign key (exhibitionid) references exhibitions (exhibitionid),
foreign key (artworkid) references artworks (artworkid));

insert into exhibitionartworks (exhibitionid, artworkid) values (1, 1), (1, 2), (1, 3),
(2, 2);


--q1. 
select a.name as artistname, count(aw.artworkid) as artworkcount
from artists a
left join
artworks aw 
on a.artistid = aw.artistid
group by a.artistid, a.name
order by artworkcount desc;

--q2
select artworks.title, artists.nationality, artworks.year
from artworks 
join artists on artworks.artistid = artists.artistid
where artists.nationality in ('spanish', 'dutch')
order by artworks.year asc;


--q3
select 
	a.name as artistname, 
	count(ar.artworkid) as artworkcount
from 
	artists as a
join 
	artworks as ar 
on 
	a.artistid = ar.artistid
join 
	categories as c 
on 
	ar.categoryid = c.categoryid
where c.name = 'painting'
group by a.name;

--q4.
select 
	ar.title as artworktitle, 
	a.name as artistname, 
	c.name as categoryname
from 
	exhibitionartworks as ea
join 
	artworks ar 
on ea.artworkid = ar.artworkid
join 
	artists a on ar.artistid = a.artistid
join 
	categories c on ar.categoryid = c.categoryid
join 
	exhibitions e on ea.exhibitionid = e.exhibitionid
where 
	e.title = 'modern art masterpieces';

--q5.
select 
	a.name as artistname, 
	count(ar.artworkid) as artworkcount
from artists a
join 
	artworks ar on a.artistid = ar.artistid
group by a.name
having count(ar.artworkid)>2;

--q6.
select 
	ar.title as artworktitle
from artworks ar
join 
	exhibitionartworks ea1 on ar.artworkid = ea1.artworkid
join 
	exhibitions e1 on ea1.exhibitionid = e1.exhibitionid
join 
	exhibitionartworks ea2 on ar.artworkid = ea2.artworkid
join 
	exhibitions e2 on ea2.exhibitionid = e2.exhibitionid
where e1.title = 'modern art masterpieces'
and e2.title = 'renaissance art';

--q7. 
select c.name as categoryname, 
	count(ar.artworkid) as artworkcount
from categories c
join 
	artworks ar on c.categoryid = ar.categoryid
group by c.name;

/*select * from artworks;
select * from categories;*/


--q8. 
select a.name as artistname, 
	count(ar.artworkid) as artworkcount
from artists a
join 
	artworks ar on a.artistid = ar.artistid
group by a.name
having count(ar.artworkid) > 3;

--q9. 
select ar.title as artworktitle, 
	a.name as artistname, 
	a.nationality
from artworks ar
join 
	artists a on ar.artistid = a.artistid
where a.nationality = 'spanish';

--q10. 
select distinct e.title as exhibitiontitle
from exhibitions e
join 
	exhibitionartworks ea 
on e.exhibitionid = ea.exhibitionid
join 
	artworks ar on ea.artworkid = ar.artworkid
join 
	artists a on ar.artistid = a.artistid
where a.name in ('vincent van gogh', 'leonardo da vinci')
group by e.title
having count( a.name) = 2;


--q11.
select ar.title as artworktitle
from artworks ar
left join 
	exhibitionartworks ea on ar.artworkid = ea.artworkid
where ea.exhibitionid is null;

--q12.
select a.name as artistname
from artists a
join 
	artworks ar on a.artistid = ar.artistid
group by a.name
having count(distinct ar.categoryid) = (select count(*) from categories);

--q13. 
select c.name as categoryname, 
	count(ar.artworkid) as artworkcount
from categories c
join 
	artworks ar on c.categoryid = ar.categoryid
group by c.name;

--q14.
select a.name as artistname, 
	count(ar.artworkid) as artworkcount
from artists a
join 
	artworks ar on a.artistid = ar.artistid
group by a.name
having count(ar.artworkid) > 2;

--q15.
select c.name as categoryname, 
	avg(ar.year) as averageyear
from categories c
join 
	artworks ar on c.categoryid = ar.categoryid
group by c.name
having count(ar.artworkid) > 1;

--q16. 
select ar.title as artworktitle
from artworks ar
join 
	exhibitionartworks ea on ar.artworkid = ea.artworkid
join 
	exhibitions e on ea.exhibitionid = e.exhibitionid
where e.title = 'modern art masterpieces';

--q17.
select c.name as categoryname, 
	avg(ar.year) as categoryaverageyear
from categories c
join 
	artworks ar on c.categoryid = ar.categoryid
group by c.name
having avg(ar.year) > (select avg(year) from artworks);

--q18. 
select ar.title as artworktitle
from artworks ar
left join 
	exhibitionartworks ea on ar.artworkid = ea.artworkid
where ea.exhibitionid is null;

--q19.
select distinct a.name as artistname
from artists a
join 
	artworks ar on a.artistid = ar.artistid
where ar.categoryid = (
    select categoryid 
    from artworks 
    where title = 'mona lisa'
);

--q20.
select a.name as artistname, 
	count(ar.artworkid) as artworkcount
from artists a
left join 
	artworks ar on a.artistid = ar.artistid
group by a.name;










