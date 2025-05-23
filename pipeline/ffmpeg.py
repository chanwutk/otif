import numpy
import os
import subprocess

class Ffmpeg(object):
	def __init__(self, fname, width, height):
		self.FNULL = open(os.devnull, 'w')
		self.width, self.height = width, height
		self.pipe = subprocess.Popen([
			'ffmpeg', '-hide_banner', '-loglevel', 'warning', '-threads', '2', '-nostdin',
			'-i', fname,
			'-vf', 'scale={}x{}'.format(width, height),
			'-c:v', 'rawvideo', '-pix_fmt', 'rgb24', '-f', 'rawvideo',
			'-',
		], stdout=subprocess.PIPE, stderr=self.FNULL)

	def read(self, n=1):
		buf = self.pipe.stdout.read(n*self.width*self.height*3)
		if not buf:
			return None
		return buf

	def read_im(self):
		buf = self.read()
		if buf is None:
			return None
		im = numpy.frombuffer(buf, dtype='uint8').reshape((self.height, self.width, 3))
		return im

	def close(self):
		self.pipe.wait()
		self.FNULL.close()
