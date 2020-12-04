#!/usr/bin/env bash

if [[ ! -d 01_track ]]; then
	curl -LO https://www.informatik.uni-kiel.de/~mku/woorpje/files/track01.tar.gz
	tar -xvf track01.tar.gz
	rm track01.tar.gz
fi

if [[ ! -d 05_track ]]; then
        curl -LO https://www.informatik.uni-kiel.de/~mku/woorpje/files/track05.tar.gz
        tar -xvf track05.tar.gz
        rm track05.tar.gz
fi

if [[ $1 != "01" && $1 != "05" && $1 != "test" ]]; then
	echo "enter track"
	exit 1
fi

if [[ $2 == "" ]]; then
	echo "enter task number"
	exit 1
fi

grep "Equation" "$1_track/woorpje/$1_track_$2.eq" > tmp

res="\$ENTRY Go\\n{ (e.Rules) =\\n<Eq (e.Rules) <Sim ( )\\n"

while read -r line
do
	prefixed=${line#*Equation: }
	lhs=${prefixed%=*}
	rhs=${line#*= }
	if [[ $1 != "test" ]]; then
		echo $lhs >tmp2
		sed -e 's/\(.\)/\1 /g' <tmp2 >tmp3
		lhs2=$(sed -e 's/\([A-Z]\)/\1s/g' <tmp3)
		echo $rhs >tmp2
		sed -e 's/\(.\)/\1 /g' <tmp2 >tmp3
		rhs2=$(sed -e 's/\([A-Z]\)/\1s/g' <tmp3)
		rm tmp2 tmp3
		res="$res <Decode (<Conc ('$lhs2 =')\\n' ${rhs2::-1}' >)> \\n"
	else
		res="$res <Decode (<Conc ('$lhs =')\\n' ${rhs}' >)> \\n"
	fi
done < tmp
rm tmp

res="$res >>;\\n}\\n"

rm -r solutions/$1_track_$2
mkdir -p solutions/$1_track_$2

sed -e "s/\\\$ENTRY Go { (e.Rules) = <Eq (e.Rules) <Sim ( ) <Decode (<Conc ('As =') ' Cs'>)>>>;}/$res/g" <weqs_int_bench_task.ref >solutions/$1_track_$2/weqs_int_bench_$1_track_$2.ref

inref4p solutions/$1_track_$2/weqs_int_bench_$1_track_$2.ref || exit
scp4 weqs_int_bench_$1_track_$2.mst usertr1 >solutions/$1_track_$2/trace || exit
cgr54 solutions/$1_track_$2/result.ref || exit
