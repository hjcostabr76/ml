import os

__all__ = ['feature_file', 'blendshape_file', 'wav_file']

def _get_file_name(path: str) -> str:
    pathname, extension = os.path.splitext(path)
    return pathname.split('/')[-1]

def feature_file(base_name: str) -> str:
    return _get_file_name(base_name) + '-lpc.npy'

def blendshape_file(base_name: str) -> str:
    return _get_file_name(base_name) + '.json'

def wav_file(base_name: str) -> str:
    return _get_file_name(base_name) + '.wav'

def checkpoint_file(epoch: int, is_best = False) -> str:
    file_name = 'model-checkpoint-epoch-{:03}\r'.format(epoch + 1)
    if is_best: file_name += '-best'
    return file_name +'.pth.tar'