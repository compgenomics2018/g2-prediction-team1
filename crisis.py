import sys
import re


infile = sys.argv[1]

if not sys.argv[1]:
	print("usage: crisis.py <infile>")

pat = ".*(SRR[0-9]{7}).*"
ID = re.search(pat, sys.argv[1])
outfile = "gff3_final/" + str(ID.group(1)) + ".gff3"
scafname = ""
scafpat = "scaffold"
coordpat = "Sequence"
wherepat = ".*\[([0-9]*).([0-9]*)\].*"

with open(infile, "r") as nf:
	with open(outfile, "w") as of:
		for line in nf.readlines():
			line = line.strip()
			if re.search(scafpat, line):
				scafname = line
				#print(scafname)
			if re.search(coordpat, line):
				start, stop = re.match(wherepat, line).groups()
				#print(start, stop)
				of.write("{}\tAragorn\ttRNA\t{}\t{}\t.\t.\t.\t.\n".format(scafname, start, stop))