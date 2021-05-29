{% set index_offset = 1 %}
[mysqld]
ndbcluster
ndb-connectstring={% for index in (range(index_offset, mysql.mgm.replicas + index_offset) | list) %}ndb_mgm_{{ index }};{% endfor %}

user=mysql
default_storage_engine=ndbcluster

[mysql_cluster]
ndb-connectstring={% for index in (range(index_offset, mysql.mgm.replicas + index_offset) | list) %}ndb_mgm_{{ index }};{% endfor %}
