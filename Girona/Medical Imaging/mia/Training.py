# -*- coding: utf-8 -*-
"""
Created on Mon May 21 01:26:47 2018

@author: mohit
"""

import os
import SimpleITK as sitk
import numpy as np
import glob

directory = 'training-set/'
readingimage = directory + 'images/*.nii.gz'
readinglabels = directory + 'labels/*.nii.gz'
outputDir = 'training-set/output/'
outlabelDir = 'training-set/output/labels/'
outimageDir = 'training-set/output/images/'
if not os.path.exists(outputDir):
    os.makedirs(outputDir)
if not os.path.exists(outlabelDir):
    os.makedirs(outlabelDir)
if not os.path.exists(outimageDir):
    os.makedirs(outimageDir)

# Reading Fixed Image
fixedImage = sitk.ReadImage('training-set/images/1000.nii.gz')
n_fixed = sitk.GetArrayFromImage(fixedImage)


elastixImageFilter = sitk.ElastixImageFilter()
elastixImageFilter.SetFixedImage(fixedImage)
for atlasImage, atlasLabel in zip(glob.glob(readingimage), glob.glob(readinglabels)):
  elastixImageFilter.SetMovingImage(sitk.ReadImage(atlasImage))
  elastixImageFilter.Execute()
  resultImage = elastixImageFilter.GetResultImage()
  print atlasImage
  
  #Reading Labels
  resultLabels = np.zeros(n_fixed.shape, dtype=np.int8)
  resultLabels = sitk.GetImageFromArray(resultLabels)
  parameterMap = elastixImageFilter.GetTransformParameterMap()
  #parameterMap[0]["FinalBSplineInterpolationOrder"] = ['0']
  #parameterMap[1]["FinalBSplineInterpolationOrder"] = ['0']
  parameterMap[2]["FinalBSplineInterpolationOrder"] = ['0']
  resultLabels = sitk.Transformix(sitk.ReadImage(atlasLabel), parameterMap)
  
  #resultLabels = sitk.JoinSeries(resultLabels)
  head_l, tail_l = os.path.split(atlasLabel)
  head_i, tail_i = os.path.split(atlasImage)

     
  filename_label = outlabelDir + tail_l
  filename_image = outimageDir + tail_i
  sitk.WriteImage(resultLabels,filename_label)
  sitk.WriteImage(resultImage,filename_image)
  
  