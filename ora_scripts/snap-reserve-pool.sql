prompt
prompt
prompt === reserve pool (snap-reserve-pool.sql) ===;

col	fs		format	99,999,999	head 'Free|Spc'
col	afs		format	99,999,999	head 'Free|Avg'
col	fc		format	9999		head 'Free|Cnt'
col	mfs		format	99,999,999	head 'Free|Max'
col	us		format	99,999,999	head 'Used|Spc'
col	aus		format	999,999		head 'Used|Avg'
col	uc		format	9999		head 'Used|Cnt'
col	mus		format	999,999		head 'Used|Max'
col	r		format	99999999	head 'Req'
col	rm		format	999		head 'Miss|Req'
col	lms		format  999999		head 'Miss|Last'
col	mms		format  999999		head 'Miss|Max'
col	f		format	9999		head 'Req|Fai'
col	lfs		format  999,999		head 'Last|Fail|Size'
col	art		format  9999999		head 'Aborted|Req|Threshld'
col	ar		format	999		head 'Ab|Rq'
col	las		format  999999		head 'Last|Abort|Size'

SELECT	 free_space			fs
	,avg_free_size			afs
	,free_count			fc
	,max_free_size			mfs
	,used_space			us
	,avg_used_size			aus
	,used_count			uc
	,max_used_size			mus
	,requests			r
	,request_misses			rm
	,last_miss_size			lms
	,max_miss_size			mms
	,request_failures		f
	,last_failure_size		lfs
	,aborted_request_threshold	art
	,last_aborted_size		las
FROM	 v$shared_pool_reserved
;
