import os
path = '/Users/racar/Desktop/PNG/PNG/Uyari'
files = os.listdir(path)


for index, file in enumerate(files):
    os.rename(os.path.join(path, file), os.path.join(path, ''.join(["2-" + str(index), '.png'])))