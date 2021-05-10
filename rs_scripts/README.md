# Redshift Admin Scripts
Scripts objective is to help on tuning and troubleshooting.
If you are using psql, you can use `psql [option] -f <script.sql>` to run.

| Script                       | Purpose                                                                                   |
|------------------------------|-------------------------------------------------------------------------------------------|
| commit_stats.sql             | Shows information on consumption of cluster resources through COMMIT statements           |
| copy_performance.sql         | Shows longest running copy for past 7 days                                                |
| current_session_info.sql     | Query showing information about sessions with currently running queries                   |
| filter_used.sql              | Return filter applied to tables on scans. To aid on choosing sortkey                      |
| generate_calendar.sql        | Creates a calendar dimension table useful for star-schema joins                           |
| missing_table_stats.sql      | Query shows EXPLAIN plans which flagged "missing statistics" on the underlying tables     |
| perf_alert.sql               | Return top occurrences of alerts, join with table scans and SQL Text                      |
| table_alerts.sql             | Return top occurrences of table access related alerts                                     |
| predicate_columns.sql        | Return Information about Predicate Columns on tables                                      |
| queuing_queries.sql          | Query showing queries which are waiting on a WLM Query Slot                               |
| queue_resources_hourly.sql   | Returns hourly resources usage for WLM query queues                                       |
| running_queues.sql           | Returns queries running and queueing and resources consumed                               |
| table_info.sql               | Return Table storage information (size, skew, etc)                                        |
| table_inspector.sql          | Table Analysis based on content in [Analyzing Table Design](http://docs.aws.amazon.com/redshift/latest/dg/c_analyzing-table-design.html). Complements table_info.sql                                           |
| top_queries.sql              | Return the top 50 most time consuming statements in the last 7 days                       |
| top_queries_and_cursors.sql  | Return the top 50 most time consuming statements in the last 7 days - include cursor text |
| unscanned_table_summary.sql  | Summarizes storage consumed by unscanned tables                                           |
| wlm_apex.sql                 | Returns overall high water-mark for WLM query queues and time queuing last occurred       |
| wlm_apex_hourly.sql          | Returns hourly high water-mark for WLM query queues                                       |
| wlm_qmr_rule_candidates.sql  | Calculate candidates for new WLM Query Monitoring rules                                   |
| user_to_be_dropped_objs.sql  | Find objects owned by a user that cannot be dropped                                       |
| user_to_be_dropped_privs.sql | Find privileges granted to a user that cannot be dropped                                  |

# Redshift Admin Views
Views objective is to help with administration of Redshift.
All views assume you have a schema called admin.

| View | Purpose |
| ------------- | ------------- |
| v\_check\_data\_distribution.sql |   View to get data distribution across slices |
| v\_check\_transaction\_locks.sql | View to get information about the locks held by open transactions |
| v\_check\_wlm\_query\_time.sql | View to get  WLM Queue Wait Time , Execution Time and Total Time by Query for the past 7 Days |
| v\_check\_wlm\_query\_trend\_daily.sql | View to get  WLM Query Count, Queue Wait Time , Execution Time and Total Time by Day  |
| v\_check\_wlm\_query\_trend\_hourly.sql | View to get  WLM Query Count, Queue Wait Time , Execution Time and Total Time by Hour |
| v\_constraint\_dependency.sql |   View to get the the foreign key constraints between tables |
| v\_extended\_table\_info.sql| View to get extended table information for permanent database tables.
| v\_fragmentation\_info.sql| View to list all fragmented tables in the database
| v\_generate\_cancel\_query.sql | View to get cancel query |
| v\_generate\_database\_ddl.sql | View to get the DDL for a database |
| v\_generate\_group\_ddl.sql |   View to get the DDL for a group. |
| v\_generate\_schema\_ddl.sql |   View to get the DDL for schemas. |
| v\_generate\_tbl\_ddl.sql | View to get the DDL for a table.  This will contain the distkey, sortkey, constraints |
| v\_generate\_terminate\_session.sql | View to get pg\_terminate\_backend() statements |
| v\_generate\_udf\_ddl.sql | View to get the DDL for a UDF.
| v\_generate\_unload\_copy\_cmd.sql |   View to get that will generate unload and copy commands for an object.  After running |
|v\_generate\_user\_grant\_revoke\_ddl.sql| View to gengerate grant or revoke ddl for users and groups in the database|
| v\_generate\_user\_object\_permissions.sql |   View to get the DDL for a users permissions to tables and views. |
| v\_generate\_view\_ddl.sql |   View to get the DDL for a view. |
| v\_get\_blocking\_locks.sql | View to identify blocking locks as well as determine what/who is blocking a query |
| v\_get\_cluster\_restart\_ts.sql | View to get the datetime of when Redshift cluster was recently restarted |
| v\_get\_obj\_priv\_by\_user.sql |   View to get the table/views that a user has access to |
| v\_get\_schema\_priv\_by\_user.sql |   View to get the schema that a user has access to |
| v\_get\_tbl\_priv\_by\_user.sql |   View to get the tables that a user has access to |
| v\_get\_tbl\_reads\_and\_writes.sql | View to get operations performed per table for transactions ID or query ID |
| v\_get\_tbl\_scan\_frequency.sql |   View to get list of each permanent table's scan frequency |
| v\_get\_users\_in\_group.sql |   View to get all users in a group |
| v\_get\_vacuum\_details.sql | View to get vacuum details like table name, Schema Name, Deleted Rows , processing time |
| v\_get\_view\_priv\_by\_user.sql |   View to get the views that a user has access to |
| v\_my\_last\_query\_summary.sql | View that shows a formatted extract of SVL\_QUERY\_SUMMARY for the last query run in the session |
| v\_my\_last\_copy\_errors.sql | View to see any errors associated with a COPY command that was run in the session and had errors |
| v\_object\_dependency.sql |   View to merge the different dependency views together |
| v\_open\_session.sql |   View to monitor currently connected and disconnected sessions |
| v\_session\_leakage\_by\_cnt.sql |   View to monitor session leakage by remote host |
| v\_space\_used\_per\_tbl.sql |   View to get pull space used per table |
| v\_view\_dependency.sql |   View to get the names of the views that are dependent other tables/views |