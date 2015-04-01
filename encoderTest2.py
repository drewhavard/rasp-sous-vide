import gaugette.rotary_encoder
import gaugette.switch
import Tkinter as tk
import os.path, time;
from Tkinter import *
from PIL import Image, ImageTk as itk

class sousVide:
	def __init__(self):
		print "made it this far1"
		self.root = tk.Tk()
		self.root.attributes("-fullscreen", True)
		#w, h = self.root.winfo_screenwidth(), self.root.winfo_screenheight()
		#self.root.overrideredirect(1)
		#self.root.geometry("%dx%d+0+0" % (w, h))
		#self.root.focus_set()
		self.root.bind("<Escape>", self.toggle_geom)
		self.A_PIN1  = 5
		self.B_PIN1  = 4
		self.SW_PIN1 = 6	
		self.A_PIN2	= 2
		self.B_PIN2	= 3
		self.SW_PIN2 = 15
		self.minuteGraphPath = '/var/www/temp_minute.png'
		self.minute15GraphPath = '/var/www/temp_15minute.png'
		 
		self.encoder1 = gaugette.rotary_encoder.RotaryEncoder.Worker(self.A_PIN1, self.B_PIN1)
		self.encoder1.start()
		self.switch1 = gaugette.switch.Switch(self.SW_PIN1)
		self.encoder2 = gaugette.rotary_encoder.RotaryEncoder.Worker(self.A_PIN2, self.B_PIN2)
		self.encoder2.start()
		self.switch2 = gaugette.switch.Switch(self.SW_PIN2)
		self.last_state1 = None
		self.last_state2 = None
		
		self.timer = 0
		self.timerLabel = tk.Label(text='Timer - ' + str(self.timer/60) + ':' + str(self.timer%60).zfill(2))
		self.timerLabel.pack()
		self.timerLastUpdated = time.ctime() 
		self.temperature = 72.0
		self.temperatureLabel = tk.Label(text='Temperature - ' + str(self.temperature))
		self.temperatureLabel.pack()
		self.temperatureLastUpdated = time.ctime()
		self.photoMin = itk.PhotoImage(Image.open(self.minuteGraphPath))
		self.photoMinLabel = tk.Label(self.root, image=self.photoMin)
		self.photoMinLabel.image = self.photoMin
		self.photoMinLabel.pack()
		self.photo15Min = itk.PhotoImage(Image.open(self.minute15GraphPath))
		self.photo15MinLabel = tk.Label(self.root, image=self.photo15Min)
		self.photo15MinLabel.image = self.photo15Min
		self.photo15MinLabel.pack()
		task(self)
		print "made it this far2"
		self.root.mainloop()
	def toggle_geom(self,event):
        	self.root.attributes("-fullscreen", False)
		#geom=self.master.winfo_geometry()
        	#print(geom,self._geom)
        	#self.master.geometry(self._geom)
        	#self._geom=geom
 

def task(self):
	self.delta1 = self.encoder1.get_delta()
	if self.delta1!=0:
		print "rotate1 %d" % self.delta1
		self.timer = self.timer + self.delta1*15
		if self.timer<0:
			self.timer = 0
		self.timerLabel.configure(text='Timer - ' + str(self.timer/60) + ':' + str(self.timer%60).zfill(2))
		self.timerLastUpdated = time.ctime()
	self.delta2 = self.encoder2.get_delta()
	if self.delta2!=0:
		print "rotate2 %d" % self.delta2
		self.temperature = self.temperature + float(self.delta2)/4
		self.temperatureLabel.configure(text="Temperature - " + str(self.temperature))
		self.temperatureLastUpdated = time.ctime();
	self.sw_state1 = self.switch1.get_state()
	if self.sw_state1 != self.last_state1:
		print "switch1 %d" % self.sw_state1
		self.last_state1 = self.sw_state1
		self.timer = 0
		self.timerLabel.configure(text='Timer - ' + str(self.timer/60) + ':' + str(self.timer%60).zfill(2))
		self.timerLastUpdated = time.ctime();
	self.sw_state2 = self.switch2.get_state()
	if self.sw_state2 != self.last_state2:
		print "switch2 %d" % self.sw_state2
		self.last_state2 = self.sw_state2
		self.temperature = 72
		self.temperatureLabel.configure(text="Temperature - " + str(self.temperature))
		self.temperatureLastUpdated = time.ctime()
	updateGraphs(self)
	updateTargetTemp(self)
	self.root.after(1, task, self)
def updateGraphs(self):
	try:
		self.photoMin = itk.PhotoImage(Image.open(self.minuteGraphPath))
		self.photoMinLabel.configure(image=self.photoMin)
		self.photo15Min = itk.PhotoImage(Image.open(self.minute15GraphPath))
		self.photo15MinLabel.configure(image=self.photo15Min)
	except:
		print "Some error encountered\n"
def updateTargetTemp(self):
	with open('targettemp.txt', 'r') as f:
		lastModifiedFile = time.ctime(os.path.getmtime('targettemp.txt'))
		#print "File last modified: " + str(lastModifiedFile)
		content = f.readline().strip()
		#print "File temp is " + content + "\n"
		if float(content) != float(self.temperature) and lastModifiedFile <= self.temperatureLastUpdated:
			f2 = open('targettemp.txt', 'w')
			try:
				f2.write(str(self.temperature)+"\n")
			finally:
				f2.close()
			lastModifiedFile = time.ctime(os.path.getmtime('targettemp.txt'))
			self.temperatureLastUpdated = lastModifiedFile
		elif lastModifiedFile > self.temperatureLastUpdated:
			print "File newer than local version\n"
			print lastModifiedFile + self.temperatureLastUpdated
			self.temperature = float(content)
			self.temperatureLabel.configure(text="Temperature - " + str(self.temperature))
	                self.temperatureLastUpdated = lastModifiedFile

			
mySousVide = sousVide()
