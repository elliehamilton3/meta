echo "----- Cloning Repo's -----";

while read -r repo
do
    echo "Cloning $repo"
    git clone git@github.com:elliehamilton3/"$repo".git
done < repos
