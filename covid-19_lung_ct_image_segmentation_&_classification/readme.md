# COVID-19 Lung CT Image Segmentation & Classification
This notebook aims to build image classifiers to determine whether a paitient is tested positive or negative for COVID-19 based on lung CT scan images. In doing so, a VGG-16 model and a 3-layer CNN model are used for classification.

Prior to the classification, the images are firstly segmented using K-means Clustering to enhance classification performance. Then, VGG-16 model is implemented and is trained on the raw and segmented images. Additionally, a 3-layer CNN model is trained on the segmented images.

The effect of image segmentation on image classification is discussed based on the performance of the VGG-16 model on both raw and segmented images. And the performances of the VGG-16 model and the 3-layer CNN model are compared and discusses.

The dataset is sourced from 'COVID-19 Lung CT Scans' in Kaggle.
https://www.kaggle.com/luisblanche/covidct

## Image Segmentation
Lung CT scane images are segmented using k-means clustering. K value of 2 is used to make boundary of the lung more distinct in black and white colors. 

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/seg1.png" width="400">
</p>

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/seg2.png" width="400">
</p>

## Classification 

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/vgg vs simple.png" width="600">
</p>

### Effect of image segmentation
By looking at the performance of the VGG-16 model on both segmented images and raw images, the image segmentation allows smoother learning for models compared to the raw images. This is because image segmentation removes noises in images and helps the model to learn better with less noises. However, this can oversimplify the images resulting in loss of features.

### Comparison between deep and simple CNN models
The VGG-16 models shows stagnant training and testing accuracies between 0.52 and 0.55. In comparison, the 3-layer CNN model achieves higher accuracies. The 3-layer CNN model learns better yet it overfits after 2 epochs. This difference may be due to gradient vanishing in VGG-16 model arising from its deep architecture. This can be improved by simplifying the model structure or altering activation function and optimisation (gradient descent) process.

The deep structure of the VGG-16 model learns much more detailed features of the images than the simple 3-layer CNN model. And the fact that VGG-16 model cannot distinguish between COVID positive and negative scan images may imply that there are not distinct differences between positive and negative images. And it may be that simple features such as edges and lines work better than the detailed features in this case.

A use of pre-trained model could be tried in the future to examine if the feature maps learned from large datasets of other images could benefit the model to classify the CT scan images.
