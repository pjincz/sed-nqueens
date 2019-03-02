#!/bin/sed -f

# prepare
/^[0-9][0-9]*$/ !{
	s/.*/bad input/
	q
}
:rep_input
/[0-9]/ {
	s/[0-9]/x&/
	s/#*/&&&&&&&&&&/
	s/x0//
	s/x1/#/
	s/x2/##/
	s/x3/###/
	s/x4/####/
	s/x5/#####/
	s/x6/######/
	s/x7/#######/
	s/x8/########/
	s/x9/#########/
	b rep_input
}
h

:test_valid
g
# test no same line
s/\n/b\na/g
s/$/b\n/
/\(a[.Q]*b\).*\1/ b not_valid

s/#*b/c/
:rep_left
/a/ {
	s/\(.*\)c\(.*\)b/\1c\2\1y/
	s/\(.*\)c\([^a]*\)a/\1.c\2x\1/
	b rep_left
}
/\(x[.Q]*y\).*\1/ b not_valid

g
s/\n/b\na/g
s/$/b\n/
s/#*b/c/
:rep_right
/a/ {
	s/\(.*\)c\([^b]*\)b/\1c\2\1y/
	s/\(.*\)c\(.*\)a/\1.c\2x\1/
	b rep_right
}
/\(x[.Q]*y\).*\1/ b not_valid


# test if full filled
g
s/#\n/#|/
s/[.Q][.Q]*/#/g
s/\n//g
/^\(#*\)|\1/ b full_filled


:fill_new_line
g
s/\n.*//
s/^#/Q/
s/#/./g
H
b test_valid


:full_filled
g
s/#*\n//
s/^/\n/
p
# pop last line and continue
g
s/\n[.Q]*$//
h
b not_valid


:not_valid
g
# pop line if all tried
s/\(\n\.*Q\)*$//
# exit if done
/^#*$/ { s/.*//; q }
s/\(.*\)\Q./\1.Q/
h
b test_valid
