import numpy as np
import os
import config
import paths

from Combiner import Combiner

def save_combined_blendshapes(blendshapes: np.array, type: str = 'train') -> None:
    np.savetxt(paths.combined_blendshapes(type), blendshapes, fmt='%.8f')

def save_combined_features(features: np.array, type: str = 'train') -> None:
    np.save(paths.combined_features(type), features)

files = sorted(os.listdir(paths.blendshape_dir))
n_validation = round(config.val_rate * len(files))

base_name = lambda f: os.path.splitext(path)[0]
file_names = [base_name(f) for f in files if f not in config.skipped_files]
files_train = file_names[n_validation:]
files_val = file_names[0:n_validation]

combiner = Combiner(feature_dir=paths.feature_dir, blendshape_dir=paths.blendshape_dir)

# Validation
feat_val, blendshape_val = combiner.combine(file_names=files_val)
save_combined_features(features=feat_val, type='val')
save_combined_blendshapes(features=blendshape_val, type='val')

# Train
feat_train, blendshape_train = combiner.combine(file_names=files_train)
save_combined_features(features=blendshape_train, type='train')
save_combined_blendshapes(features=blendshape_train, type='train')
