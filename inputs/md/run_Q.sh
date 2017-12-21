#Script for submit Q calculations on a local PC
#Usage    sub_Q Q_option (qdyn or qdum) work_type (eq and/or md)
#!/bin/csh
if ($#argv < 2) then
   echo wrong number of arguments $#argv\; expected at least "2"
   echo 'Usage    sub_Q Q_option (qdyn or qdum) work_type(eq and/or md)'
   exit
else
set wd = `pwd`
set qpath = /home/ander/Q
echo $1
if ($1 == qdyn) then
	set Qdyn = $qpath/Qdyn5
#elseif ($1 == qdum) then
#	set Qdyn = $qpath/Qdum5
else echo "You must specify at leat one Q_option (qdyn or qdum)"
exit
endif
cat <<EOF> run.sh 
#!/bin/csh -f
#PBS -e $wd/error.e
#PBS -o $wd/error.o
#PBS -q md
cd $wd
EOF
if ($2 == eq) then
	foreach name (`ls eq*.inp`)
		set realname = `echo $name | sed 's/.inp//'` 
		echo "$Qdyn $name > "$realname".log" >>run.sh 
	end
endif
if ($2 == md || $3 == md) then
	foreach name (`ls md*.inp`)
		set realname = `echo $name | sed 's/.inp//'` 
		echo "$Qdyn $name > "$realname".log" >>run.sh 
	end
endif
tcsh run.sh
