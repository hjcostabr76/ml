
'''
    TODO: 2022-10-17 - ADD Description
    UTILS
'''



def assert_training_stage(stage: str) -> None:
    if type not in ['train', 'val', 'test']:
        raise ValueError(f"training stage type should be 'train', 'val', 'test' ('{type}' given)")

def get_file_name(path: str) -> str:
    pathname, extension = os.path.splitext(path)
    return pathname.split('/')[-1]

def save_features(features: np.array, type: str = 'train') -> None:
    assert_training_stage(type)
    file_path = os.path.join(combine_path, type, combined_feature_file)
    np.save(file_path, features)

def save_blendshapes(blendshapes: np.array, type: str = 'train') -> None:
    assert_training_stage(type)
    file_path = os.path.join(combine_path, type, combined_blendshapes_file)
    np.savetxt(file_path, blendshapes, fmt='%.8f')



# class Paths:

#     pass 


#     def feature_file(self, base_name: str) -> str:
#         return base_name + '-lpc.npy'

#     def blendshape_file(self, base_name: str) -> str:
#         return base_name + '.json'