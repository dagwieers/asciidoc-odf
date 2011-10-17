#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

def main():
	l = sys.stdin.readlines()
	sys.stdout.write('</text:p>\n<text:p  text:style-name="listingblock">'.join(l))
	return 0

if __name__ == '__main__':
	main()

