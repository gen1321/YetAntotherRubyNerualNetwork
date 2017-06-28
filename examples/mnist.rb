require_relative '../net'
require 'zlib'

mnist_images_file = 'train-images-idx3-ubyte.gz'
mnist_labels_file = 'train-labels-idx1-ubyte.gz'

unless File.exist?(mnist_images_file) && File.exist?(mnist_labels_file)
  raise "Missing MNIST datafiles\nMNIST datafiles must be present in an mnist/ directory\nDownload from: http://yann.lecun.com/exdb/mnist/"
end

# MNIST loading code adapted from here:
# https://github.com/shuyo/iir/blob/master/neural/mnist.rb
n_rows = n_cols = nil
images = []
labels = []
Zlib::GzipReader.open(mnist_images_file) do |f|
  magic, n_images = f.read(8).unpack('N2')
  raise 'This is not MNIST image file' if magic != 2051
  n_rows, n_cols = f.read(8).unpack('N2')
  n_images.times do
    images << f.read(n_rows * n_cols)
  end
end

Zlib::GzipReader.open(mnist_labels_file) do |f|
  magic, n_labels = f.read(8).unpack('N2')
  raise 'This is not MNIST label file' if magic != 2049
  labels = f.read(n_labels).unpack('C*')
end

# collate image and label data
data = images.map.with_index do |image, i|
  target = [0] * 10
  target[labels[i]] = 1
  [image, target]
end

data.shuffle!

x_data = []
y_data = []
train_size = 5000
test_size = 10_000

normalize = lambda do |val, from_low, from_high, to_low, to_high|
  (val - from_low) * (to_high - to_low) / (from_high - from_low).to_f
end

data.each do |row|
  image = row[0].unpack('C*')
  image = image.map { |v| normalize.call(v, 0, 256, 0, 1) }
  x_data << image
  y_data << row[1]
end

x_train = x_data.slice(0, train_size)
y_train = y_data.slice(0, train_size)

x_test = x_data.slice(train_size, test_size)
y_test = y_data.slice(train_size, test_size)

net = Net.new([80], 28 * 28, %w[0 1 2 3 4 5 6 7 8 9])
net.train_network(x_train, y_train)

def one_hot_to_number(one_hot_array)
  one_hot_array.find_index(1).to_s
end

correct = 0
wrong = 0

x_test.each_with_index do |test_data, index|
  result = net.process(test_data)
  if result.key(result.values.max) == one_hot_to_number(y_test[index])
    correct += 1
  else
    wrong += 1
  end
end

p "WRONG #{wrong}"
p "CORRECT #{correct}"
