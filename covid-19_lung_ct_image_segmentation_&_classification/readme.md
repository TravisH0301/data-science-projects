# COVID-19 Lung CT Image Segmentation & Classification
This notebook aims to build image classifiers to determine whether a paitient is tested positive or negative for COVID-19 based on lung CT scan images. In doing so, a VGG-16 model and a 3-layer CNN model are used for classification.

Prior to the classification, the images are firstly segmented using K-means Clustering to enhance classification performance. Then, the VGG-16 model and the 3-layer CNN model are implemented on the raw and segmented images. The effect of the image segmentation is discusses and two models are compared. To improve the performance of the VGG-16 model, various tuning methods including increasing epochs, changing optimiser and reducing learning rate are performed and evaluated. In addition, pre-trained weights of the VGG-16 model are implemented to enhance the model. 

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

## Classification using VGG-16 & 3-layer CNN

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/vgg_vs_cnn1.png" width="600">
</p>

### Effect of image segmentation
By looking at the performances of the two models on both segmented images and raw images, the image segmentation allows smoother learning for both models reducing variance. And for the 3-layer CNN model, it has reached overfitting quicker with the segmented
images. However, the average validation accuracy for the segmented images is higher than the raw images. This is due to the reduction in image features during image segmentation. Additionally, a stright horizontal line for the validation accuracy of the VGG-16 model on the segmented images indicates that the model predicts the same classes for all iterations. This may be due to a lack of training or incorrect settings for weight initialisation or optimisation. 

### Comparison between deep and simple CNN models
The 3-layer CNN model on both types of images has reached overfitting during training. However, the VGG-16 model did not reach 
overfitting during training. This is likely due to gradient vanishing caused by its deeper architecture. Certainly 20 epochs are
not enough for the gradients to impact the first convolutions of the model. 

Hence, additional epochs and different hyper-parameters are given to the VGG-16 model to enhance its learning. 


### VGG-16 tuning

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/vgg1.png" width="600">
</p>

VGG-16 model is tuned by increasing epochs, chaning optimiser and reducing learning rate. Purely increasing epochs to 200 did not show any effect on the model's learning. The oscillation in both loss and accuracy indicates that the model still cannot learn the image feauters. Thus, different approaches are used. Chaning the optimiser from ADAM to SDG and reducing the learning rate showed enhancement in the model's learning implied by the continuously decreasing training and testing loss. However, the reduction rate is marginal so that the accuracy is still fluctuating. Considering the size of the available dataset with about 600 images, training a deep architectural neural network such as VGG-16 may be limited. Thus, pre-trained VGG-16 model is loaded to benefit from the pre-trained weights and to examine its ability in learning the image features.

### Pre-trained VGG-16

<p align="center">
<img src="https://github.com/TravisH0301/data_science_projects/blob/master/covid-19_lung_ct_image_segmentation_%26_classification/images/vgg2.png" width="600">
</p>

Implementing the pre-trained VGG-16 model significantly improved the learning ability of the model. It reaches overfitting at around 25 epochs and its accuracy ranges between 0.7 to 0.8. This is because the pre-trained model has weights that are already trained on large set of images. Only the last two convolutional layers of the model are trained in order to learn the features of the lung CT scan images. By using the pre-trained weights, the model overcame the limitation of its deep architecture and the small datasets. 

In comparison to the 3-layer CNN model, the testing accuracies are similar ranging between 0.7 and 0.8. This may be due to the limitation of the learnable features from the small datasets. Hence, using a simple model may be a good decision in this case for the sake of computation time and resources. For future application, increasing dataset size by data augmentation can be looked into to fully achieve the potential of the deep architectural neural networks. 
