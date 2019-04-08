'''
Created on 28 Aug 2018

@author: marta
'''
import numpy as np
import matplotlib.pyplot as plt
import h5py
import os

# Loading the dataset
os.getcwd()
train_dataset = h5py.File('trainCats.h5', "r")
trainSetX = np.array(train_dataset["train_set_x"][:]) # your train set features
trainSetY = np.array(train_dataset["train_set_y"][:]) # your train set labels
trainSetY = trainSetY.reshape((1, trainSetY.shape[0]))

test_dataset = h5py.File('testC.h5', "r")
testSetX = np.array(test_dataset["test_set_x"][:]) # your test set features
testSetY = np.array(test_dataset["test_set_y"][:]) # your test set labels
testSetY = testSetY.reshape((1, testSetY.shape[0]))

classes = np.array(test_dataset["list_classes"][:]) # the list of classes

# Example of a picture
index = 20
plt.imshow(trainSetX[index])
plt.show()
print ("y = " + str(trainSetY[:, index]) + ", it's a '" + classes[np.squeeze(trainSetY[:, index])].decode("utf-8") +  "' picture.")

# Flatten the pictures
trainSetXF= trainSetX.reshape(trainSetX.shape[0], -1).T
testSetXF = testSetX.reshape(testSetX.shape[0], -1).T

# costValues array with the costs for each iteration
plt.plot(costValues)
plt.ylabel('Cost')
plt.xlabel('Iterations')
plt.show()