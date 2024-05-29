with cte_customer as
(
select 
	customer_id
	, first_name
	, last_name
from customer 
)

, cte_rental as
(
select
	rental_id
	, inventory_id
	, customer_id
	, rental_date
	, return_date
from
	rental
)

, cte_payment as
(
select
	payment_id
	, amount
	, rental_id
from
	payment
)

, cte_inventory as
(
select
	inventory_id
	, film_id
from
	inventory
)

,cte_film as
(
select 
	film_id
	, title
	, rating
	, rental_duration
from 
	film
)

, cte_filmcategory as
(
select
	category_id
	, film_id
from
	film_category
)

, cte_category as
(
select 
	name
	, category_id
from
	category
)

, cte_datamart as 
(
select 
	cte_customer.customer_id
	, cte_customer.first_name
	, cte_customer.last_name
	, cte_rental.rental_id
	, cte_rental.rental_date as tanggal_peminjaman
	, cte_rental.return_date as tanggal_pengembalian
	, cte_film.film_id
	, cte_film.title
	, cte_film.rating
	, cte_film.rental_duration
	, cte_category.name as kategori_film
	, cte_payment.amount
from
	cte_customer
left join
	cte_rental
on
	cte_customer.customer_id = cte_rental.customer_id
left join 
	cte_payment
on
	cte_rental.rental_id = cte_payment.rental_id
left join
	cte_inventory
on
	cte_rental.inventory_id = cte_inventory.inventory_id
left join
	cte_film
on
	cte_inventory.film_id = cte_film.film_id
left join
	cte_filmcategory
on
	cte_film.film_id = cte_filmcategory.film_id
left join
	cte_category
on
	cte_filmcategory.category_id = cte_category.category_id
)


select 
	*
from 
	cte_datamart

--SOAL 1 'Melihat Pendapatan Sewa dari Film berdasarkan:'
-- 1a 'Frekuensi Peminjaman'
--select 
--	distinct(title)
--	, sum(amount) as pendapatan_sewa
--from
--	cte_datamart
--group by
-- 	1
--order by 
--	1

-- 1b 'Rating Film'
--select 
--	distinct(rating)
--	, round(sum(amount)) as pendapatan_sewa
--from
--	cte_datamart
--group by
-- 	1
--order by 
--	1

-- 1c 'Kategori Film'
--select 
--	distinct(kategori_film)
--	, round(sum(amount)) as pendapatan_sewa
--from
--	cte_datamart
--group by
-- 	1
--order by 
--	1

--SOAL 2 'Melakukan Segmentasi Customer'
--2a 'Frekuensi Peminjaman'
--select 
--	first_name
--	, last_name
--	, count(title) as frekuensi_peminjaman
--	, case
--	  when count(title) >= 30 then 'high'
--	  when count(title) <= 30 then 'low'
--	end as frekuensi peminjaman
--from
--	cte_datamart
--group by 1, 2
--order by 3

--2b 'Total Biaya Sewa'
--select 
--	first_name
--	, last_name
--	, sum(amount) as total_biaya_sewa
--from 
--	cte_datamart
--group by
--	1, 2
--order by 
--	3

--2c 'Jenis film yang sering disewa (kategori dan rating film)'
--select
--    kategori_film
--    , rating
--    , count(*) as total_rentals
--from
--    cte_datamart
--group by
--    1, 2
--order by
--    3 desc
   
--SOAL 3 'Melihat Informasi Keterlambatan sewa'
--3a 'Film yang paling sering terlambat'
select
    title
    , rental_duration
    , count(*) AS total_keterlambatan_pengembalian
from
    cte_datamart
where
    tanggal_pengembalian > tanggal_peminjaman + INTERVAL '1 day' * rental_duration
group by
   	1, 2
having
    count(*) > 0
order by
    3 desc

--3b 'Berapa jumlah pembatalan dalam periode tertentu'
--select
--    count(film_id) AS jumlah_pembatalan
--from
--	cte_datamart
--where 
--	tanggal_pengembalian is null