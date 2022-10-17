import numpy as np
import os


'''

    PARAMETERS...
    ..........

'''


# problems_too_short = [ # Files with less then 64 frames
#     'Chapter_19-104',
#     'Chapter_25-121',
#     'Chapter_42-166',
# ]

# problems_frame_diff = [ # Files whose wav frames count is not 32 frames more than blend shape frames count
#     'Chapter_14-97',
#     'Chapter_19-126',
#     'Chapter_19-4',
#     'Chapter_2-13',
#     'Chapter_2-159',
#     'Chapter_20-3',
#     'Chapter_33-1',
#     'Chapter_36-30',
#     'Chapter_39-14',
#     'Chapter_39-254',
#     'Chapter_40-7',
#     'Chapter_44-213',
#     'Chapter_47-148',
#     'Chapter_5-116',
#     'Chapter_53-23',
#     'Chapter_56-18',
# ]

# test_files = [
#     'Chapter_35-51',
#     'Chapter_17-74',
#     'Chapter_50-47',
#     'Chapter_52-120',
#     'Chapter_9-219',
#     'Chapter_18-18',
#     'Chapter_27-370',
#     'Chapter_36-68',
#     'Chapter_39-250'
# ]

# skipped_files = test_files + problems_frame_diff + problems_too_short



# '''
#     TODO: 2022-10-17 - ADD Description
#     PARAMETERS
# '''


# # *
# # dataset = 'emma'
# # dataroot = '../file'

# # *

# val_rate = .05
# skipped_files = []
# combined_feature_file = 'feature-lpc.npy'
# combined_blendshapes_file = 'blendshape.txt'

# # wav_path = os.path.join(dataroot, 'emma-subset-16k')
# feature_dir = os.path.join(dataroot, 'feature-lpc')
# combine_path = os.path.join(dataroot, 'emma-combine')
# blendshape_dir = os.path.join(dataroot, 'emma-a2f-json')



# '''
#     TODO: 2022-10-17 - ADD Description
#     UTILS
# '''



# def assert_training_stage(stage: str) -> None:
#     if type not in ['train', 'val', 'test']:
#         raise ValueError(f"training stage type should be 'train', 'val', 'test' ('{type}' given)")

# def get_file_name(path: str) -> str:
#     pathname, extension = os.path.splitext(path)
#     return pathname.split('/')[-1]

# def save_features(features: np.array, type: str = 'train') -> None:
#     assert_training_stage(type)
#     file_path = os.path.join(combine_path, type, combined_feature_file)
#     np.save(file_path, features)

# def save_blendshapes(blendshapes: np.array, type: str = 'train') -> None:
#     assert_training_stage(type)
#     file_path = os.path.join(combine_path, type, combined_blendshapes_file)
#     np.savetxt(file_path, blendshapes, fmt='%.8f')




'''
    TODO: 2022-10-17 - ADD Description
    CODE
'''

n_validation = round(val_rate * len(feature_files))

files = sorted(os.listdir(target_path))
file_names = [get_file_name(f) for f in files if f not in skipped_files]
files_train = file_names[n_validation:]
files_val = file_names[0:n_validation]

combiner = Combiner(feature_dir=feature_dir, blendshape_dir=blendshape_dir)


# Validation
feat_val, blendshape_val = combiner.combine(file_names=files_val)
save_features(features=feat_val, type='val')
save_blendshapes(features=blendshape_val, type='val')

# Train
feat_train, blendshape_train = combiner.combine(file_names=files_train)
save_features(features=blendshape_train, type='train')
save_blendshapes(features=blendshape_train, type='train')
