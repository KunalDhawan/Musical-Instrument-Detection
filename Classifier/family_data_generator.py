import numpy as np
import scipy.io as spio
from sklearn.utils import shuffle
import cPickle

split_factor=0.8
mat = spio.loadmat('../data/familywise/data_x_1.mat')
x = mat['x']
mat = spio.loadmat('../data/familywise/data_y_1.mat')
y = mat['y']
n_samples = y.shape[0]
family_xtrain = np.zeros((int(round(n_samples*split_factor)), 8))
family_ytrain = np.zeros(((int(round(n_samples*split_factor))),1))
family_xtest = np.zeros((int(round(n_samples*(1-split_factor))), 8))
family_ytest = np.zeros((int(round(n_samples*(1-split_factor))),1))

mat = spio.loadmat('../data/string/data_x.mat')
string_x = mat['x']
mat = spio.loadmat('../data/string/data_y.mat')
string_y = mat['y']
string_samples = string_y.shape[0]
string_x, string_y, x[0:string_samples,:] = shuffle(string_x, string_y, x[0:string_samples,:])
x_train = string_x[:int(round(string_samples*split_factor)), :]
family_xtrain[0:int(round(string_samples*split_factor)), :] = x[:int(round(string_samples*split_factor)), :]
y_train = string_y[:int(round(string_samples*split_factor)), :]
family_ytrain[0:int(round(string_samples*split_factor)), :] = 0
x_test = string_x[int(round(string_samples*split_factor)):, :]
family_xtest[0:int(round(string_samples*(1-split_factor))), :] = x[int(round(string_samples*split_factor)):string_samples, :]
y_test = string_y[int(round(string_samples*split_factor)):, :]
family_ytest[0:int(round(string_samples*(1-split_factor))), :] = 0
data_pkl = open('../data/string/data.pkl','wb')
cPickle.dump([x_train, y_train, x_test, y_test], data_pkl, protocol=cPickle.HIGHEST_PROTOCOL)
data_pkl.close()

mat = spio.loadmat('../data/brass/data_x.mat')
brass_x = mat['x']
mat = spio.loadmat('../data/brass/data_y.mat')
brass_y = mat['y']
brass_samples = brass_y.shape[0]
brass_x, brass_y, x[string_samples:string_samples+brass_samples,:] = shuffle(brass_x, brass_y, x[string_samples:string_samples+brass_samples,:])
x_train = brass_x[:int(round(brass_samples*split_factor)), :]
family_xtrain[int(round(string_samples*split_factor)):int(round(string_samples*split_factor))+int(round(brass_samples*split_factor)),:] = x[string_samples:string_samples+int(round(brass_samples*split_factor)),:]
y_train = brass_y[:int(round(brass_samples*split_factor)), :]
family_ytrain[int(round(string_samples*split_factor)):int(round(string_samples*split_factor))+int(round(brass_samples*split_factor)),:] = 1
x_test = brass_x[int(round(brass_samples*split_factor)):, :]
family_xtest[int(round(string_samples*(1-split_factor))):int(round(string_samples*(1-split_factor)))+int(round(brass_samples*(1-split_factor))), :] = x[string_samples+int(round(brass_samples*split_factor)):string_samples+brass_samples,:]
y_test = brass_y[int(round(brass_samples*split_factor)):, :]
family_ytest[int(round(string_samples*(1-split_factor))):int(round(string_samples*(1-split_factor)))+int(round(brass_samples*(1-split_factor))), :] = 1
data_pkl = open('../data/brass/data.pkl','wb')
cPickle.dump([x_train, y_train, x_test, y_test], data_pkl, protocol=cPickle.HIGHEST_PROTOCOL)
data_pkl.close()

mat = spio.loadmat('../data/woodwind/data_x.mat')
woodwind_x = mat['x']
mat = spio.loadmat('../data/woodwind/data_y.mat')
woodwind_y = mat['y']
woodwind_samples = woodwind_y.shape[0]
woodwind_x, woodwind_y, x[string_samples+brass_samples:, :] = shuffle(woodwind_x, woodwind_y, x[string_samples+brass_samples:, :])
x_train = woodwind_x[:int(round(woodwind_samples*split_factor)), :]
family_xtrain[int(round(string_samples*split_factor))+int(round(brass_samples*split_factor)):,:] = x[string_samples+brass_samples:string_samples+brass_samples+int(round(woodwind_samples*split_factor)),:]
y_train = woodwind_y[:int(round(woodwind_samples*split_factor)), :]
family_ytrain[int(round(string_samples*split_factor))+int(round(brass_samples*split_factor)):,:] = 2
x_test = woodwind_x[int(round(woodwind_samples*split_factor)):, :]
family_xtest[int(round(string_samples*(1-split_factor)))+int(round(brass_samples*(1-split_factor))):,:] = x[string_samples+brass_samples+int(round(woodwind_samples*split_factor)):,:]
y_test = woodwind_y[int(round(woodwind_samples*split_factor)):, :]
family_ytest[int(round(string_samples*(1-split_factor)))+int(round(brass_samples*(1-split_factor))):,:] = 2
data_pkl = open('../data/woodwind/data.pkl','wb')
cPickle.dump([x_train, y_train, x_test, y_test], data_pkl, protocol=cPickle.HIGHEST_PROTOCOL)
data_pkl.close()

family_xtrain, family_ytrain = shuffle(family_xtrain, family_ytrain)
family_xtest, family_ytest = shuffle(family_xtest, family_ytest)

data_pkl = open('../data/familywise/data.pkl','wb')
cPickle.dump([family_xtrain, family_ytrain, family_xtest, family_ytest], data_pkl, protocol=cPickle.HIGHEST_PROTOCOL)
data_pkl.close()