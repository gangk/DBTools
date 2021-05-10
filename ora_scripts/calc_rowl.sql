@plusenv
set serveroutput on size 100000
set verify off

ACCEPT own PROMPT 'Enter value for owner (RETURN for ALL) > '
ACCEPT tab PROMPT 'Enter value for table name (RETURN for ALL) > '

DECLARE

colsize number DEFAULT 0;
avgrow number DEFAULT 0;
ind_avgrow number DEFAULT 0;

l_sql varchar2(2000);

UB1 CONSTANT number :=  1; /* Get from v$type_size for your platform */
UB4 CONSTANT number :=  4; /* Get from v$type_size for your platform */
SB2 CONSTANT number :=  2; /* Get from v$type_size for your platform */

CURSOR get_tabs IS SELECT owner,table_name,avg_row_len FROM all_tables 
		   WHERE table_name like UPPER('%&tab%')		   
                   AND OWNER NOT IN ('SYS','SYSTEM')
		   AND OWNER LIKE UPPER('%&own%') 		   
                   ORDER BY table_name;

CURSOR get_ind (p_tab_name all_indexes.table_name%TYPE
			,p_owner all_indexes.owner%TYPE) IS		
                SELECT * 		
                FROM all_indexes
		WHERE table_name = p_tab_name		
                AND owner = p_owner;

CURSOR get_ind_cols (p_index all_ind_columns.index_name%TYPE
			,p_tab_name all_ind_columns.table_name%TYPE
			,p_owner all_ind_columns.table_owner%TYPE) IS		
                SELECT ic.* , tc.avg_col_len
		FROM all_ind_columns ic, all_tab_columns tc
                WHERE ic.table_owner = tc.owner
                AND ic.table_name = tc.table_name
                AND ic.column_name = tc.column_name
                AND ic.table_name = p_tab_name		
                AND ic.table_owner = p_owner
		AND ic.index_name = p_index;

CURSOR get_cols (p_tab_name all_tables.table_name%TYPE
		,p_owner all_tab_columns.owner%TYPE) IS 		
                SELECT * 
                FROM all_tab_columns 
                WHERE table_name = p_tab_name		
                AND owner = p_owner;

BEGIN
FOR tab_rec IN get_tabs LOOP

-- Do the INDEXES First
FOR ind_rec IN get_ind(tab_rec.table_name,tab_rec.owner) LOOP  

   ind_avgrow := 0;

   FOR get_ind_col IN get_ind_cols (ind_rec.index_name
				   ,tab_rec.table_name,tab_rec.owner)   LOOP 
 
     IF get_ind_col.avg_col_len  IS NULL THEN

        -- Try and calculate the average row length using VSIZE 
        l_sql := 'select round(avg(nvl(vsize(' || get_ind_col.column_name ||
               '),0)))' || ' from ' || 
                   get_ind_col.index_owner||'.'||get_ind_col.table_name
                   || ' where rownum < 1000000';

        EXECUTE IMMEDIATE l_sql INTO colsize ;

      ELSE
    
        colsize := get_ind_col.avg_col_len;

      END IF;

     ind_avgrow := ind_avgrow + colsize;    

    END LOOP;

    dbms_output.put_line ('Index '||ind_rec.index_name
                            ||' Avg Row Size = '||CEIL(to_char(ind_avgrow)) );

END LOOP;

avgrow := UB1*3; /* row header */

IF tab_rec.avg_row_len IS NULL THEN

   -- Try and calculate the average row length using VSIZE 
   FOR get_col_rec IN get_cols (tab_rec.table_name,tab_rec.owner)   LOOP

     l_sql := 'select round(avg(nvl(vsize(' || get_col_rec.column_name ||
               '),0)))' || ' from ' || 
                   get_col_rec.owner||'.'||get_col_rec.table_name;

     EXECUTE IMMEDIATE l_sql INTO colsize;

--Uncomment this to display the column vsize
--dbms_output.put_line (' Column '||get_col_rec.column_name
--                              ||' Col Size = '||to_char(colsize));

        avgrow := avgrow + colsize + SB2;

   END LOOP; 

ELSE     

   avgrow := tab_rec.avg_row_len;

END IF;

   dbms_output.put_line ('Table '||tab_rec.table_name
                                ||' Avg Row Size = '||CEIL(to_char(avgrow)));

END LOOP;

END;
/

