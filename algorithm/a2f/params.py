



'''

    parametros: encode / lpc

'''


_num_worker = 8

# data path
dataroot = '. / file'
wav_path = os.path.join(dataroot, 'emma-subset-16k')
feature_path = os.path.join(dataroot, 'feature-lpc')
if not os.path.isdir(feature_path): os.mkdir(feature_path)
skipped_files = ['Chapter_19-104.wav', 'Chapter_25-121.wav', 'Chapter_42-166.wav']
# wav_files = os.listdir(wav_path)