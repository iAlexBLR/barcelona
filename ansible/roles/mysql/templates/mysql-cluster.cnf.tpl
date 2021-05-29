# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

[ndbd default]
NoOfReplicas={{ mysql.node.replicas }}
DataMemory=80M
IndexMemory=18M

# Configuring mgm servers location.
{% set index_offset = 1 %}
{% for index in (range(1, mysql.mgm.replicas + 1) | list) %}

[ndb_mgmd]
NodeId={{ index_offset + index }}
hostname=ndb_mgm_{{ index }}
datadir=/var/lib/mysql
{% endfor %}

# Configuring ndbd servers location.
{% set index_offset = index_offset + mysql.mgm.replicas %}
{% for index in (range(1, mysql.node.replicas + 1) | list) %}

[ndbd]
NodeId={{ index_offset + index }}
hostname=ndb_{{ index }}
datadir=/var/lib/mysql
{% endfor %}

# Configuring mysqld servers location.
{% set index_offset = index_offset + mysql.node.replicas %}
{% for index in (range(1, mysql.server.replicas + 1) | list) %}

[mysqld]
NodeId={{ index_offset + index }}
hostname=server_{{ index }}
{% endfor %}
