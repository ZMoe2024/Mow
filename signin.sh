cookie_total=$1

line_count=$(echo -e "$cookie_total" | wc -l)
for ((i=0; i<$line_count; i++)); do
	array[$i]=0
done
  
function signinApi(){
	local got_cookie=$1
	local index=$2
	url1="https://glados.rocks/api/user/checkin"
	url2="https://glados.rocks/api/user/status"
	referer="https://glados.rocks/console/checkin"
	origin="https://glados.rocks"
	useragent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
	payload='{"token": "glados.one"}'

	status=$(curl --connect-timeout 60 -X POST "$url1" -H "cookie: $got_cookie" -H "referer: $referer" -H "origin: $origin" -H "user-agent: $useragent" -H "content-type: application/json;charset=UTF-8" -d "$payload")

	echo -e "$status\n\n"
	curl --connect-timeout 60 "$url2" -H "cookie: $got_cookie" -H "referer: $referer" -H "origin: $origin" -H "user-agent: $useragent"

	# 判断status变量中的points键值是否为数字
	var=$(echo "${status//\"/}" | sed "s/.*points:\([^,}]*\).*/\1/")
	if [[ $var =~ ^[0-9]+$ ]]; then
		echo "points变量是数字，签到成功"
	else
		echo "points变量不是数字，签到失败"
	fi
}
  
IFS=$'\n' read -rd '' -a lines <<< "$cookie_total"

# 循环调用签到函数
for line in "${lines[@]}"; do
	signinApi "$line"
done

