#!/bin/sh
set -x
# supervisor start
supervisord -c /etc/supervisor.d/default.ini
ps -ef
curl -v -k https://localhost
curl -k -v --resolve foo.io:443:127.0.0.1 https://foo.io
curl -k -v --resolve bar.io:443:127.0.0.1 https://bar.io
