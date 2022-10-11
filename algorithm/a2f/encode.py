import os
# from tqdm import tqdm
from . import LPC

'''
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
    TODO: 2022-10-11 - ADD Description
'''


lpc = LPC(_num_worker=_num_worker)


for wav_file in skipped_files:
    base_name = wav_file.split('.')[0]
    feature_file = base_name + '-lpc' + '.npy'
    path_wav_file = os.path.join(wav_path, wav_file)
    path_feature_file = os.path.join(feature_path, feature_file)

    try:
        lpc.audio_lpc(path_wav_file, path_feature_file)
    except AssertionError as error:
        print(error)
        print(f'failed file: "{wav_file}"')
