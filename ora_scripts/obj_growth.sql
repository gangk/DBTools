SELECT * FROM TABLE(dbms_space.object_growth_trend(upper('&owner'), upper('&name'), upper('&type')));
