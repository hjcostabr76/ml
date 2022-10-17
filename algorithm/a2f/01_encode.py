import os
from . import LPC
from . import paths


lpc = LPC(_num_worker=_num_worker)
wav_files = os.listdir(wav_path)

for wav_file in wav_files:
    if wav_file in skipped_files: continue

    try:
        feature = lpc.wav2lpc(wav_file=os.path.join(wav_path, wav_file))
        feature_file = os.path.join(feature_path, paths.feature_file(base_name))
        np.save(feature_file, feature)
    
    except AssertionError as error:
        print(error)
        print(f'failed file: "{wav_file}"')
