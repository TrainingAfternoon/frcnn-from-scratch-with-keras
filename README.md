# Stamp Detecton FRCNN Model
CS3310 - Spring '23 - E-Plan Exam Project 2 Team

This repo was forked from [an existing one by kentaroy](https://github.com/kentaroy47/frcnn-from-scratch-with-keras). The original README is left intact after this section.


We largely used Kentaroy's originally implementation with only a few changes:
- The addition of sbatch training scripts to work with the SLURM scheduler on Rosie
    - `baseline-train.sh`
        - Sets up the training for our baseline stamp detection experiment
    - `boosted-train.sh`
        - Sets up the training for our boosted stamp detection experiment
    - `test.sh`
        - Evaluation script, causes the model to write its predictions on the testing set to the `results/` directory for manual evaluation
    - `train-rpn.sh`
        - Training script for the RPN separate from the classifier

Kentaroy's original README references a requirements.txt, but at least on the ROSIE cluster this requirements is not satisfiable because it relies on package versions which only work with a lower version of Python than that supported by Python3.7.6 (Python3.6). In order to get Python3.6 working on Rosie we used a conda environment which allows setting the language version. In that case, please use the `environment.yml`.

Please reference [these instructions](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file) for getting started with conda environments.
---

![image](https://github.com/kentaroy47/frcnn-from-scratch-with-keras/blob/master/images/85.png)
# What is this repo?
- **Simple faster-RCNN codes in Keras!**

- **RPN (region proposal layer) can be trained separately!**

- **Active support! :)**

- **MobileNetv1 & v2 support!**

- **VGG support!**

- added eval for pascal_voc :)

## Frameworks
Tested with Tensorflow==1.12.0 and Keras 2.2.4.

## Kaggle Notebook examples
* Global Wheat Detection

[train-faster-rcnn-using-keras](https://www.kaggle.com/kishor1210/train-faster-rcnn-using-keras)

Nice kernel by kishor1210

## Compared to the forked keras-frcnn..
1. mobilenetv1 and mobilenetv2 supported. Can also try Mobilenetv1_05,Mobilenetv1_25 for smaller nets on the Edge.
2. VGG19 support added.
3. RPN can be trained seperately.

## Pytorch object detectors
https://github.com/kentaroy47/ObjectDetection.Pytorch

Here are my object detection models in Pytorch.
The model is SSD and trains quite fast.

### trained model
vgg16

https://drive.google.com/file/d/1IgxPP0aI5pxyPHVSM2ZJjN1p9dtE4_64/view?usp=sharing

config.pickle:

https://drive.google.com/open?id=1BL_2ZgTf55vH2q1jvVz0hkhlWYgj-coa

# Running scripts..

## 1. clone the repo

``` 
git clone https://github.com/kentaroy47/frcnn-from-scratch-with-keras.git
cd frcnn-from-scratch-with-keras
```

Install requirements. make sure that you have Keras installed.
```
pip install -r requirements.txt
```

## 2. Download pretrained weights.
Using imagenet pretrained VGG16 weights will significantly speed up training.

Download and place it in the root directory.

You can choose other base models as well.

```
# place weights in pretrain dir.
mkdir pretrain & mv pretrain

# download models you would like to use.
# for VGG16
wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels.h5

# for mobilenetv1
wget https://github.com/fchollet/deep-learning-models/releases/download/v0.6/mobilenet_1_0_224_tf.h5

# for mobilenetv2
wget https://github.com/JonathanCMitchell/mobilenet_v2_keras/releases/download/v1.1/mobilenet_v2_weights_tf_dim_ordering_tf_kernels_1.0_224.h5

# for resnet 50
wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/resnet50_weights_tf_dim_ordering_tf_kernels.h5
```

Other tensorflow pretrained models are in bellow.

https://github.com/fchollet/deep-learning-models/releases/


## 3. lets train region proposal network first, rather than training the whole network.
Training the entire faster-rcnn is quite difficult, but RPN itself can be more handy!

You can see if the loss converges.. etc

Other network options are: resnet50, mobilenetv1, vgg19.

```
python train_rpn.py --network vgg -o simple -p /path/to/your/dataset/

Epoch 1/20
100/100 [==============================] - 57s 574ms/step - loss: 5.2831 - rpn_out_class_loss: 4.8526 - rpn_out_regress_loss: 0.4305 - val_loss: 4.2840 - val_rpn_out_class_loss: 3.8344 - val_rpn_out_regress_loss: 0.4496
Epoch 2/20
100/100 [==============================] - 51s 511ms/step - loss: 4.1171 - rpn_out_class_loss: 3.7523 - rpn_out_regress_loss: 0.3649 - val_loss: 4.5257 - val_rpn_out_class_loss: 4.1379 - val_rpn_out_regress_loss: 0.3877
Epoch 3/20
100/100 [==============================] - 49s 493ms/step - loss: 3.4928 - rpn_out_class_loss: 3.1787 - rpn_out_regress_loss: 0.3142 - val_loss: 2.9241 - val_rpn_out_class_loss: 2.5502 - val_rpn_out_regress_loss: 0.3739
Epoch 4/20
 80/100 [=======================>......] - ETA: 9s - loss: 2.8467 - rpn_out_class_loss: 2.5729 - rpn_out_regress_loss: 0.2738  

```

## 4. then train the whole Faster-RCNN network!
I recommend using the pretrained RPN model, which will stablize training.
You can download the rpn model (VGG16) from here:
https://drive.google.com/file/d/1IgxPP0aI5pxyPHVSM2ZJjN1p9dtE4_64/view?usp=sharing

```
# sample command
python train_frcnn.py --network vgg -o simple -p /path/to/your/dataset/

# using the rpn trained in step.3 will make the training more stable.
python train_frcnn.py --network vgg -o simple -p /path/to/your/dataset/ --rpn models/rpn/rpn.vgg.weights.36-1.42.hdf5

# sample command to train PASCAL_VOC dataset:
python train_frcnn.py -p ../VOCdevkit/ --lr 1e-4 --opt SGD --network vgg --elen 1000 --num_epoch 100 --hf 
# this may take about 12 hours with GPU..

# add --load yourmodelpath if you want to resume training.
python train_frcnn.py --network vgg16 -o simple -p /path/to/your/dataset/ --load model_frcnn.hdf5

Using TensorFlow backend.
Parsing annotation files
Training images per class:
{'Car': 1357, 'Cyclist': 182, 'Pedestrian': 5, 'bg': 0}
Num classes (including bg) = 4
Config has been written to config.pickle, and can be loaded when testing to ensure correct results
Num train samples 401
Num val samples 88
loading weights from ./pretrain/mobilenet_1_0_224_tf.h5
loading previous rpn model..
no previous model was loaded
Starting training
Epoch 1/200
100/100 [==============================] - 150s 2s/step - rpn_cls: 4.5333 - rpn_regr: 0.4783 - detector_cls: 1.2654 - detector_regr: 0.1691  
Mean number of bounding boxes from RPN overlapping ground truth boxes: 1.74
Classifier accuracy for bounding boxes from RPN: 0.935625
Loss RPN classifier: 4.244322432279587
Loss RPN regression: 0.4736669697239995
Loss Detector classifier: 1.1491613787412644
Loss Detector regression: 0.20629869312047958
Elapsed time: 150.15273475646973
Total loss decreased from inf to 6.07344947386533, saving weights
Epoch 2/200
Average number of overlapping bounding boxes from RPN = 1.74 for 100 previous iterations
 38/100 [==========>...................] - ETA: 1:24 - rpn_cls: 3.2813 - rpn_regr: 0.4576 - detector_cls: 0.8776 - detector_regr: 0.1826

```

## 5. test your models
For evaluation and getting mAP, please take a look at `eval.ipynb`


## Bad training results?
See [issue #6](https://github.com/kentaroy47/frcnn-from-scratch-with-keras/issues/6) and look for help.

# Dataset setup.
You can either try voc or simple parsers for your dataset.

simple parsers are much easier, while you train your network as:

```
python train_rpn.py --network vgg16 -o simple -p ./dataset.txt
```

Simply provide a text file, with each line containing:
```
filepath,x1,y1,x2,y2,class_name
```
For example:
```dataset.txt
/data/imgs/img_001.jpg,837,346,981,456,cow 
/data/imgs/img_002.jpg,215,312,279,391,cat
```

## Labeling tools.
You can do labeling with tools. I highly recommend Labelme, which is easy to use.

https://github.com/wkentaro/labelme

you can directly output VOC-like dataset from your labeled results.

look at the example below.

https://github.com/kentaroy47/labelme-voc-format/tree/master/examples

There are other tools like Labellmg too, if interested.

https://github.com/tzutalin/labelImg

# Example.. to set up VOC2007 training..
download dataset and extract.

```
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
tar -xf VOCtrainval_06-Nov-2007.tar
tar -xf VOCtest_06-Nov-2007.tar
tar -xf VOCtrainval_11-May-2012.tar
```

then run training

```
python train_frcnn.py --network mobilenetv1 -p ./VOCdevkit

Using TensorFlow backend.
data path: ['VOCdevkit/VOC2007']
Parsing annotation files
[Errno 2] No such file or directory: 'VOCdevkit/VOC2007/ImageSets/Main/test.txt'
Training images per class:
{'aeroplane': 331,
 'bg': 0,
 'bicycle': 418,
 'bird': 599,
 'boat': 398,
 'bottle': 634,
 'bus': 272,
 'car': 1644,
 'cat': 389,
 'chair': 1432,
 'cow': 356,
 'diningtable': 310,
 'dog': 538,
 'horse': 406,
 'motorbike': 390,
 'person': 5447,
 'pottedplant': 625,
 'sheep': 353,
 'sofa': 425,
 'train': 328,
 'tvmonitor': 367}
Num classes (including bg) = 21
Config has been written to config.pickle, and can be loaded when testing to ensure correct results
Num train samples 5011
Num val samples 0
Instructions for updating:
Colocations handled automatically by placer.
loading weights from ./pretrain/mobilenet_1_0_224_tf.h5
loading previous rpn model..
no previous model was loaded
Starting training
Epoch 1/200
Instructions for updating:
Use tf.cast instead.
  23/1000 [..............................] - ETA: 43:30 - rpn_cls: 7.3691 - rpn_regr: 0.1865 - detector_cls: 3.0206 - detector_regr: 0.3050 
```



