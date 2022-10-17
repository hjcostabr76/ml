'''
    TODO: 2022-10-17 - ADD Description
    PARAMETERS
'''


# *
# dataset = 'emma'
# dataroot = '../file'

# *

val_rate = .05
skipped_files = []
combined_feature_file = 'feature-lpc.npy'
combined_blendshapes_file = 'blendshape.txt'

# wav_path = os.path.join(dataroot, 'emma-subset-16k')
feature_dir = os.path.join(dataroot, 'feature-lpc')
combine_path = os.path.join(dataroot, 'emma-combine')
blendshape_dir = os.path.join(dataroot, 'emma-a2f-json')










problems_too_short = [ # Files with less then 64 frames
    'Chapter_19-104',
    'Chapter_25-121',
    'Chapter_42-166',
]

problems_frame_diff = [ # Files whose wav frames count is not 32 frames more than blend shape frames count
    'Chapter_14-97',
    'Chapter_19-126',
    'Chapter_19-4',
    'Chapter_2-13',
    'Chapter_2-159',
    'Chapter_20-3',
    'Chapter_33-1',
    'Chapter_36-30',
    'Chapter_39-14',
    'Chapter_39-254',
    'Chapter_40-7',
    'Chapter_44-213',
    'Chapter_47-148',
    'Chapter_5-116',
    'Chapter_53-23',
    'Chapter_56-18',
]

test_files = [
    'Chapter_35-51',
    'Chapter_17-74',
    'Chapter_50-47',
    'Chapter_52-120',
    'Chapter_9-219',
    'Chapter_18-18',
    'Chapter_27-370',
    'Chapter_36-68',
    'Chapter_39-250'
]

skipped_files = test_files + problems_frame_diff + problems_too_short