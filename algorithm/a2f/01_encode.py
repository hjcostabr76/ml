import os
from . import LPC
from . import paths

import config
import paths


lpc = LPC(_num_worker=config.n_workers)
wav_files = os.listdir(wav_path)

for file in wav_files:
    if file in skipped_files: continue

    try:
        feature = lpc.wav2lpc(wav_file=paths.wav_file(file))
        np.save(feature, paths.feature_file(file))
    
    except AssertionError as error:
        print(error)
        print(f'failed file: "{file}"')
