# Prints the icybox disk usage.

run_segment() {
	df -h | awk '/\/media\/icybox/ {print $4}'
	return 0
}
