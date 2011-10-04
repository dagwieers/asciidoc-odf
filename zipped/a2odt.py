#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#       untitled.py
#       
#       Copyright 2011 Lex Trotman <elextr(at)gmail(dot)com>
#       
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are
#       met:
#       
#       * Redistributions of source code must retain the above copyright
#         notice, this list of conditions and the following disclaimer.
#       * Redistributions in binary form must reproduce the above
#         copyright notice, this list of conditions and the following disclaimer
#         in the documentation and/or other materials provided with the
#         distribution.
#       * Neither the name of the copyright holder nor the names of its
#         contributors may be used to endorse or promote products derived from
#         this software without specific prior written permission.
#       
#       THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#       "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#       LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#       A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#       OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#       SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#       LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#       DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#       THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#       OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#       

import tempfile, shutil, os, os.path, zipfile, subprocess

class tempdir:
	def __init__(self, in_dir=None, keep=False):
		self.dir = None
		self.in_dir = in_dir
		self.keep = keep
	def __enter__(self):
		self.dir = tempfile.mkdtemp(dir=self.in_dir)
		return self.dir
	def __exit__(self, et, ev, tb):
		if not self.keep and self.dir : shutil.rmtree(self.dir, True)
		
class odt_archive:
	def __init__(self, temp=None, keep=False):
		self.asciidoc = "asciidoc"
		self.temp = os.path.abspath(temp)
		self.keep = keep
		
	def make_archive(self, base_doc, doc, out_file):
		with tempdir(self.temp, self.keep) as td:
			bz = zipfile.ZipFile(base_doc)
			bz.extractall(td) # TODO for security limit to specific members only
			cx = os.path.join(td,"content.xml")
			if os.path.exists(cx) : os.remove(cx)
			subprocess.check_call([self.asciidoc, "--backend=odt12", "--out-file="+cx, doc])

			# TODO gather resources to td, eg images etc

			of = os.path.abspath(out_file)
			if os.path.exists(of) : os.remove(of)
			oz = zipfile.ZipFile(of, "w", zipfile.ZIP_DEFLATED)
			try:
				for path, dirs, files in os.walk(td):
					for f in files:
						#TODO remove thumbnails etc
						ff = os.path.normpath(os.path.join(path,f))
						oz.write(ff,os.path.relpath(ff,td))
			finally:
				oz.close()
	
def main():
	a = odt_archive("temp", True)
	a.make_archive("base.ott", "file.txt", "file.odt")
	return 0

if __name__ == '__main__':
	main()

