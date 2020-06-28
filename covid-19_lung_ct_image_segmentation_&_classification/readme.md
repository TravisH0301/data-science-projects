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
By looking at the performance of the VGG-16 model on both segmented images and raw images, the image segmentation allows smoother 
learning for models compared to the raw images. This is because image segmentation removes noises in images and helps the model
to learn better with less noises. However, this can oversimplify the images resulting in loss of features and inability of the 
model to correctly learn the images. 

### Comparison between deep and simple CNN models
The VGG-16 models shows stagnant training with testing accuracies around 0.5. In comparison, the 3-layer CNN model
achieves higher accuracies. The 3-layer CNN model learns better yet it overfits after 2 epochs. This difference may be due to 
gradient vanishing in VGG-16 model arising from its deep architecture. This can be improved by simplifying the model structure 
or altering activation function and optimisation (gradient descent) process. 

On the other hand, due to VGG-16's deep architecture, 20 epochs may not be enough for gradients to impact on the first 
convolutions. Hence, VGG-16 model is trained again for larger epochs to reach overfitting to ensure model learns the datasets
adequately. 

### VGG-16 with increased epochs
TBC
