# print the pid of gunicorn

run_segment() {
	# create a couple /tmp files
	local tmp_file_pid="${TMUX_POWERLINE_DIR_TEMPORARY}/gunicorn-ogreserver-pid.txt"
	local tmp_file_hups="${TMUX_POWERLINE_DIR_TEMPORARY}/gunicorn-ogreserver-hups.txt"

	# print the current gunicorn pid
	PID=$(pgrep -d "," -P $(cat /tmp/gunicorn-ogreserver.pid))
	if [ ! -f $tmp_file_pid ]; then
		echo $PID > $tmp_file_pid
	fi

	# track total HUP count
	HUP_COUNT=$(cat /var/log/ogreserver/gunicorn.log |grep "Handling signal: hup" |wc -l)
	if [ ! -f $tmp_file_hups ]; then
		echo $HUP_COUNT > $tmp_file_hups

	# display asterisk on HUP
	elif [ $HUP_COUNT -gt $(cat $tmp_file_hups) ]; then
		echo "$PID*"
	else
		echo $PID
	fi

	# if pid has changed, update /tmp files
	if [ "$PID" != "$(cat $tmp_file_pid)" ]; then
		echo $HUP_COUNT > $tmp_file_hups
		echo $PID > $tmp_file_pid
	fi

	return 0
}
