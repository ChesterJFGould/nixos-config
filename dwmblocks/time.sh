#! /bin/sh

Time() {
	number -l "$(date +%I)"
	echo ' '
	proper_minutes
	echo ' '
	date +%P
}

proper_minutes() {
	minutes=$(date +%M)
	if [ $minutes -eq 0 ]; then
		echo "o'clock"
	elif [ $minutes -lt 10 ]; then
		echo "oh "
		echo $minutes | number -l
	else
		echo $minutes | number -l
	fi
}

case $BLOCK_BUTTON in
	1) date;;
	*) Time | tr -d '\n';;
esac

