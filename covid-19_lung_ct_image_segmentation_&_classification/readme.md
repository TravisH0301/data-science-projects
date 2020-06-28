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
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/vgg_vs_cnn1.png" width="600">
</p>

### Effect of image segmentation
By looking at the performances of the two models on both segmented images and raw images, the image segmentation allows smoother learning for both models reducing variance. And for the 3-layer CNN model, it has reached overfitting quicker with the segmented
images. However, the average validation accuracy for the segmented images is higher than the raw images. This is due to the reduction in image features during image segmentation. Additionally, a stright horizontal line for the validation accuracy of the VGG-16 model on the segmented images indicates that the model predicts the same classes for all iterations. This may be due to a lack of training or incorrect settings for weight initialisation or optimisation. 

### Comparison between deep and simple CNN models
The 3-layer CNN model on both types of images has reached overfitting during training. However, the VGG-16 model did not reach 
overfitting during training. This is likely due to gradient vanishing caused by its deeper architecture. Certainly 20 epochs are
not enough for the gradients to impact the first convolutions of the model. Hence, retraining of the VGG-16 model with increased epochs with the raw images is decided to enhance its learning.  

### VGG-16 with increased epochs
TBC
