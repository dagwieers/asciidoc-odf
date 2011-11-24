#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, re

def main():
	line1 = True
	rs = re.compile('(  +)')
	for l in sys.stdin:
		if not line1:
			sys.stdout.write('<text:line-break/>')
		line1 = False
		ls = rs.split(l); ls.append('')
		for d,s in zip(*[iter(ls)]*2):
			sys.stdout.write(d.rstrip('\r\n'))
			if len(s) > 0:
				sys.stdout.write('<text:s text:c="%d"/>' % len(s) )
	return 0

if __name__ == '__main__':
	main()

