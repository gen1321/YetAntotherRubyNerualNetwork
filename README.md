# Yet another Nerual Network With Ruby

Hey! this is nerual network is build for educational purposes. It easy to read and understand but it's kinda slow.

This Neraual network have very simple syntax

First of all you need to initialize Network

```
Net.new([80], 28 * 28, %w[0 1 2 3 4 5 6 7 8 9])
```

First argument is shape of hiden layers. each element of array is represents layer of network. [10] is one layer with 10 neurons, [10, 10] is 2 layer with 10 neurons each

Second argument is size of input layer. it should be equal to your input size.

thrid shape of output. if we want our network to classify digits we should pass %w[0 1 2 3 4 5 6 7 8 9]. when you call process it will return  something like ['1' => 0.2, '2' => 0.8 ..]

```
process([0,0,0,1,2,3,4])
```
takes array of digits that represents your input
and return hash of `'label' => probablity`

```
train(array_of_inputs, array_of_expected_results)
```
example `train([[0,0,0,1,2,3,4], [0,0,0,2,2,3,3]], [[0,1], [1,0]])`


## MNIST

in example folder you can find HelloWorld of Neraual Networks, OCR on handwriten digits with MNIST dataset.

with this implementation i managed to get around 60-70% of success. Dont forget to put dataset to examples folder
