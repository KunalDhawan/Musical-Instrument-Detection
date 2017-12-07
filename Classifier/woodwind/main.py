from __future__ import print_function
import keras
from keras.models import Sequential
from keras.layers import Activation, Dense, Dropout
import cPickle
import numpy as np

f = open('../../data/woodwind/data.pkl','rb')
[x_train,y_train,x_test,y_test] = cPickle.load(f)
f.close()
print(x_train.shape,  y_train.shape, x_test.shape, y_test.shape)

batch_size = y_train.shape[0]
num_classes = 4
epochs = 150
means = np.nanmean(x_train, 0)
for j in range(x_train.shape[1]):
	for i in range(x_train.shape[0]):
		if(np.isnan(x_train[i][j])==True): 
			x_train[i][j]=means[j]
for j in range(x_test.shape[1]):
	for i in range(x_test.shape[0]):
		if(np.isnan(x_test[i][j])==True): 
			x_test[i][j]=means[j]

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
mean = np.mean(x_train, 0)
sd = np.std(x_train,0)
x_train = (x_train - mean)/sd
x_test = (x_test - mean)/sd

print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

model = Sequential()
model.add(Dense(1024, input_shape=(x_train.shape[1],)))
model.add(Activation('relu'))
model.add(Dropout(0.8))
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(1024, activation='relu'))
model.add(Dropout(0.5))

model.add(Dense(num_classes, activation='softmax'))

opt = keras.optimizers.adam(lr=0.001, beta_1=0.9, beta_2=0.999,epsilon=1e-8)
model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1)#,
                    #validation_data=(x_test, y_test))

model.save_weights("temp.h5")
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:'+ str(score[0]))
print('Test accuracy:'+ str(score[1]))
