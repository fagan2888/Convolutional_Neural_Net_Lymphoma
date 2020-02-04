import sys
import os
import numpy as np
import matplotlib.pyplot as plt
import OpenVisus as ov

class WriteZOrder:
	def __init__(self, image=None, X=None, Y=None):
		self.image = image
		self.width = X
		self.height = Y
	
	"""
	Example of data conversion
	
	Input is composed of 3 images, one for each channel (RGB)
	each channel it's a 3d array
	
	Ouput is an IDX
	
	For each source slice the original data is shifted by 5 pixels:
		first  slice is shifted by ( 0,0)
		second slice is shifted by ( 5,0)
		third  slice is shifted by (10,0)	
	
	"""
	def convert_image(self, image=None, idx_filename='visus.idx'):
		self.image = image if image is not None else self.image

		ov.SetCommandLine("__main__")
		ov.DbModule.attach()

		# trick to speed up the conversion
		os.environ["VISUS_DISABLE_WRITE_LOCK"]="1"

		# numpy display is Z,Y,X
		print("image shape ", self.image.shape)

		height, width, depth = self.image.shape[0], self.image.shape[1], self.image.shape[2]
		img = np.transpose(self.image, (2,0,1))#np.zeros((depth, height, width), dtype=np.uint8)
		if not (img.shape[0] == depth and img.shape[1] == height and img.shape[2] == width):
			raise Exception("Assert failed")

		idx_name = idx_filename
		print("image", idx_name, "has dimensions", width, height, depth)

		# to disable offset just set this to 0
		offset_x = 0

		# numpy dtype -> OpenVisus dtype
		typestr = img.__array_interface__["typestr"]
		dtype = ov.DType(typestr[1] == "u", typestr[1] == "f", int(typestr[2]) * 8)

		dims = ov.PointNi(int(width + offset_x * depth), int(height),  int(depth))

		idx_file = ov.IdxFile()
		idx_file.logic_box = ov.BoxNi(ov.PointNi(0, 0, 0), dims)
		idx_file.fields.push_back(ov.Field('channel0', dtype))
		idx_file.save(idx_name)

		print("Created IDX file")

		dataset = ov.LoadDataset(idx_name)
		access = dataset.createAccess()
		if not dataset:
			raise Exception("Assert failed")

		for Z in range(0, depth):

			print("Processing slice %d" % Z)
			data = img[Z,:, :]

			slice_box = dataset.getLogicBox().getZSlab(Z, Z + 1)
			if not (slice_box.size()[0] == dims[0] and slice_box.size()[1] == dims[1]):
				raise Exception("Assert failed")

			query = ov.BoxQuery(dataset, dataset.getDefaultField(), dataset.getDefaultTime(), ord('w'))
			query.logic_box = slice_box
			dataset.beginQuery(query)
			if not query.isRunning():
				raise Exception("Assert failed")

			buffer = ov.Array(query.getNumberOfSamples(), query.field.dtype)

			buffer.fillWithValue(0)

			fill = ov.Array.toNumPy(buffer, bSqueeze=True, bShareMem=True)
			y1 = 0
			y2 = height
			x1 = offset_x * Z
			x2 = x1 + width
			fill[y1:y2, x1:x2] = data

			query.buffer = buffer
			if not (dataset.executeQuery(access, query)):
				raise Exception("Assert failed")


		ov.DbModule.detach()
		print("Done with conversion")

# enable/disable these two lines after debugging
# ArrayUtils.saveImageUINT8("tmp/slice%d.orig.png" % (Z,),Array.fromNumPy(data))
# ArrayUtils.saveImageUINT8("tmp/slice%d.offset.png" % (Z,),Array.fromNumPy(fill))
# function to plot the image data with matplotlib
# optional parameters: colormap, existing plot to reuse (for more interactivity)
class ShowData:
	def __init__(self, data, resolution = None, load=True, cmap=None, plot=None, print_attr=None):
		self.showData(data=data, resolution=resolution, load=load, cmap=cmap, plot=plot, print_attr = print_attr)

	def showData(self, data,  resolution, load=False, cmap=None, plot=None, print_attr=None):
		ov.DbModule.attach()
		if load:
			dataset = ov.LoadDataset(data)
			#world_dataset = ov.LoadDataset("http://atlantis.sci.utah.edu/mod_visus?dataset=BlueMarble")

			access = dataset.createAccess()
			if not dataset:
				raise Exception("Assert failed")
			if print_attr is not None:
				print( "size ", dataset.getLogicBox().toString())
				print("loaded dtype: ",dataset.getDefaultField().dtype.toString())
				print( "max resolution: " , dataset.getMaxResolution())
			# define a box query to fetch data from a certain dataset, field and timestep
			query=ov.BoxQuery(dataset, dataset.getDefaultField(), dataset.getDefaultTime(), ord('r'))
			logic_box = dataset.getLogicBox()
			# set the bounding box for our query
			query.logic_box=logic_box
			# set the resolution
			resolution = resolution if resolution is not None else dataset.getMaxResolution()
			query.end_resolutions.push_back(resolution)
			# prepare and execute the query
			dataset.beginQuery(query)
			dataset.executeQuery(access,query)
			# transform the result of the query to a numpy array
			data = ov.Array.toNumPy(query.buffer, bSqueeze=True, bShareMem=False)
			if data.shape[0]<=3:
				data = np.transpose(data,(1,2,0))
			#why does it loose a dimention 3 color channel for small values
			# one color channel for 22
			# color changes for lower res

		#
		if (plot == None or cmap != None):
			fig = plt.figure(figsize=(7, 7))
			plot = plt.imshow(data, origin='lower', cmap=cmap)
			plt.show()
			return plot
		else:
			plot.set_data(data)
			plt.show()
			return plot

		ov.DbModule.detach()