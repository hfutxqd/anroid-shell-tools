#/bin/bash
f="%H %s"

if [ ! "$1" ]; then
	echo "Need a release name."
	exit
fi

if [ ! -d "changelog" ]; then
  mkdir changelog
fi

if [ ! -f "changelog/last_release" ]; then
  touch "changelog/last_release"
fi

name=$1
last=$(tail -n 1 changelog/last_release)
last_commit=$(echo $last|egrep "\S{40}" -o)
last_name=${last:41}
if [ "$last_commit" ]; then
	echo "Last release commit is $last"
	git log $last_commit..HEAD --pretty=format:"$f" >> changelog/"$last_name""_to_""$name"
else
	git log --pretty=format:"$f" >> changelog/$name
	echo -e "\r\n" >> "changelog/$name
fi
commit=$(git log --pretty=format:"%H"|head -n 1)
echo "$commit $name" >> changelog/last_release